"""Swap tiles for objects (e.g. block tiles for o_block), removing the tiles.
Usage: python3 tiles_to_objects.py r_dungeon1 414 o_block [floor_tile]
Tiles on Tiles_Decor are cleared; tiles on Tiles_Ground are replaced by floor_tile (if given)."""
import os, re, subprocess, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from render_room import decode
from roomgen import compress

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
room, tile, obj = sys.argv[1], int(sys.argv[2]), sys.argv[3]
floor = int(sys.argv[4]) if len(sys.argv) > 4 else None
EMPTY = -2147483648
path = f"{ROOT}/rooms/{room}/{room}.yy"
t = open(path, encoding="utf-8", newline="").read()
cells = []
for name in ("Tiles_Decor", "Tiles_Ground"):
    if f'"%Name":"{name}"' not in t:
        continue
    i = t.index(f'"%Name":"{name}"')
    w = int(re.search(r'"SerialiseWidth":(\d+)', t[i:]).group(1))
    a = t.index('"TileCompressedData":[', i) + len('"TileCompressedData":[')
    b = t.index(']', a)
    data = decode([int(v) for v in re.findall(r'-?\d+', t[a:b])])
    hits = [n for n, v in enumerate(data) if v > 0 and v & 0x7FFFF == tile]
    if not hits:
        continue
    for n in hits:
        cells.append((n % w, n // w))
        data[n] = EMPTY if name == "Tiles_Decor" or floor is None else floor
    flat = ",".join(map(str, compress(data))).split(",")
    body = "\n" + "".join("          " + ",".join(flat[k:k + 24]) + ",\n" for k in range(0, len(flat), 24)) + "        "
    t = t[:a] + body + t[b:]
open(path, "w", encoding="utf-8", newline="").write(t)
cells = sorted(set(cells), key=lambda p: (p[1], p[0]))
if cells:
    subprocess.run([sys.executable, f"{ROOT}/_tools/add_instances.py", room, obj] + [f"{c * 16},{r * 16}" for c, r in cells], check=True)
print(f"{room}: {len(cells)} tile {tile} -> {obj}")
