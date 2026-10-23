"""Flood-fill Jordan's collision box through each room and check every important thing is reachable."""
import sys, numpy as np
sys.path.insert(0, "/home/claude/build")
from gm import OUT, load_yy
from objects_table import OBJECTS
import world

SOLID_OBJS = {o for o, v in OBJECTS.items() if o == "o_solid" or v[1] in ("o_solid", "o_interactive", "o_npc")}
SOLID_OBJS |= {"o_npc", "o_mum", "o_dad", "o_granny", "o_granda", "o_sign", "o_sweetie_tin", "o_save_point", "o_letter", "o_keeper", "o_ruin_entrance"}
PX0, PX1, PY0, PY1 = -5, 4, -5, -2        # Jordan's feet box relative to his origin
sprite_cache = {}


def sprite_box(spr):
    if spr not in sprite_cache:
        y = load_yy(f"{OUT}/sprites/{spr}/{spr}.yy")
        sprite_cache[spr] = (y["bbox_left"] - y["sequence"]["xorigin"], y["bbox_top"] - y["sequence"]["yorigin"],
                             y["bbox_right"] - y["sequence"]["xorigin"], y["bbox_bottom"] - y["sequence"]["yorigin"])
    return sprite_cache[spr]


def inst_box(i):
    spr = OBJECTS[i["obj"]][0]
    l, t, r, b = sprite_box(spr)
    return (i["x"] + l * i["sx"], i["y"] + t * i["sy"], i["x"] + (r + 1) * i["sx"] - 1, i["y"] + (b + 1) * i["sy"] - 1)


def check(room, start, targets, ignore=()):
    W, H = room.w, room.h
    blocked = np.zeros((H, W), bool)
    for i in room.instances:
        if i["obj"] in SOLID_OBJS and i["obj"] not in ignore:
            x0, y0, x1, y1 = inst_box(i)
            # A player origin at (px,py) collides if its feet box overlaps
            bx0, by0 = int(np.floor(x0 - PX1)), int(np.floor(y0 - PY1))
            bx1, by1 = int(np.ceil(x1 - PX0)), int(np.ceil(y1 - PY0))
            blocked[max(by0, 0):max(min(by1 + 1, H), 0), max(bx0, 0):max(min(bx1 + 1, W), 0)] = True
    seen = np.zeros((H, W), bool)
    sx, sy = int(start[0]), int(start[1])
    assert not blocked[sy, sx], f"{room.name}: start {start} is inside a wall"
    stack = [(sx, sy)]
    seen[sy, sx] = True
    while stack:
        x, y = stack.pop()
        for dx, dy in ((2, 0), (-2, 0), (0, 2), (0, -2)):
            nx, ny = x + dx, y + dy
            if 0 <= nx < W and 0 <= ny < H and not seen[ny, nx] and not blocked[ny, nx]:
                seen[ny, nx] = True
                stack.append((nx, ny))
    ys, xs = np.nonzero(seen)
    pts = np.stack([xs, ys], 1)
    results = {}
    for label, (x0, y0, x1, y1), reach in targets:
        # touching: feet box overlaps target expanded by `reach`
        ok = ((pts[:, 0] + PX1 >= x0 - reach) & (pts[:, 0] + PX0 <= x1 + reach) &
              (pts[:, 1] + PY1 >= y0 - reach) & (pts[:, 1] + PY0 <= y1 + reach)).any()
        results[label] = ok
    return results


def main():
    rooms = {r.name: r for r in world.all_rooms()}
    bad = 0
    starts = {"r_village": "i_game_start", "r_old_forest": "i_forest_entrance", "r_desert": "i_desert_entrance",
              "r_home": "i_home_in", "r_granny": "i_granny_in", "r_post_office": "i_post_office_in"}
    for name, start_name in starts.items():
        room = rooms[name]
        named = {i["name"]: i for i in room.instances}
        start = named[start_name]
        targets = []
        for i in room.instances:
            o = i["obj"]
            if o in ("o_door", "o_sword_pickup", "o_heart_pickup", "o_gem_pickup"):
                targets.append((f"{o}@{int(i['x'])},{int(i['y'])}", inst_box(i), 0))
            elif o in ("o_mum", "o_dad", "o_granny", "o_granda", "o_sign", "o_sweetie_tin", "o_save_point", "o_letter", "o_bush", "o_keeper", "o_ruin_entrance"):
                targets.append((f"{o}@{int(i['x'])},{int(i['y'])}", inst_box(i), 20))
        for o in ("i_home_out", "i_granny_out", "i_post_office_out", "i_village_north", "i_village_south"):
            if o in named:
                targets.append((o, (named[o]["x"], named[o]["y"] - 2, named[o]["x"], named[o]["y"] - 2), 0))
        # Before the sword: bushes block the Old Forest. After: they're cut.
        for phase, ignore in (("no sword", ()), ("with sword", ("o_bush",))):
            res = check(room, (start["x"], start["y"]), targets, ignore)
            missing = [k for k, v in res.items() if not v]
            if phase == "no sword" and name == "r_village":
                # Behind the bushes: the Old Forest exit, and the hidden treasure in screen 3
                forest = [k for k in missing if ("@" in k and int(k.split("@")[1].split(",")[1]) < 180) or k == "i_village_north"]
                missing = [k for k in missing if k not in forest]
                print(f"{name} [{phase}]: {len(res) - len(missing) - len(forest)}/{len(res)} reachable; "
                      f"{len(forest)} forest targets correctly blocked by bushes" + (f"; MISSING {missing}" if missing else ""))
            else:
                print(f"{name} [{phase}]: {sum(res.values())}/{len(res)} reachable" + (f"; MISSING {missing}" if missing else ""))
            bad += len(missing)
    return bad


if __name__ == "__main__":
    sys.exit(1 if main() else 0)
