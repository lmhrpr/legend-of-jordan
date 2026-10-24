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
        if name in ("o_solid", "o_ledge"):
            return True
        name = obj(name)[1]
    return False


def sprite_box(spr):
    if spr not in _sprites:
        y = load(f"{ROOT}/sprites/{spr}/{spr}.yy")
        ox, oy = y["sequence"]["xorigin"], y["sequence"]["yorigin"]
        _sprites[spr] = (y["bbox_left"] - ox, y["bbox_top"] - oy, y["bbox_right"] - ox, y["bbox_bottom"] - oy)
    return _sprites[spr]


def wall_solids(room_yy):
    """The invisible blocks walls_make_solid() lays along the Tiles_Walls layer (same masks as scr_walls)."""
    layer = next((l for l in room_yy["layers"] if l["name"] == "Tiles_Walls"), None)
    if not layer:
        return []
    gml = open(f"{ROOT}/scripts/scr_walls/scr_walls.gml", encoding="utf-8").read()
    masks = [int(v) for v in re.search(r"#macro WALL_TILE_MASKS \[([\d,]+)\]", gml).group(1).split(",")]
    data, i, cells = layer["tiles"]["TileCompressedData"], 0, []
    while i < len(data):
        n = data[i]
        if n < 0:
            cells += [data[i + 1]] * (-n); i += 2
        else:
            cells += data[i + 1:i + 1 + n]; i += 1 + n
    w = layer["tiles"]["SerialiseWidth"]
    stairs_ids = [int(v) for v in re.search(r"#macro WALL_STAIR_TILES \[([\d,]+)\]", gml).group(1).split(",")]
    stair_px = set()
    for l in room_yy["layers"]:
        if l["name"] in ("Tiles_Decor", "Tiles_Ground") and l.get("tiles"):
            d, j, sc = l["tiles"]["TileCompressedData"], 0, []
            while j < len(d):
                n = d[j]
                if n < 0:
                    sc += [d[j + 1]] * (-n); j += 2
                else:
                    sc += d[j + 1:j + 1 + n]; j += 1 + n
            sw = l["tiles"]["SerialiseWidth"]
            stair_px |= {((k % sw) * 16, (k // sw) * 16) for k, v in enumerate(sc) if v > 0 and v & 0x7FFFF in stairs_ids}
    out = []
    for k, v in enumerate(cells):
        v = v & 0x7FFFF if v > 0 else 0
        m = masks[v] if 0 < v < len(masks) else 0
        for bit in range(16):
            cx, cy = (k % w) * 32 + (bit % 4) * 8, (k // w) * 32 + (bit // 4) * 8
            if m >> bit & 1 and (cx // 16 * 16, cy // 16 * 16) not in stair_px:
                out.append(dict(name="wall", obj="o_solid", x=(k % w) * 32 + (bit % 4) * 8, y=(k // w) * 32 + (bit // 4) * 8, sx=0.5, sy=0.5))
    return out


def instances(room):
    y = load(f"{ROOT}/rooms/{room}/{room}.yy")
    out = []
    for layer in y["layers"]:
        for i in layer.get("instances", []):
            out.append(dict(name=i["name"], obj=i["objectId"]["name"], x=i["x"], y=i["y"], sx=i["scaleX"], sy=i["scaleY"]))
    out += wall_solids(y)
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


def blocked_mask(w, h, insts, ignore=()):
    """Origins where Jordan's feet would overlap something solid, plus which instances cover each spot."""
    blocked = np.zeros((h, w), bool)
    boxes = []
    for i in insts:
        if i["obj"] in ignore or not is_solid(i["obj"]):
            continue
        x0, y0, x1, y1 = box(i)
        bx0, by0, bx1, by1 = int(np.floor(x0 - PX1)), int(np.floor(y0 - PY1)), int(np.ceil(x1 - PX0)), int(np.ceil(y1 - PY0))
        blocked[max(by0, 0):max(min(by1 + 1, h), 0), max(bx0, 0):max(min(bx1 + 1, w), 0)] = True
        boxes.append(((bx0, by0, bx1, by1), visible_box(i)))
    return blocked, boxes


def visible_box(i):
    """The part of the room an instance can be seen in: its sprite for visible objects; the collision
    box itself for invisible solids (they sit under tiles that show the obstacle)."""
    spr, _ = obj(i["obj"])
    if spr and object_visible(i["obj"]):
        y = load(f"{ROOT}/sprites/{spr}/{spr}.yy")
        ox, oy = y["sequence"]["xorigin"], y["sequence"]["yorigin"]
        return (i["x"] - ox * i["sx"], i["y"] - oy * i["sy"], i["x"] + (y["width"] - ox) * i["sx"] - 1, i["y"] + (y["height"] - oy) * i["sy"] - 1)
    return box(i)


def object_visible(name):
    return load(f"{ROOT}/objects/{name}/{name}.yy")["visible"]


def invisible_walls(w, h, insts, seen, ignore=()):
    """Spots where Jordan walks up to a screen border and is stopped by something he can't see,
    because it's entirely on the other screen. Returns (description, from-screen, position range)."""
    VW, VH = 320, 180
    blocked, boxes = blocked_mask(w, h, insts, ignore)
    cols = w // VW
    screen = lambda x, y: (y // VH) * cols + (x // VW) + 1
    found = []

    def blockers(x, y):
        return [vis for (bx0, by0, bx1, by1), vis in boxes if bx0 <= x <= bx1 and by0 <= y <= by1]

    def scan(line, along, horizontal):
        for direction in (1, -1):                  # approaching the line from before it (+1) or after it (-1)
            hits = []
            for a in range(along):
                for d in range(1, 9):              # Jordan within 8px of the line on his side
                    o = line - d if direction == 1 else line + d - 1
                    n = o + direction
                    x, y, nx, ny = (a, o, a, n) if horizontal else (o, a, n, a)
                    if not (0 <= n < (h if horizontal else w)) or not seen[y, x] or not blocked[ny, nx]:
                        continue
                    vis = blockers(nx, ny)
                    if direction == 1:
                        can_see = any((v[1] if horizontal else v[0]) < line for v in vis)    # some of it is on Jordan's side
                    else:
                        can_see = any((v[3] if horizontal else v[2]) >= line for v in vis)
                    if vis and not can_see:
                        hits.append((a, screen(x, y)))
                    break
            # group into runs
            run = []
            for a, s in hits + [(None, None)]:
                if run and (a is None or a != run[-1][0] + 1 or s != run[-1][1]):
                    if run[-1][0] - run[0][0] >= 2:
                        kind = "y" if horizontal else "x"
                        span = f"x {run[0][0]}-{run[-1][0]}" if horizontal else f"y {run[0][0]}-{run[-1][0]}"
                        found.append(f"screen {run[0][1]}: invisible wall at {kind}={line}, {span}")
                    run = []
                if a is not None:
                    run.append((a, s))

    for X in range(VW, w, VW):
        scan(X, h, False)
    for Y in range(VH, h, VH):
        scan(Y, w, True)
    return found


def flood_with_doors(room, w, h, insts, start, ignore=()):
    """Flood fill that also follows dungeon doorways (o_dungeon_door moves Jordan to dest_x_, dest_y_)."""
    doors = []
    for i in insts:
        if i["obj"] == "o_dungeon_door":
            code = open(f"{ROOT}/rooms/{room}/InstanceCreationCode_{i['name']}.gml", encoding="utf-8").read()
            dx = float(re.search(r"dest_x_ = ([\d.]+)", code).group(1))
            dy = float(re.search(r"dest_y_ = ([\d.]+)", code).group(1))
            doors.append(((i["x"] - 8, i["y"] - 8, i["x"] + 8, i["y"] + 8), (dx, dy)))
    seen = flood(w, h, insts, start, ignore)
    done = set()
    while True:
        new = [d for k, d in enumerate(doors) if k not in done and reachable(seen, d[0], 0)]
        if not new:
            return seen
        for k, d in enumerate(doors):
            if d in new:
                done.add(k)
                seen |= flood(w, h, insts, d[1], ignore)


def reachable(seen, target, reach):
    x0, y0, x1, y1 = target
    ys, xs = np.nonzero(seen)
    return bool(((xs + PX1 >= x0 - reach) & (xs + PX0 <= x1 + reach) & (ys + PY1 >= y0 - reach) & (ys + PY0 <= y1 + reach)).any())


TALK = {"o_dungeon_entrance", "o_cracked_wall", "o_post_bag", "o_chest", "o_locked_door", "o_mum", "o_dad", "o_granny", "o_granda", "o_keeper", "o_sign", "o_sweetie_tin", "o_save_point", "o_letter", "o_ruin_entrance", "o_bush"}
TOUCH = {"o_floor_switch", "o_key_spawner", "o_door", "o_sword_pickup", "o_heart_pickup", "o_gem_pickup"}
STARTS = {"r_canyon": "i_canyon_in", "r_canyon_caves": "i_cave1_in", "r_dungeon1": "i_dungeon1_in", "r_dungeon2": "i_dungeon2_in", "r_village": "i_game_start", "r_old_forest": "i_forest_entrance", "r_desert": "i_desert_entrance",
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
        phases = (("no sword", ()), ("with sword", ("o_bush",)))
        if room.startswith("r_canyon"):
            phases = (("bombs and boots", ("o_bush", "o_rock_cracked", "o_hidden_cave")),)    # (jumps between plateaus aren't checked)
        if room.startswith("r_dungeon"):
            phases = (("doors open", ("o_barred_door", "o_locked_door", "o_cracked_wall")),)
        for phase, ignore in phases:
            seen = flood_with_doors(room, w, h, insts, (start["x"], start["y"]), ignore)
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
            if phase in ("with sword", "doors open", "bombs and boots") and (w > 320 or h > 180):
                for msg in invisible_walls(w, h, insts, seen, ignore):
                    print("  " + msg)
                    problems += 1
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
