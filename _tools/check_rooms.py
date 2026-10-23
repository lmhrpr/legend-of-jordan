"""Reachability check that reads the real GameMaker room files (so it works on rooms edited in GameMaker).

For each room: flood-fills Jordan's feet box from a start position through every solid object,
then checks that doors, people, signs and items can be reached, and (in the village) that the
only ways between screens are the intended gaps in the tree borders.
Usage: python3 check_rooms.py   (run from the project root)"""
import json, os, re, sys
import numpy as np

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PX0, PX1, PY0, PY1 = -5, 4, -5, -2        # Jordan's feet box relative to his origin


def load(path):
    return json.loads(re.sub(r",(\s*[}\]])", r"\1", open(path, encoding="utf-8").read()))


_objects, _sprites = {}, {}


def obj(name):
    if name not in _objects:
        y = load(f"{ROOT}/objects/{name}/{name}.yy")
        _objects[name] = (y["spriteId"]["name"] if y["spriteId"] else None,
                          y["parentObjectId"]["name"] if y["parentObjectId"] else None)
    return _objects[name]


def is_solid(name):
    while name:
        if name == "o_solid":
            return True
        name = obj(name)[1]
    return False


def sprite_box(spr):
    if spr not in _sprites:
        y = load(f"{ROOT}/sprites/{spr}/{spr}.yy")
        ox, oy = y["sequence"]["xorigin"], y["sequence"]["yorigin"]
        _sprites[spr] = (y["bbox_left"] - ox, y["bbox_top"] - oy, y["bbox_right"] - ox, y["bbox_bottom"] - oy)
    return _sprites[spr]


def instances(room):
    y = load(f"{ROOT}/rooms/{room}/{room}.yy")
    out = []
    for layer in y["layers"]:
        for i in layer.get("instances", []):
            out.append(dict(name=i["name"], obj=i["objectId"]["name"], x=i["x"], y=i["y"], sx=i["scaleX"], sy=i["scaleY"]))
    return y["roomSettings"]["Width"], y["roomSettings"]["Height"], out


def box(i):
    spr = obj(i["obj"])[0]
    l, t, r, b = sprite_box(spr)
    return (i["x"] + l * i["sx"], i["y"] + t * i["sy"], i["x"] + (r + 1) * i["sx"] - 1, i["y"] + (b + 1) * i["sy"] - 1)


def flood(w, h, insts, start, ignore=()):
    blocked = np.zeros((h, w), bool)
    for i in insts:
        if i["obj"] in ignore or not is_solid(i["obj"]):
            continue
        x0, y0, x1, y1 = box(i)
        bx0, by0, bx1, by1 = int(np.floor(x0 - PX1)), int(np.floor(y0 - PY1)), int(np.ceil(x1 - PX0)), int(np.ceil(y1 - PY0))
        blocked[max(by0, 0):max(min(by1 + 1, h), 0), max(bx0, 0):max(min(bx1 + 1, w), 0)] = True
    # Doors are exits: Jordan leaves the room as soon as his feet touch one, so the flood stops there
    exits = np.zeros((h, w), bool)
    for i in insts:
        if i["obj"] == "o_door":
            x0, y0, x1, y1 = box(i)
            exits[max(int(y0 - PY1), 0):max(min(int(y1 - PY0) + 1, h), 0), max(int(x0 - PX1), 0):max(min(int(x1 - PX0) + 1, w), 0)] = True
    seen = np.zeros((h, w), bool)
    sx, sy = int(start[0]), int(start[1])
    if blocked[sy, sx]:
        sys.exit(f"start {start} is inside a wall")
    stack = [(sx, sy)]
    seen[sy, sx] = True
    while stack:
        x, y = stack.pop()
        if exits[y, x] and (x, y) != (sx, sy):
            continue
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            nx, ny = x + dx, y + dy
            if 0 <= nx < w and 0 <= ny < h and not seen[ny, nx] and not blocked[ny, nx]:
                seen[ny, nx] = True
                stack.append((nx, ny))
    return seen


def reachable(seen, target, reach):
    x0, y0, x1, y1 = target
    ys, xs = np.nonzero(seen)
    return bool(((xs + PX1 >= x0 - reach) & (xs + PX0 <= x1 + reach) & (ys + PY1 >= y0 - reach) & (ys + PY0 <= y1 + reach)).any())


TALK = {"o_mum", "o_dad", "o_granny", "o_granda", "o_keeper", "o_sign", "o_sweetie_tin", "o_save_point", "o_letter", "o_ruin_entrance", "o_bush"}
TOUCH = {"o_door", "o_sword_pickup", "o_heart_pickup", "o_gem_pickup"}
STARTS = {"r_village": "i_game_start", "r_old_forest": "i_forest_entrance", "r_desert": "i_desert_entrance",
          "r_home": "i_home_in", "r_granny": "i_granny_in", "r_post_office": "i_post_office_in"}

# Village: intended openings between screens (pixel ranges along each border line)
VILLAGE_OPENINGS = {
    ("v", 320): [(80, 160), (256, 336), (416, 496)],     # x=320: screens 1-2, 4-5, 7-8
    ("v", 640): [(80, 160), (416, 496)],                 # x=640: screens 2-3, 8-9
    ("h", 180): [(128, 176)],                            # y=180: screens 1-4
    ("h", 360): [(128, 176), (768, 816)],                # y=360: screens 4-7, 6-9
}


def main():
    problems = 0
    for room, start_name in STARTS.items():
        w, h, insts = instances(room)
        named = {i["name"]: i for i in insts}
        start = named[start_name]
        targets = [(f'{i["obj"]}@{int(i["x"])},{int(i["y"])}', box(i), 20 if i["obj"] in TALK else 0)
                   for i in insts if i["obj"] in TALK | TOUCH]
        for phase, ignore in (("no sword", ()), ("with sword", ("o_bush",))):
            seen = flood(w, h, insts, (start["x"], start["y"]), ignore)
            missing = [k for k, b, r in targets if not reachable(seen, b, r)]
            note = ""
            if phase == "no sword" and room == "r_village":
                behind_bushes = [k for k in missing if int(k.split("@")[1].split(",")[1]) < 40]
                missing = [k for k in missing if k not in behind_bushes]
                note = f" (+{len(behind_bushes)} behind the forest bushes, as intended)" if behind_bushes else "  WARNING: Old Forest not blocked by bushes"
                problems += 0 if behind_bushes else 1
            ok = len(targets) - len(missing) - (len(behind_bushes) if note.startswith(" (+") else 0)
            print(f"{room} [{phase}]: {ok}/{len(targets)} reachable{note}" + (f"  MISSING {missing}" if missing else ""))
            problems += len(missing)
            if room == "r_village" and phase == "with sword":
                for (kind, pos), opens in VILLAGE_OPENINGS.items():
                    if kind == "v":
                        line = seen[:, pos]
                        hits = [y for y in np.nonzero(line)[0] if not any(a <= y <= b for a, b in opens)]
                    else:
                        line = seen[pos, :]
                        hits = [x for x in np.nonzero(line)[0] if not any(a <= x <= b for a, b in opens)]
                    if hits:
                        print(f"  LEAK across {kind}-border {pos} at {hits[0]}..{hits[-1]}")
                        problems += 1
    print("OK" if not problems else f"{problems} problem(s)")
    return problems


if __name__ == "__main__":
    sys.exit(1 if main() else 0)
