"""Space trees so they sit side by side instead of overlapping, editing GameMaker room files in place.
Only removes tree instances; everything else in the room file is left exactly as it is.

- Screen-border tree lines keep every other tree (8px gaps: Jordan is 10px wide, so still solid),
  always keeping the trees either side of an opening. Double columns between screens are staggered.
- Other trees are thinned to a 32px grid, and dropped if they crowd a border tree.
Usage: python3 thin_trees.py rooms/r_village/r_village.yy [...]"""
import re, sys

TREES = {"o_tree", "o_tree_dark"}
BORDER_ROWS = {32.0, 192.0, 368.0, 544.0}                          # tree y for cell rows 1, 11, 22, 33
BORDER_COLS = {8.0: 0, 312.0: 1, 328.0: 0, 632.0: 1, 648.0: 0, 952.0: 0}   # tree x -> stagger offset


def thin(path):
    t = open(path, encoding="utf-8", newline="").read()
    nl = "\r\n" if "\r\n" in t else "\n"
    trees = {}
    for line in t.split(nl):
        if '"$GMRInstance"' in line:
            obj = re.search(r'"objectId":\{"name":"(\w+)"', line).group(1)
            if obj in TREES:
                name = re.search(r'"%Name":"(\w+)"', line).group(1)
                x = float(re.search(r'"x":(-?[\d.]+)', line).group(1))
                y = float(re.search(r'"y":(-?[\d.]+)', line).group(1))
                trees[(x, y)] = name
    pos = set(trees)
    kept = set()
    # 1. Border rows
    for (x, y) in pos:
        if y in BORDER_ROWS:
            edge = (x - 16, y) not in pos or (x + 16, y) not in pos
            if int((x - 8) // 16) % 2 == 0 or edge:
                kept.add((x, y))
    # 2. Border columns (staggered)
    for (x, y) in pos:
        if x in BORDER_COLS and y not in BORDER_ROWS:
            edge = (x, y - 16) not in pos or (x, y + 16) not in pos
            if (int((y - 16) // 16) + BORDER_COLS[x]) % 2 == 0 or edge:
                kept.add((x, y))
    border = set(kept)
    # 3. Everything else: a 32px grid, clear of the borders
    for (x, y) in sorted(pos - border, key=lambda p: (p[1], p[0])):
        if not any(abs(x - kx) < 32 and abs(y - ky) < 32 for kx, ky in kept):
            kept.add((x, y))
    dropped = {trees[p] for p in pos - kept}
    out = []
    for line in t.split(nl):
        m = re.search(r'"%Name":"(\w+)"', line) if '"$GMRInstance"' in line else re.search(r'^\s*\{"name":"(\w+)","path":"rooms/', line)
        if m and m.group(1) in dropped:
            continue
        out.append(line)
    open(path, "w", encoding="utf-8", newline="").write(nl.join(out))
    print(f"{path}: {len(pos)} trees -> {len(kept)} ({len(dropped)} removed)")


if __name__ == "__main__":
    for p in sys.argv[1:]:
        thin(p)
