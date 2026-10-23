"""Add instances of an object to a room, copying the format of an existing instance.
Usage: python3 add_instances.py r_desert o_rock 312,128 312,144 ...
       (name an instance with name@x,y, e.g. i_ruins_out@552,98)"""
import hashlib, os, re, sys
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
room, objname = sys.argv[1], sys.argv[2]
coords = []
for c in sys.argv[3:]:
    given, _, pos = c.rpartition("@")
    coords.append((given or None, *map(float, pos.split(","))))
path = f"{ROOT}/rooms/{room}/{room}.yy"
t = open(path, encoding="utf-8", newline="").read()
lines = list(re.finditer(r'^ *\{"\$GMRInstance".*$\n', t, re.M))
template = next((m.group(0) for m in lines if f'"name":"{objname}"' in m.group(0)), None)
if template is None:
    # None in this room yet: copy any plain instance and switch its object
    template = next(m.group(0) for m in lines if '"hasCreationCode":false' in m.group(0))
    template = re.sub(r'"objectId":\{"name":"\w+","path":"objects/\w+/\w+\.yy",\}',
                      f'"objectId":{{"name":"{objname}","path":"objects/{objname}/{objname}.yy",}}', template)
    template = re.sub(r'"scaleX":[\d.]+,"scaleY":[\d.]+', '"scaleX":1.0,"scaleY":1.0', template)
taken = set(re.findall(r'"name":"(inst_[0-9A-F]+)"', t))
new, names = "", []
for given, x, y in coords:
    h = hashlib.md5(f"{room}:{objname}:{x},{y}".encode()).hexdigest().upper()
    k = 0
    while f"inst_{h[k:k+8]}" in taken:
        k += 1
    n = given or f"inst_{h[k:k+8]}"
    assert n not in taken, f"{n} already exists"
    taken.add(n); names.append(n)
    old = re.search(r'"%Name":"([^"]+)"', template).group(1)
    s = template.replace(f'"%Name":"{old}"', f'"%Name":"{n}"').replace(f'"name":"{old}"', f'"name":"{n}"')
    new += re.sub(r'"x":[-\d.]+,"y":[-\d.]+', f'"x":{x},"y":{y}', s)
t = t[:lines[-1].end()] + new + t[lines[-1].end():]
co = t.index("  ],", t.index('"instanceCreationOrder":['))
t = t[:co] + "".join(f'    {{"name":"{n}","path":"rooms/{room}/{room}.yy",}},\n' for n in names) + t[co:]
open(path, "w", encoding="utf-8", newline="").write(t)
print(f"added {len(names)} {objname}")
