"""Rebuild a dungeon room's o_solid blocks from its tiles (after walls/doorways are repainted).
Usage: python3 dungeon_solids.py r_dungeon1

Solid: wall tiles (ground or decor layer), blocks and torches on the decor layer, and empty cells
(the black rows between screens), except where a doorway runs through them.
Everything else (floors, doorway tiles, stairs, spikes) is walkable."""
import os, re, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from render_room import decode

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
WALLS = {1, 240, 241, 242, 243, 244, 256, 258, 259, 260, 272, 273, 274, 275, 276, 277, 278,
         305, 307, 323, 336, 352, 456, 414, 218}
DOORWAY = {237, 247, 248, 249, 250, 263, 264, 265, 266, 279, 280}
room = sys.argv[1]
path = f"{ROOT}/rooms/{room}/{room}.yy"
t = open(path, encoding="utf-8", newline="").read()


def layer(name):
    i = t.index(f'"%Name":"{name}"')
    w = int(re.search(r'"SerialiseWidth":(\d+)', t[i:]).group(1))
    a = t.index('"TileCompressedData":[', i) + len('"TileCompressedData":[')
    cells = decode([int(v) for v in re.findall(r'-?\d+', t[a:t.index(']', a)])])
    return w, [v & 0x7FFFF if v > 0 else None for v in cells]


w, ground = layer("Tiles_Ground")
_, decor = layer("Tiles_Decor")
h = len(ground) // w
G = lambda c, r: ground[r * w + c] if 0 <= c < w and 0 <= r < h else None
D = lambda c, r: decor[r * w + c] if 0 <= c < w and 0 <= r < h else None
solid = set()
for r in range(h):
    for c in range(w):
        g, d = G(c, r), D(c, r)
        if g in DOORWAY or d in DOORWAY or g == 294 or d == 294:
            continue
        if g is None and d is None:
            # the gap between screens: open only where a doorway runs through it
            if G(c, r - 1) in DOORWAY and G(c, r + 1) in DOORWAY:
                continue
            solid.add((c, r))
        elif (d if d is not None else g) in WALLS:      # the decor layer (painted on top) decides
            solid.add((c, r))

# Gaps (o_gap and its children) are jumped, not walls
for m in re.finditer(r'"objectId":\{"name":"(o_gap\w*)"[^\n]*?"x":([-\d.]+),"y":([-\d.]+)', t):
    solid.discard((int(float(m.group(2))) // 16, int(float(m.group(3))) // 16))

# Replace the room's o_solid instances
inst_re = re.compile(r'^ *\{"\$GMRInstance".*$\n', re.M)
lines = [m for m in inst_re.finditer(t) if '"name":"o_solid"' in m.group(0)]
template = lines[0].group(0)
old = [re.search(r'"%Name":"([^"]+)"', m.group(0)).group(1) for m in lines]
for m in sorted(lines, key=lambda m: -m.start()):
    t = t[:m.start()] + t[m.end():]
for n in old:
    t = re.sub(r' *\{"name":"%s","path":"rooms/%s/%s.yy",\},\n' % (n, room, room), "", t, count=1)
taken = set(re.findall(r'"name":"(inst_[0-9A-F]+)"', t))
new_lines, names = "", []
k = 0
for r in range(h):
    c = 0
    while c < w:
        if (c, r) not in solid:
            c += 1
            continue
        e = c
        while e < w and (e, r) in solid:
            e += 1
        while True:
            k += 1
            n = f"inst_5D{k:06X}"
            if n not in taken:
                break
        names.append(n)
        old_n = re.search(r'"%Name":"([^"]+)"', template).group(1)
        s = template.replace(f'"%Name":"{old_n}"', f'"%Name":"{n}"').replace(f'"name":"{old_n}"', f'"name":"{n}"')
        s = re.sub(r'"scaleX":[\d.]+,"scaleY":[\d.]+', f'"scaleX":{float(e - c)},"scaleY":1.0', s)
        s = re.sub(r'"x":[-\d.]+,"y":[-\d.]+', f'"x":{float(c * 16)},"y":{float(r * 16)}', s)
        new_lines += s
        c = e
last = list(inst_re.finditer(t))[-1]
t = t[:last.end()] + new_lines + t[last.end():]
co = t.index("  ],", t.index('"instanceCreationOrder":['))
t = t[:co] + "".join(f'    {{"name":"{n}","path":"rooms/{room}/{room}.yy",}},\n' for n in names) + t[co:]
open(path, "w", encoding="utf-8", newline="").write(t)
print(f"{room}: {len(old)} o_solid replaced by {len(names)} ({len(solid)} solid cells)")
