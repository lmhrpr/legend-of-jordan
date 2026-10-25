"""Rebuild the pit gaps in one screen of a room from its tiles, then its walls.

Usage: python3 pit_gaps.py r_canyon_caves 2 2 [reach]
       (room, screen column, screen row, optional jump reach in px, e.g. 32 for stone to stone)

Inside the screen's walls, the black void (456) and the faces of pillars (204, 220) become
o_gap_1 (invisible pits Jordan can jump with the Winged Boots); pillar tops (172) stay floor.
Any o_gap_1 already in that screen is removed first, with its creation code. With a reach,
each gap gets the creation code  reach_ = <reach>;  (how far a jump over it can go).
Then dungeon_solids.py rebuilds the room's walls around them."""
import os, re, subprocess, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from render_room import decode

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
room, sc, sr = sys.argv[1], int(sys.argv[2]), int(sys.argv[3])
reach = int(sys.argv[4]) if len(sys.argv) > 4 else None
PIT = {456, 204, 220}
T, SW, SH = 16, 320, 180
path = f"{ROOT}/rooms/{room}/{room}.yy"
t = open(path, encoding="utf-8", newline="").read()

i = t.index('"%Name":"Tiles_Ground"')
w = int(re.search(r'"SerialiseWidth":(\d+)', t[i:]).group(1))
a = t.index('"TileCompressedData":[', i) + len('"TileCompressedData":[')
G = [v & 0x7FFFF if v > 0 else 0 for v in decode([int(v) for v in re.findall(r"-?\d+", t[a:t.index("]", a)])])]
x0, y0 = sc * SW, sr * SH
c0, c1 = x0 // T, (x0 + SW) // T                     # columns in this screen
r0, r1 = -(-y0 // T), (y0 + SH) // T                 # rows wholly in this screen

# Remove the screen's old gaps
inst_re = re.compile(r'^ *\{"\$GMRInstance".*$\n', re.M)
gone = []
for m in reversed(list(inst_re.finditer(t))):
    s = m.group(0)
    if '"name":"o_gap_1"' not in s:
        continue
    x, y = float(re.search(r'"x":([-\d.]+)', s).group(1)), float(re.search(r'"y":([-\d.]+)', s).group(1))
    if x0 <= x < x0 + SW and y0 <= y < y0 + SH:
        n = re.search(r'"%Name":"(\w+)"', s).group(1)
        gone.append(n)
        t = t[:m.start()] + t[m.end():]
        code = f"{ROOT}/rooms/{room}/InstanceCreationCode_{n}.gml"
        if os.path.exists(code):
            os.remove(code)
for n in gone:      # (after: the creation order list is above the instances, so this shifts them)
    t = re.sub(r' *\{"name":"%s","path":"rooms/%s/%s.yy",\},\n' % (n, room, room), "", t, count=1)
open(path, "w", encoding="utf-8", newline="").write(t)

# Runs of pit tiles, row by row
runs = []
for r in range(r0, r1):
    c = c0
    while c < c1:
        if G[r * w + c] in PIT:
            s = c
            while c < c1 and G[r * w + c] in PIT:
                c += 1
            runs.append((s, r, c - s))
        else:
            c += 1
if runs:
    subprocess.run(["python3", f"{ROOT}/_tools/add_instances.py", room, "o_gap_1"] + [f"{s * T},{r * T}" for s, r, n in runs],
                   check=True, stdout=subprocess.DEVNULL)
t = open(path, encoding="utf-8", newline="").read()
for s, r, n in runs:
    pat = re.compile(r'^ *\{"\$GMRInstance".*"name":"o_gap_1".*"x":%s\.0,"y":%s\.0.*$' % (s * T, r * T), re.M)
    ms = list(pat.finditer(t))
    assert len(ms) == 1, (s, r, len(ms))
    line = re.sub(r'"scaleX":[\d.]+', f'"scaleX":{float(n)}', ms[0].group(0))
    if reach:
        line = line.replace('"hasCreationCode":false', '"hasCreationCode":true')
        name = re.search(r'"%Name":"(\w+)"', line).group(1)
        open(f"{ROOT}/rooms/{room}/InstanceCreationCode_{name}.gml", "w", newline="").write(
            f"reach_ = {reach};\t\t// how far a jump over this pit can go (px)\n")
    t = t[:ms[0].start()] + line + t[ms[0].end():]
open(path, "w", encoding="utf-8", newline="").write(t)
print(f"{room} screen ({sc},{sr}): removed {len(gone)} gaps, added {len(runs)}" + (f" (reach {reach})" if reach else ""))
subprocess.run(["python3", f"{ROOT}/_tools/dungeon_solids.py", room], check=True)
