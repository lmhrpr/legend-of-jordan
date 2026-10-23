"""Render a preview PNG of a GameMaker room file (tiles + instance sprites), as laid out in the project.
Usage: python3 render_room.py r_village out.png [--debug]"""
import json, os, re, sys
from PIL import Image

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
EMPTY = -2147483648


def load(p):
    return json.loads(re.sub(r",(\s*[}\]])", r"\1", open(p, encoding="utf-8").read()))


def sprite(name, frame=0):
    y = load(f"{ROOT}/sprites/{name}/{name}.yy")
    f = y["frames"][min(frame, len(y["frames"]) - 1)]["name"]
    return Image.open(f"{ROOT}/sprites/{name}/{f}.png").convert("RGBA"), (y["sequence"]["xorigin"], y["sequence"]["yorigin"])


def decode(data):
    out, i = [], 0
    while i < len(data):
        n = data[i]
        if n < 0:
            out += [data[i + 1]] * (-n); i += 2
        else:
            out += data[i + 1:i + 1 + n]; i += 1 + n
    return out


def render(room, debug=False):
    y = load(f"{ROOT}/rooms/{room}/{room}.yy")
    W, H = y["roomSettings"]["Width"], y["roomSettings"]["Height"]
    im = Image.new("RGBA", (W, H), (0, 0, 0, 255))
    layers = list(reversed(y["layers"]))          # bottom-most first
    for L in layers:
        if L["resourceType"] == "GMRBackgroundLayer" and L.get("spriteId"):
            bg, _ = sprite(L["spriteId"]["name"])
            for yy in range(0, H, bg.height):
                for xx in range(0, W, bg.width):
                    im.alpha_composite(bg, (xx, yy))
        elif L["resourceType"] == "GMRTileLayer":
            ts = load(f"{ROOT}/tilesets/{L['tilesetId']['name']}/{L['tilesetId']['name']}.yy")
            sheet, _ = sprite(ts["spriteId"]["name"])
            tw, th = ts.get("tileWidth", 16), ts.get("tileHeight", 16)
            cols = sheet.width // tw
            cells = decode(L["tiles"]["TileCompressedData"])
            w = L["tiles"]["SerialiseWidth"]
            for k, v in enumerate(cells):
                if v == EMPTY or v <= 0:
                    continue
                v &= 0x7FFFF
                t = sheet.crop(((v % cols) * tw, (v // cols) * th, (v % cols) * tw + tw, (v // cols) * th + th))
                im.alpha_composite(t, ((k % w) * tw, (k // w) * th))
    insts = [i for L in layers for i in L.get("instances", [])]
    objs = {}
    for i in sorted(insts, key=lambda i: i["y"]):
        o = i["objectId"]["name"]
        if o not in objs:
            oy = load(f"{ROOT}/objects/{o}/{o}.yy")
            objs[o] = (oy["spriteId"]["name"] if oy["spriteId"] else None, oy["visible"])
        spr, vis = objs[o]
        if spr is None or (not vis and not debug):
            continue
        img, (ox, oy_) = sprite(spr)
        if i["scaleX"] != 1 or i["scaleY"] != 1:
            img = img.resize((max(1, int(img.width * i["scaleX"])), max(1, int(img.height * i["scaleY"]))), Image.NEAREST)
            ox, oy_ = ox * i["scaleX"], oy_ * i["scaleY"]
        layer = Image.new("RGBA", im.size, (0, 0, 0, 0))
        layer.paste(img, (int(i["x"] - ox), int(i["y"] - oy_)), img)
        im.alpha_composite(layer)
    return im


if __name__ == "__main__":
    render(sys.argv[1], "--debug" in sys.argv).save(sys.argv[2])
