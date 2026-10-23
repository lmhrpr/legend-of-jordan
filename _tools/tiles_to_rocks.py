"""Swap rock tiles (ts_top_down tile 68 on Tiles_Decor) for o_rock instances, and remove
the o_solid collision under them (splitting stretched o_solid runs where they cover other things).
Usage: python3 tiles_to_rocks.py r_desert"""
import hashlib, os, re, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from render_room import decode
from roomgen import compress

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ROCK, EMPTY, G = 68, -2147483648, 16
room = sys.argv[1]
path = f"{ROOT}/rooms/{room}/{room}.yy"
t = open(path, encoding="utf-8", newline="").read()

# --- rock cells from Tiles_Decor ---
i = t.index('"%Name":"Tiles_Decor"')
w = int(re.search(r'"SerialiseWidth":(\d+)', t[i:]).group(1))
a = t.index('"TileCompressedData":[', i) + len('"TileCompressedData":[')
b = t.index(']', a)
cells = decode([int(v) for v in re.findall(r'-?\d+', t[a:b])])
rocks = {(n % w, n // w) for n, v in enumerate(cells) if v != EMPTY and (v & 0x7FFFF) == ROCK}
cells = [EMPTY if (n % w, n // w) in rocks else v for n, v in enumerate(cells)]
data = compress(cells)
lines = ",".join(map(str, data)).split(",")
body = "\n" + "".join("          " + ",".join(lines[k:k + 24]) + ",\n" for k in range(0, len(lines), 24)) + "        "
t = t[:a] + body + t[b:]

# --- o_solid instances ---
inst_re = re.compile(r'^ *\{"\$GMRInstance".*$\n', re.M)
solid_lines = [m for m in inst_re.finditer(t) if '"name":"o_solid"' in m.group(0)]
template = solid_lines[0].group(0)
removed, new_lines = [], []
taken = set(re.findall(r'"name":"(inst_[0-9A-F]+)"', t))


def name_for(key):
    h = hashlib.md5(f"{room}:{key}".encode()).hexdigest().upper()
    k = 0
    while f"inst_{h[k:k+8]}" in taken:
        k += 1
    n = f"inst_{h[k:k+8]}"; taken.add(n); return n


def inst(obj, x, y, sx, key):
    n = name_for(key)
    s = re.sub(r'"(%Name|name)":"inst_[0-9A-F]+"', lambda m: f'"{m.group(1)}":"{n}"', template)
    s = s.replace('"name":"o_solid","path":"objects/o_solid/o_solid.yy"', f'"name":"{obj}","path":"objects/{obj}/{obj}.yy"')
    s = re.sub(r'"scaleX":[\d.]+', f'"scaleX":{float(sx)}', s)
    s = re.sub(r'"x":[-\d.]+,"y":[-\d.]+', f'"x":{float(x)},"y":{float(y)}', s)
    return n, s


for m in solid_lines:
    s = m.group(0)
    x = float(re.search(r'"x":([-\d.]+)', s).group(1)); y = float(re.search(r'"y":([-\d.]+)', s).group(1))
    sx = float(re.search(r'"scaleX":([\d.]+)', s).group(1)); sy = float(re.search(r'"scaleY":([\d.]+)', s).group(1))
    if x % G or y % G or sy != 1 or sx != int(sx):
        continue
    c0, r = int(x // G), int(y // G)
    run = [(c0 + k, r) for k in range(int(sx))]
    if not any(c in rocks for c in run):
        continue
    removed.append((m, re.search(r'"name":"(inst_[0-9A-F]+)"', s).group(1)))
    # keep o_solid over any part of the run that isn't a rock
    k = 0
    while k < len(run):
        if run[k] in rocks:
            k += 1; continue
        e = k
        while e < len(run) and run[e] not in rocks:
            e += 1
        new_lines.append(inst("o_solid", run[k][0] * G, r * G, e - k, f"solid:{run[k]}"))
        k = e
for (c, r) in sorted(rocks, key=lambda p: (p[1], p[0])):
    new_lines.append(inst("o_rock", c * G, r * G, 1, f"rock:{c},{r}"))

# remove old lines (back to front), add new ones after the last instance line
for m, n in sorted(removed, key=lambda p: -p[0].start()):
    t = t[:m.start()] + t[m.end():]
for m, n in removed:
    t = re.sub(r' *\{"name":"%s","path":"rooms/%s/%s.yy",\},\n' % (n, room, room), "", t, count=1)
last = list(inst_re.finditer(t))[-1]
t = t[:last.end()] + "".join(s for _, s in new_lines) + t[last.end():]
co_end = t.index("  ],", t.index('"instanceCreationOrder":['))
t = t[:co_end] + "".join(f'    {{"name":"{n}","path":"rooms/{room}/{room}.yy",}},\n' for n, _ in new_lines) + t[co_end:]
open(path, "w", encoding="utf-8", newline="").write(t)
print(f"{len(rocks)} rock tiles -> o_rock; {len(removed)} o_solid removed, "
      f"{sum(1 for n, s in new_lines if 'o_solid' in s)} o_solid pieces kept for non-rock cells")
