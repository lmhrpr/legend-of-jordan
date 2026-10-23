"""Add instances of an object to a room, copying the format of an existing instance.
Usage: python3 add_instances.py r_desert o_rock 312,128 312,144 ..."""
import hashlib, os, re, sys
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
room, objname, coords = sys.argv[1], sys.argv[2], [tuple(map(float, c.split(","))) for c in sys.argv[3:]]
path = f"{ROOT}/rooms/{room}/{room}.yy"
t = open(path, encoding="utf-8", newline="").read()
lines = list(re.finditer(r'^ *\{"\$GMRInstance".*$\n', t, re.M))
template = next((m.group(0) for m in lines if f'"name":"{objname}"' in m.group(0)), None)
assert template, f"no {objname} in {room} to copy"
taken = set(re.findall(r'"name":"(inst_[0-9A-F]+)"', t))
new, names = "", []
for x, y in coords:
    h = hashlib.md5(f"{room}:{objname}:{x},{y}".encode()).hexdigest().upper()
    k = 0
    while f"inst_{h[k:k+8]}" in taken:
        k += 1
    n = f"inst_{h[k:k+8]}"; taken.add(n); names.append(n)
    s = re.sub(r'"(%Name|name)":"inst_[0-9A-F]+"', lambda m: f'"{m.group(1)}":"{n}"', template)
    new += re.sub(r'"x":[-\d.]+,"y":[-\d.]+', f'"x":{x},"y":{y}', s)
t = t[:lines[-1].end()] + new + t[lines[-1].end():]
co = t.index("  ],", t.index('"instanceCreationOrder":['))
t = t[:co] + "".join(f'    {{"name":"{n}","path":"rooms/{room}/{room}.yy",}},\n' for n in names) + t[co:]
open(path, "w", encoding="utf-8", newline="").write(t)
print(f"added {len(names)} {objname}")
