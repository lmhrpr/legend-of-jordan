"""Rebuild a room's o_solid blocks from its tiles (after walls are repainted).
Usage: python3 dungeon_solids.py r_dungeon1   (blocks are made at 8px, so doorway pillars are solid)
       python3 dungeon_solids.py r_canyon     (the canyon's raised ground: rims, sides and cliff faces)

Solid: wall tiles (ground or decor layer), blocks and torches on the decor layer, and empty cells
(the black rows between screens), except where a doorway runs through them.
Everything else (floors, doorway tiles, stairs, spikes) is walkable."""
import os, re, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from render_room import decode

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
WALLS = {1, 240, 241, 242, 243, 244, 256, 258, 259, 260, 272, 273, 274, 275, 276, 277, 278,
         305, 307, 323, 336, 352, 456,
         158, 481, 482}     # (blocks are o_block objects now; 158/481/482: parapets, e.g. along cave 3's pit)
DOORWAY = {237, 247, 248, 249, 250, 263, 264, 265, 266, 279, 280}
room = sys.argv[1]
path = f"{ROOT}/rooms/{room}/{room}.yy"
t = open(path, encoding="utf-8", newline="").read()


def layer(name):
    if f'"%Name":"{name}"' not in t:
        return None, None
    i = t.index(f'"%Name":"{name}"')
    w = int(re.search(r'"SerialiseWidth":(\d+)', t[i:]).group(1))
    a = t.index('"TileCompressedData":[', i) + len('"TileCompressedData":[')
    cells = decode([int(v) for v in re.findall(r'-?\d+', t[a:t.index(']', a)])])
    return w, [v & 0x7FFFF if v > 0 else None for v in cells]


w, ground = layer("Tiles_Ground")
_, decor = layer("Tiles_Decor")
h = len(ground) // w
if decor is None:
    decor = [None] * len(ground)
G = lambda c, r: ground[r * w + c] if 0 <= c < w and 0 <= r < h else None
D = lambda c, r: decor[r * w + c] if 0 <= c < w and 0 <= r < h else None
# Doorway tiles are half pillar, half opening: the pillar half is solid.
#   in top/bottom walls: left tiles have the pillar on their left, right tiles on their right
#   in side walls: top tiles have the pillar on top, bottom tiles underneath
PILLAR = {263: "L", 247: "L", 279: "L", 264: "R", 248: "R", 280: "R", 249: "T", 250: "T", 265: "B", 266: "B"}
HALF = {"L": [(0, 0), (0, 1)], "R": [(1, 0), (1, 1)], "T": [(0, 0), (1, 0)], "B": [(0, 1), (1, 1)]}
CANYON = room == "r_canyon"
if CANYON:
    # Raised ground: rims and cliff faces are solid; the side pieces are solid on their outer half;
    # the tops (190), ground, stairs, cave mouths and cracks are walkable.
    WALLS = {110, 111, 126, 127, 141, 142, 143, 157, 158, 159, 173, 174, 175, 205, 206, 207,
             221, 222, 223, 238, 239, 253, 254, 255, 90, 91, 140, 156, 108, 109, 124, 125, 481, 482, 106, 107, 154, 155}
    DOORWAY = {2, 3, 4, 5, 294, 237}
    PILLAR = {189: "L", 191: "R", 478: "L", 479: "R", 480: "T", 172: "B"}   # (478-480, 172: open edges, solid on the outer half)
solid = set()                   # cells at 8px: (c*2 + qx, r*2 + qy)


def fill(c, r, quarters=((0, 0), (1, 0), (0, 1), (1, 1))):
    for qx, qy in quarters:
        solid.add((c * 2 + qx, r * 2 + qy))


for r in range(h):
    for c in range(w):
        g, d = G(c, r), D(c, r)
        top = d if d is not None else g
        if top in PILLAR:
            fill(c, r, HALF[PILLAR[top]])
            continue
        if g in DOORWAY or d in DOORWAY or g == 294 or d == 294:
            continue
        if g is None and d is None:
            # the gap between screens: open only where a doorway runs through it (pillars continue)
            above = G(c, r - 1)
            if above in DOORWAY and G(c, r + 1) in DOORWAY:
                if above in PILLAR:
                    fill(c, r, HALF[PILLAR[above]])
                continue
            fill(c, r)
        elif top in WALLS:          # the decor layer (painted on top) decides
            fill(c, r)

# Gaps (o_gap and its children) are jumped, not walls
for m in re.finditer(r'^.*"objectId":\{"name":"(o_gap\w*)".*$', t, re.M):
    s = m.group(0)
    gx, gy = float(re.search(r'"x":([-\d.]+)', s).group(1)), float(re.search(r'"y":([-\d.]+)', s).group(1))
    sx, sy = float(re.search(r'"scaleX":([-\d.]+)', s).group(1)), float(re.search(r'"scaleY":([-\d.]+)', s).group(1))
    for qx in range(int(gx // 8), int((gx + 16 * sx) // 8)):          # (a stretched gap covers its whole run)
        for qy in range(int(gy // 8), int((gy + 16 * sy) // 8)):
            solid.discard((qx, qy))

# Replace the room's o_solid (or, in the canyon, o_ledge) instances.
# Canyon walls are o_ledge: they stop walking, but Jordan can jump over them from high ground.
OBJ = "o_ledge" if CANYON else "o_solid"
import zlib
PREFIX = "%03X" % (zlib.crc32(room.encode()) & 0xFFF)
inst_re = re.compile(r'^ *\{"\$GMRInstance".*$\n', re.M)
lines = [m for m in inst_re.finditer(t) if re.search(r'"name":"o_(solid|ledge)"', m.group(0))
         and '"hasCreationCode":false' in m.group(0)]
template = re.sub(r'"objectId":\{"name":"\w+","path":"objects/\w+/\w+\.yy",\}',
                  f'"objectId":{{"name":"{OBJ}","path":"objects/{OBJ}/{OBJ}.yy",}}', lines[0].group(0))
old = [re.search(r'"%Name":"([^"]+)"', m.group(0)).group(1) for m in lines]
for m in sorted(lines, key=lambda m: -m.start()):
    t = t[:m.start()] + t[m.end():]
for n in old:
    t = re.sub(r' *\{"name":"%s","path":"rooms/%s/%s.yy",\},\n' % (n, room, room), "", t, count=1)
taken = set(re.findall(r'"name":"(inst_[0-9A-F]+)"', t))
new_lines, names = "", []
k = 0
for r in range(h * 2):
    c = 0
    while c < w * 2:
        if (c, r) not in solid:
            c += 1
            continue
        e = c
        while e < w * 2 and (e, r) in solid:
            e += 1
        while True:
            k += 1
            n = f"inst_{PREFIX}{k:05X}"     # (a prefix per room: instance names are shared by the whole project)
            if n not in taken:
                break
        names.append(n)
        old_n = re.search(r'"%Name":"([^"]+)"', template).group(1)
        s = template.replace(f'"%Name":"{old_n}"', f'"%Name":"{n}"').replace(f'"name":"{old_n}"', f'"name":"{n}"')
        s = re.sub(r'"scaleX":[\d.]+,"scaleY":[\d.]+', f'"scaleX":{(e - c) / 2},"scaleY":0.5', s)
        s = re.sub(r'"x":[-\d.]+,"y":[-\d.]+', f'"x":{float(c * 8)},"y":{float(r * 8)}', s)
        new_lines += s
        c = e
last = list(inst_re.finditer(t))[-1]
t = t[:last.end()] + new_lines + t[last.end():]
co = t.index("  ],", t.index('"instanceCreationOrder":['))
t = t[:co] + "".join(f'    {{"name":"{n}","path":"rooms/{room}/{room}.yy",}},\n' for n in names) + t[co:]
open(path, "w", encoding="utf-8", newline="").write(t)
print(f"{room}: {len(old)} blocks replaced by {len(names)} {OBJ} ({len(solid)} solid 8px cells)")
