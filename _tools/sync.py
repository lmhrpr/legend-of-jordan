"""Copy specific built files into the git repo without touching anything Liam has edited.
Usage: python3 sync.py path [path ...]   (files or folders, relative to the project root)"""
import os, re, shutil, subprocess, sys
OUT = "/home/claude/out/TheLegendOfJordan"
REPO = "/home/claude/legend-of-jordan"
paths = sys.argv[1:]
liam = subprocess.run(["git", "-C", REPO, "log", "--author=lmhrpr", "--name-only", "--format="],
                      capture_output=True, text=True).stdout.split()
clash = sorted({f for f in liam for p in paths if f == p or f.startswith(p.rstrip("/") + "/")})
if clash:
    sys.exit(f"STOP: Liam has edited {clash}; merge by hand")
new_resources = []
for p in paths:
    src, dst = f"{OUT}/{p}", f"{REPO}/{p}"
    if os.path.isdir(src):
        if not os.path.exists(dst) and p.count("/") == 1:
            new_resources.append(p)
        if os.path.exists(dst):
            shutil.rmtree(dst)
        shutil.copytree(src, dst)
    else:
        os.makedirs(os.path.dirname(dst), exist_ok=True)
        shutil.copy(src, dst)
# Register any brand-new resources in Liam's .yyp, in alphabetical order, keeping its format
yyp = f"{REPO}/TheLegendOfJordan.yyp"
t = open(yyp, encoding="utf-8", newline="").read()
nl = "\r\n" if "\r\n" in t else "\n"
for p in new_resources:
    kind, name = p.split("/")
    if f'"name":"{name}"' in t:
        continue
    line = f'    {{"id":{{"name":"{name}","path":"{kind}/{name}/{name}.yy",}},}},'
    entries = list(re.finditer(r'    \{"id":\{"name":"(\w+)","path":"(\w+)/[^"]+",\},\},\r?\n', t))
    after = None
    for m in entries:
        if (m.group(2), m.group(1).lower()) < (kind, name.lower()):
            after = m
    pos = after.end() if after else entries[0].start()
    t = t[:pos] + line + nl + t[pos:]
    print("registered", name)
open(yyp, "w", encoding="utf-8", newline="").write(t)
