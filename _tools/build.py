"""Assemble the rebuilt Legend of Jordan GameMaker project."""
import os, re, shutil, sys
from PIL import Image
sys.path.insert(0, os.path.dirname(__file__))
from gm import OUT, write, ref, folder, load_yy
import sprites, newsprites, objects_table, sounds, roomgen, world

SRC_PROJ = "/home/claude/src/proj"
PREVIEW = "/tmp/claude-0/-home-claude/bfa170d3-60b9-5a2e-b951-afe43e5c5976/scratchpad/preview"

SCRIPT_FOLDERS = {
    "scr_macros": "Scripts/Helper Scripts",
    "scr_helpers": "Scripts/Helper Scripts",
    "scr_movement": "Scripts/Movement Scripts",
    "scr_hitbox": "Scripts/Hitbox Scripts",
    "scr_enemies": "Scripts/Hurtbox Scripts",
    "scr_text": "Scripts/Text Scritps",
    "scr_transition": "Scripts/Effect Scripts",
    "scr_inventory": "Scripts/Inventory Scripts",
    "scr_save": "Scripts/Helper Scripts",
    "scr_tile_animation": "Scripts/Effect Scripts",
}


def main():
    if os.path.exists(OUT):
        shutil.rmtree(OUT)
    os.makedirs(OUT)
    for d in ("fonts", "options"):
        shutil.copytree(f"{SRC_PROJ}/{d}", f"{OUT}/{d}")
    # Crisp pixels, not blurry
    for opt in ("windows/options_windows.yy", "mac/options_mac.yy", "linux/options_linux.yy", "html5/options_html5.yy"):
        p = f"{OUT}/options/{opt}"
        if os.path.exists(p):
            t = open(p).read()
            t = re.sub(r'("option_[a-z0-9]+_interpolate_pixels":)true', r"\1false", t)
            t = t.replace('"option_windows_display_name":"TheLegendOfJordan"', '"option_windows_display_name":"The Legend of Jordan"')
            open(p, "w").write(t)

    resources = []
    resources += [("fonts", f) for f in sorted(os.listdir(f"{OUT}/fonts"))]

    # Sprites
    spr = sprites.convert_all() + newsprites.build()
    resources += [("sprites", s) for s in spr]

    # Scripts
    sdir = os.path.join(os.path.dirname(__file__), "scripts")
    for f in sorted(os.listdir(sdir)):
        name = f[:-4]
        os.makedirs(f"{OUT}/scripts/{name}", exist_ok=True)
        shutil.copy(f"{sdir}/{f}", f"{OUT}/scripts/{name}/{name}.gml")
        write(f"scripts/{name}/{name}.yy", {
            "$GMScript": "v1", "%Name": name, "isCompatibility": False, "isDnD": False, "name": name,
            "parent": folder(SCRIPT_FOLDERS[name]), "resourceType": "GMScript", "resourceVersion": "2.0"})
        resources.append(("scripts", name))

    # Objects
    resources += [("objects", o) for o in objects_table.build()]

    # Sounds
    resources += [("sounds", s) for s in sounds.build()]

    # Tileset and rooms
    roomgen.tileset()
    resources.append(("tilesets", roomgen.TS_NAME))
    rooms = world.all_rooms()
    for r in rooms:
        r.write()
        resources.append(("rooms", r.name))

    # Project file
    yyp = load_yy(f"{SRC_PROJ}/TheLegendOfJordan.yyp")
    folders = {f["folderPath"] for f in yyp["Folders"]}
    for extra in ["Sounds/Effects", "Sounds/Music"]:
        folders.add(f"folders/{extra}.yy")
    yyp_out = {
        "$GMProject": "v1", "%Name": "TheLegendOfJordan",
        "AudioGroups": yyp["AudioGroups"],
        "configs": {"children": [], "name": "Default"},
        "defaultScriptType": 1,
        "Folders": [{"$GMFolder": "", "%Name": fp[8:-3].split("/")[-1], "folderPath": fp,
                     "name": fp[8:-3].split("/")[-1], "resourceType": "GMFolder", "resourceVersion": "2.0"}
                    for fp in sorted(folders, key=str.lower)],
        "ForcedPrefabProjectReferences": [], "IncludedFiles": [], "isEcma": False, "LibraryEmitters": [],
        "MetaData": {"IDEVersion": yyp["MetaData"]["IDEVersion"]},
        "name": "TheLegendOfJordan",
        "resources": [{"id": ref(k, n)} for k, n in sorted(resources, key=lambda x: (x[0], x[1]))],
        "resourceType": "GMProject", "resourceVersion": "2.0",
        "RoomOrderNodes": [{"roomId": ref("rooms", r.name)} for r in rooms],
        "templateType": None,
        "TextureGroups": yyp["TextureGroups"],
    }
    # Pixel art: don't scale/filter the texture page
    write("TheLegendOfJordan.yyp", yyp_out)
    write("TheLegendOfJordan.resource_order", {"FolderOrderSettings": [], "ResourceOrderSettings": []})

    # Previews
    os.makedirs(PREVIEW, exist_ok=True)
    frames = {}
    for s in spr:
        y = load_yy(f"{OUT}/sprites/{s}/{s}.yy")
        frames[s] = [Image.open(f"{OUT}/sprites/{s}/{f['name']}.png").convert("RGBA") for f in y["frames"]]
        frames[s + "#origin"] = (y["sequence"]["xorigin"], y["sequence"]["yorigin"])
    tiles = frames["s_top_down"][0]
    for r in rooms:
        r.preview(f"{PREVIEW}/{r.name}.png", frames, tiles)
        r.preview(f"{PREVIEW}/{r.name}_clean.png", frames, tiles, show_hidden=False)
    print(f"{len(resources)} resources, {len(rooms)} rooms")
    return resources, rooms


if __name__ == "__main__":
    main()
