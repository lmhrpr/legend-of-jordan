"""Object definitions: sprite, parent, flags and folder for every object."""
import os, re, shutil
from gm import OUT, write, ref, folder

SRC = "/home/claude/build/objects"

# name: (sprite, parent, visible, persistent, folder)
OBJECTS = {
    # --- Meta ---
    "o_game":             (None, None, True, True, "Objects/Meta"),
    "o_input":            (None, None, True, True, "Objects/Meta"),
    "o_camera":           (None, None, True, False, "Objects/Meta"),
    "o_animation_effect": (None, None, True, False, "Objects/Meta"),
    "o_transition":       (None, None, True, True, "Objects/Meta"),
    "o_textbox":          (None, None, True, False, "Objects/Meta"),
    "o_title":            (None, None, True, False, "Objects/Meta"),
    # --- Collision ---
    "o_solid":            ("s_solid", None, False, False, "Objects/Collision Objects"),
    "o_door":             ("s_door", None, False, False, "Objects/Collision Objects"),
    "o_hitbox":           (None, None, False, False, "Objects/Collision Objects"),
    "o_interactive":      (None, "o_solid", True, False, "Objects/Collision Objects"),
    "o_start_position":   ("s_start_position", None, False, False, "Objects/Collision Objects"),
    # --- Player ---
    "o_player":           ("s_jordan_run_down_basic", None, True, False, "Objects"),
    # --- Enemies ---
    "o_enemy":            (None, None, True, False, "Objects/Enemies"),
    "o_bat":              ("s_bat", "o_enemy", True, False, "Objects/Enemies"),
    "o_porcupine":        ("s_porcupine_run", "o_enemy", True, False, "Objects/Enemies"),
    # --- NPCs ---
    "o_npc":              (None, "o_interactive", True, False, "Objects/NPCs"),
    "o_mum":              ("s_mum", "o_npc", True, False, "Objects/NPCs"),
    "o_dad":              ("s_dad", "o_npc", True, False, "Objects/NPCs"),
    "o_granny":           ("s_granny", "o_npc", True, False, "Objects/NPCs"),
    "o_granda":           ("s_granda", "o_npc", True, False, "Objects/NPCs"),
    # --- Signs & interactive things ---
    "o_sign":             ("s_signpost", "o_interactive", True, False, "Objects/Signs"),
    "o_sweetie_tin":      ("s_sweetie_tin", "o_interactive", True, False, "Objects/Signs"),
    "o_save_point":       ("s_post_box", "o_interactive", True, False, "Objects/Signs"),
    "o_letter":           ("s_letter", "o_interactive", True, False, "Objects/Signs"),
    # --- Environment ---
    "o_grass":            ("s_grass", None, True, False, "Objects/Environment"),
    "o_bush":             ("s_bush", "o_solid", True, False, "Objects/Environment"),
    "o_old_tree1":        ("s_old_tree1", "o_solid", True, False, "Objects/Environment"),
    "o_tree":             ("s_tree", "o_solid", True, False, "Objects/Environment"),
    "o_tree_dark":        ("s_tree_dark", "o_solid", True, False, "Objects/Environment"),
    "o_darkness":         (None, None, True, False, "Objects/Environment"),
    "o_set_bomb":         ("s_bomb", None, True, False, "Objects/Environment"),
    # --- Items ---
    "o_pickup":           (None, None, True, False, "Objects/Items/Pickups"),
    "o_gem_pickup":       ("s_gem", "o_pickup", True, False, "Objects/Items/Pickups"),
    "o_heart_pickup":     ("s_heart", "o_pickup", True, False, "Objects/Items/Pickups"),
    "o_sword_pickup":     ("s_sword_item", None, True, False, "Objects/Items/Pickups"),
    "o_inv_item":         (None, None, False, True, "Objects/Items/Inventory"),
    "o_sword_item":       ("s_sword_item", "o_inv_item", False, True, "Objects/Items/Inventory"),
    "o_bomb_item":        ("s_bomb_item", "o_inv_item", False, True, "Objects/Items/Inventory"),
    "o_ring_item":        ("s_ring_item", "o_inv_item", False, True, "Objects/Items/Inventory"),
    # --- Audio ---
    "o_play_sound":       ("s_music", None, False, False, "Objects/Audio"),
    "o_forest_music":     ("s_music", "o_play_sound", False, False, "Objects/Audio"),
    "o_village_music":    ("s_music", "o_play_sound", False, False, "Objects/Audio"),
    "o_desert_music":     ("s_music", "o_play_sound", False, False, "Objects/Audio"),
    "o_home_music":       ("s_music", "o_play_sound", False, False, "Objects/Audio"),
    "o_title_music":      ("s_music", "o_play_sound", False, False, "Objects/Audio"),
}

TYPE = {"Create": 0, "Destroy": 1, "Alarm": 2, "Step": 3, "Collision": 4, "Other": 7, "Draw": 8, "CleanUp": 12}


def event_list(name):
    evs = []
    for f in sorted(os.listdir(f"{SRC}/{name}")):
        if not f.endswith(".gml"):
            continue
        kind, rest = f[:-4].split("_", 1)
        col = None
        if kind == "Collision":
            num = 0
            col = ref("objects", rest)
        else:
            num = int(rest)
        evs.append({"$GMEvent": "v1", "%Name": "", "collisionObjectId": col, "eventNum": num,
                    "eventType": TYPE[kind], "isDnD": False, "name": "", "resourceType": "GMEvent",
                    "resourceVersion": "2.0"})
    return evs


def build():
    for name, (spr, parent, visible, persistent, fold) in OBJECTS.items():
        src = f"{SRC}/{name}"
        assert os.path.isdir(src), f"no event code for {name}"
        dst = f"{OUT}/objects/{name}"
        os.makedirs(dst, exist_ok=True)
        for f in os.listdir(src):
            if f.endswith(".gml"):
                text = open(f"{src}/{f}", encoding="utf-8").read().replace("\r\n", "\n")
                open(f"{dst}/{f}", "w", encoding="utf-8", newline="\n").write(text)
        yy = {
            "$GMObject": "", "%Name": name,
            "eventList": event_list(name),
            "managed": True, "name": name, "overriddenProperties": [],
            "parent": folder(fold),
            "parentObjectId": ref("objects", parent) if parent else None,
            "persistent": persistent,
            "physicsAngularDamping": 0.1, "physicsDensity": 0.5, "physicsFriction": 0.2, "physicsGroup": 0,
            "physicsKinematic": False, "physicsLinearDamping": 0.1, "physicsObject": False,
            "physicsRestitution": 0.1, "physicsSensor": False, "physicsShape": 1, "physicsShapePoints": [],
            "physicsStartAwake": True, "properties": [], "resourceType": "GMObject", "resourceVersion": "2.0",
            "solid": False,
            "spriteId": ref("sprites", spr) if spr else None,
            "spriteMaskId": None,
            "visible": visible,
        }
        write(f"objects/{name}/{name}.yy", yy)
    extra = set(os.listdir(SRC)) - set(OBJECTS)
    assert not extra, f"objects without table entries: {extra}"
    return list(OBJECTS)
