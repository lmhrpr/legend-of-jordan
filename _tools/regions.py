"""Overworld regions: the Village (Liam's 9-screen plan), the Old Forest and the Southern Desert.

Village screen numbers follow Liam's plan:
    1 Woods & Lake   2 Dark forest (-> Old Forest)   3 Dark forest (dead end)
    4 Home           5 Flowery Meadow (start)        6 Woods (dead end)
    7 Woods          8 Granny & Granda's             9 Post Office (-> Southern Desert)
"""
import random
from roomgen import Room, TILE
from world import (autotile, place_building, PATH, SAND, WATER, ROCK, FLOWERS, PLATFORM,
                   HOUSE_RED, COTTAGE_TEAL, POST_OFFICE)

SMALL_FLOWERS = 162

# Screen (column, row) for each of Liam's numbers
SCREEN = {1: (0, 0), 2: (1, 0), 3: (2, 0), 4: (0, 1), 5: (1, 1), 6: (2, 1), 7: (0, 2), 8: (1, 2), 9: (2, 2)}
DARK = {SCREEN[2], SCREEN[3]}


def c0(n):
    """First cell column of screen n."""
    return SCREEN[n][0] * 20


def rows(n):
    """Interior cell rows of screen n (between the tree borders)."""
    return {0: range(2, 11), 1: range(12, 22), 2: range(23, 33)}[SCREEN[n][1]]


def screen_of_tree(c, r):
    """Which screen a border tree mostly appears in (trees are tall, so use their visual middle)."""
    return (min(c // 20, 2), min(max((r * TILE + 16 - 20) // 180, 0), 2))


def borders(room, w_cells, v_open, h_open, top_open=(), bottom_open=(), dark=(), last_row=33, screen_cols=(19, 20, 39, 40), screen_rows=(11, 22)):
    """Tree lines round every screen, with gaps where screens connect."""
    cells = set()
    for c in range(w_cells):
        if c not in top_open:
            cells.add((c, 1))
        if c not in bottom_open:
            cells.add((c, last_row))
        for row in screen_rows:
            if c not in h_open.get(row, ()):
                cells.add((c, row))
    for r in range(1, last_row + 1):
        cells.add((0, r)); cells.add((w_cells - 1, r))
        for col in screen_cols:
            if r not in v_open.get(col, ()):
                cells.add((col, r))
    for (c, r) in sorted(cells, key=lambda p: (p[1], p[0])):
        kind = "o_tree_dark" if screen_of_tree(c, r) in dark else "o_tree"
        room.add(kind, c * TILE + 8, r * TILE + 16)


def tree(room, c, r, dark=False):
    room.add("o_tree_dark" if dark else "o_tree", c * TILE + 8, r * TILE + 16)


def grass(room, c, r, hidden=None, count=1):
    code = None
    if hidden:
        code = f"hidden_item_ = {hidden};\nhidden_count_ = {count};"
    room.add("o_grass", c * TILE, r * TILE, code=code)


def bush(room, x, y, hidden=None, count=1):
    code = None
    if hidden:
        code = f"hidden_item_ = {hidden};\nhidden_count_ = {count};"
    room.add("o_bush", x, y, code=code)


def sign(room, c, r, lines, point=0):
    """point: 0 = plain board, 1 = right arrow, 2 = left arrow."""
    code = "".join(f'text[{i}] = "{t}";\n' for i, t in enumerate(lines))
    if point:
        code = f"image_index = {point};\n" + code
    room.add("o_sign", c * TILE + 8, r * TILE, code=code)


def edge_door(room, c, r, width, target_room, target_start, h=1.0):
    room.add("o_door", c * TILE, r * TILE, sx=width, sy=h,
             code=f"room_ = {target_room};\nstart_ = {target_start};\ntype_ = trans_type.slide;")


def flowers(room, rnd, cells, density=0.7, small=0.25):
    for (c, r) in cells:
        x = rnd.random()
        if x < density * (1 - small):
            room.set_tile("Tiles_Decor", c, r, FLOWERS[(c * 7 + r * 3) % 2])
        elif x < density:
            room.set_tile("Tiles_Decor", c, r, SMALL_FLOWERS)


def rect(c0_, r0, c1, r1):
    return {(c, r) for c in range(c0_, c1 + 1) for r in range(r0, r1 + 1)}


# =====================================================================================
#  THE VILLAGE (3 x 3 screens)
# =====================================================================================
def village():
    rnd = random.Random(40)
    room = Room("r_village", 960, 540, bg_sprite="s_grass_background")
    solids, path = set(), set()

    # ---- Connections between screens (gaps in the tree borders) ----
    # Vertical borders: column -> rows left open. Gaps run two rows below the road (trees are tall).
    v_open = {19: set(), 20: set(), 39: set(), 40: set()}
    def v(cols, rr):
        for col in cols:
            v_open[col] |= set(rr)
    v((19, 20), range(5, 10))     # 1 <-> 2
    v((39, 40), range(5, 10))     # 2 <-> 3
    v((19, 20), range(16, 21))    # 4 <-> 5
    v((19, 20), range(26, 31))    # 7 <-> 8
    v((39, 40), range(26, 31))    # 8 <-> 9
    h_open = {11: set(range(8, 11)),                         # 1 <-> 4
              22: set(range(8, 11)) | set(range(48, 51))}    # 4 <-> 7,  6 <-> 9
    top_open = set(range(28, 31))          # 2 -> Old Forest
    bottom_open = set(range(48, 51))       # 9 -> Southern Desert
    borders(room, 60, v_open, h_open, top_open, bottom_open, dark=DARK)
    room.solid_rect(0, 33, 47, 33)          # bottom edge (except the desert road)
    room.solid_rect(51, 33, 59, 33)

    # ---- Roads (none in the dark woods) ----
    def road(a, b, c, d):
        path.update(rect(a, b, c, d))
    road(20, 17, 26, 18)       # 5: meadow path, west to Home
    road(9, 17, 19, 18)        # 4: east-west through Home's screen
    road(9, 11, 10, 22)        # 4: north to the Lake, south to the Woods
    road(13, 16, 14, 16)       # 4: Home's front door
    road(9, 6, 10, 10)         # 1: up from Home
    road(9, 6, 19, 7)          # 1: east towards the dark forest
    road(9, 23, 10, 28)        # 7: down from Home
    road(9, 27, 39, 28)        # 7-8-9: road to Granny & Granda's and the Post Office
    road(40, 27, 53, 28)       # 9
    road(26, 26, 27, 26)       # 8: cottage door
    road(48, 22, 49, 33)       # 9: north to the Woods, south to the desert
    autotile(room, "Tiles_Ground", path, PATH)
    keep = set(path)

    # ================= 5: Flowery Meadow (Jordan wakes here) =================
    room.add("o_start_position", 30 * TILE, 17 * TILE + 12, name="i_game_start")
    meadow = rect(21, 12, 38, 21) - rect(27, 15, 33, 20) - path
    flowers(room, rnd, meadow, density=0.55)
    flowers(room, rnd, rect(27, 15, 33, 20) - rect(29, 16, 31, 19), density=0.3)
    for (c, r) in [(23, 13), (36, 13), (38, 16), (36, 21), (24, 21), (33, 13)]:
        tree(room, c, r)
    sign(room, 22, 16, ["West: Home"], point=2)
    for (c, r) in [(35, 18), (36, 18), (37, 19), (25, 13), (26, 13)]:
        grass(room, c, r)
    grass(room, 37, 18, hidden="o_gem_pickup")

    # ================= 4: Home =================
    place_building(room, HOUSE_RED, 12, 13, door=(13, 15), solids=solids)
    room.add("o_door", 13 * TILE, 15 * TILE, code="room_ = r_home;\nstart_ = i_home_in;")
    room.add("o_start_position", 13 * TILE + 8, 17 * TILE + 2, name="i_home_out")
    sign(room, 16, 16, ["Home sweet home."])
    flowers(room, rnd, rect(15, 14, 17, 15), density=0.9)
    flowers(room, rnd, rect(2, 15, 6, 16), density=0.6)
    for (c, r) in [(3, 13), (6, 13), (2, 20), (16, 20), (5, 21), (18, 13)]:
        tree(room, c, r)
    for (c, r) in [(3, 18), (4, 18), (14, 20), (15, 21)]:
        grass(room, c, r)
    grass(room, 4, 19, hidden="o_heart_pickup")

    # ================= 1: Woods & Lake =================
    lake_sand = rect(2, 3, 7, 8)
    autotile(room, "Tiles_Ground", lake_sand, SAND)
    for (c, r) in rect(3, 4, 6, 7):
        room.set_tile("Tiles_Ground", c, r, WATER)
        solids.add((c, r))
    keep |= lake_sand
    for (c, r) in [(13, 3), (16, 4), (18, 3), (12, 10), (15, 9), (18, 10), (2, 10), (6, 10)]:
        tree(room, c, r)
    flowers(room, rnd, rect(12, 4, 17, 5) - keep, density=0.4)
    for (c, r) in [(13, 9), (14, 9), (16, 9), (17, 9)]:
        grass(room, c, r)
    grass(room, 8, 3, hidden="o_gem_pickup", count=2)
    sign(room, 11, 5, ["The Lake.", "No swimming!"])

    # ================= 2: Dark forest (gate to the Old Forest) =================
    trail2 = rect(20, 6, 26, 8) | rect(26, 2, 32, 8) | rect(31, 6, 39, 8)
    for r in range(3, 11):
        for c in range(21, 39):
            if (c, r) in trail2 or (c + r) % 2:
                continue
            if rnd.random() < 0.85:
                if rnd.random() < 0.25:
                    room.add("o_old_tree1", c * TILE + 8, r * TILE + 16)
                else:
                    tree(room, c, r, dark=True)
    for bx in (462, 482):                   # overgrown: cut with the sword
        bush(room, bx, 2 * TILE + 12)
    sign(room, 32, 4, ["THE OLD FOREST", "DANGER! Keep out!",
                       "(The path is overgrown. You'd need something sharp to get through.)"])
    edge_door(room, 28, 0, 3, "r_old_forest", "i_forest_entrance")
    room.add("o_start_position", 29 * TILE + 8, 4 * TILE + 8, name="i_village_north")
    room.add("o_darkness", 320, 0, code="alpha_top_ = 0.4;\nalpha_bottom_ = 0.12;")

    # ================= 3: Dark forest (dead end, hidden treasure) =================
    trail3 = rect(40, 6, 45, 8) | rect(44, 3, 47, 8) | rect(46, 3, 51, 5) | rect(50, 3, 57, 9)
    for r in range(3, 11):
        for c in range(41, 59):
            if (c, r) in trail3 or (c + r) % 2:
                continue
            if rnd.random() < 0.85:
                if rnd.random() < 0.3:
                    room.add("o_old_tree1", c * TILE + 8, r * TILE + 16)
                else:
                    tree(room, c, r, dark=True)
    # A ring of bushes in the clearing, with treasure inside
    bush(room, 53 * TILE, 6 * TILE + 12, hidden="o_heart_pickup")
    bush(room, 55 * TILE, 6 * TILE + 12, hidden="o_gem_pickup", count=3)
    bush(room, 54 * TILE, 8 * TILE + 12, hidden="o_gem_pickup", count=2)
    for (c, r) in [(51, 4), (52, 9), (56, 4)]:
        grass(room, c, r)
    room.add("o_darkness", 640, 0, code="alpha_top_ = 0.35;\nalpha_bottom_ = 0.3;")

    # ================= 6: Woods (dead end, a pond and a stash) =================
    for (c, r) in rect(52, 13, 55, 15):
        room.set_tile("Tiles_Ground", c, r, WATER)
        solids.add((c, r))
    for (c, r) in [(42, 13), (44, 15), (46, 13), (42, 19), (57, 18), (55, 20), (45, 20), (58, 14), (50, 13)]:
        tree(room, c, r)
    flowers(room, rnd, rect(41, 16, 46, 18), density=0.5)
    for (c, r) in rect(51, 17, 57, 19):
        if rnd.random() < 0.6:
            grass(room, c, r)
    grass(room, 56, 16, hidden="o_gem_pickup", count=3)
    bush(room, 57 * TILE, 13 * TILE + 12, hidden="o_heart_pickup")

    # ================= 7: Woods =================
    for (c, r) in [(3, 24), (6, 25), (14, 24), (17, 25), (2, 30), (5, 31), (14, 31), (17, 31), (12, 30)]:
        tree(room, c, r)
    flowers(room, rnd, rect(2, 26, 7, 28), density=0.4)
    for (c, r) in [(12, 24), (13, 24), (15, 30), (16, 30), (4, 30)]:
        grass(room, c, r)
    grass(room, 13, 25, hidden="o_gem_pickup")
    sign(room, 17, 26, ["East: Granny & Granda's house"], point=1)

    # ================= 8: Granny & Granda's =================
    place_building(room, COTTAGE_TEAL, 25, 24, door=(26, 25), solids=solids)
    room.add("o_door", 26 * TILE, 25 * TILE, code="room_ = r_granny;\nstart_ = i_granny_in;")
    room.add("o_start_position", 26 * TILE + 8, 27 * TILE + 6, name="i_granny_out")
    for c in range(29, 35):                     # Granda's flower garden
        for r in range(24, 26):
            room.set_tile("Tiles_Decor", c, r, FLOWERS[(c + r) % 2])
    room.add("o_granda", 31 * TILE + 8, 26 * TILE + 6)
    sign(room, 22, 26, ["Granny & Granda's house.", "Wipe your feet!"])
    sign(room, 37, 26, ["East: The Post Office"], point=1)
    for (c, r) in [(21, 24), (36, 24), (22, 31), (37, 31), (26, 31), (33, 31)]:
        tree(room, c, r)
    for (c, r) in [(29, 30), (30, 30), (31, 31)]:
        grass(room, c, r)

    # ================= 9: Post Office =================
    place_building(room, POST_OFFICE, 50, 23, door=(52, 26), solids=solids)
    room.add("o_door", 52 * TILE, 26 * TILE, code="room_ = r_post_office;\nstart_ = i_post_office_in;")
    room.add("o_start_position", 52 * TILE + 8, 28 * TILE + 6, name="i_post_office_out")
    sign(room, 55, 26, ["POST OFFICE", "Letters, parcels and saving your progress."])
    sign(room, 46, 30, ["South: The Southern Desert"])
    edge_door(room, 48, 33, 3, "r_desert", "i_desert_entrance")
    room.add("o_start_position", 49 * TILE, 31 * TILE + 8, name="i_village_south")
    for (c, r) in [(43, 24), (57, 29), (42, 31), (55, 31), (45, 24)]:
        tree(room, c, r)
    for (c, r) in [(43, 30), (44, 30), (56, 27)]:
        grass(room, c, r)

    # ---- Music, camera, walls ----
    music = {1: "o_village_music", 2: "o_forest_music", 3: "o_forest_music", 4: "o_village_music",
             5: "o_village_music", 6: "o_village_music", 7: "o_village_music", 8: "o_village_music",
             9: "o_village_music"}
    for n, obj in music.items():
        sx, sy = SCREEN[n]
        room.add(obj, sx * 320 + 24, sy * 180 + 40)
    room.add("o_camera", 0, 0)
    room.solid_cells(solids)
    return room


# =====================================================================================
#  THE OLD FOREST (placeholder strip of 3 screens until the full region is built)
# =====================================================================================
def old_forest():
    rnd = random.Random(1983)
    room = Room("r_old_forest", 960, 180, bg_sprite="s_grass_background")
    v_open = {19: set(range(5, 10)), 20: set(range(5, 10)), 39: set(range(4, 9)), 40: set(range(4, 9))}
    borders(room, 60, v_open, {}, bottom_open=set(range(8, 11)), dark={(0, 0), (1, 0), (2, 0)},
            last_row=11, screen_rows=())
    room.solid_rect(0, 0, 59, 0)

    def forest(cs, keep, olds):
        for r in range(3, 11):
            for c in cs:
                if (c, r) in keep or (c + r) % 2:
                    continue
                if rnd.random() < 0.9:
                    if rnd.random() < olds:
                        room.add("o_old_tree1", c * TILE + 8, r * TILE + 16)
                    else:
                        tree(room, c, r, dark=True)
                elif rnd.random() < 0.5:
                    grass(room, c, r)

    forest(range(1, 19), rect(8, 6, 10, 11) | rect(8, 6, 19, 8), 0.2)
    room.add("o_bat", 12 * TILE, 7 * TILE)
    room.add("o_bat", 16 * TILE, 7 * TILE)
    room.add("o_heart_pickup", 18 * TILE, 7 * TILE + 8)
    forest(range(21, 39), rect(20, 6, 25, 8) | rect(23, 3, 25, 8) | rect(23, 3, 33, 5) | rect(31, 3, 33, 8) | rect(31, 6, 39, 8), 0.25)
    room.add("o_porcupine", 28 * TILE, 4 * TILE + 8)
    room.add("o_porcupine", 36 * TILE, 7 * TILE + 8)
    room.add("o_bat", 24 * TILE, 7 * TILE)
    room.add("o_gem_pickup", 32 * TILE, 4 * TILE)
    forest(range(41, 59), rect(40, 6, 45, 8) | rect(45, 3, 57, 10), 0.35)
    # The clearing: Liam's dropped letter, the Keeper, and the sealed way into the ruins
    room.add("o_letter", 46 * TILE + 8, 7 * TILE + 8)
    room.add("o_keeper", 50 * TILE + 8, 7 * TILE)
    ruin = [[240, 241, 242], [256, 257, 258], [272, 273, 274]]
    ruin_solids = set()
    for dr in range(3):
        for dc in range(3):
            room.set_tile("Tiles_Decor", 54 + dc, 3 + dr, ruin[dr][dc])
            if (dc, dr) != (1, 1):
                ruin_solids.add((54 + dc, 3 + dr))
    room.add("o_ruin_entrance", 55 * TILE, 4 * TILE)
    room.solid_cells(ruin_solids)
    room.add("o_porcupine", 47 * TILE, 4 * TILE + 8)
    room.add("o_porcupine", 53 * TILE, 9 * TILE)
    for (c, r) in [(48, 8), (52, 4), (51, 9), (46, 9)]:
        grass(room, c, r)

    edge_door(room, 8, 10, 3, "r_village", "i_village_north", h=0.75)
    room.add("o_start_position", 9 * TILE + 8, 9 * TILE + 4, name="i_forest_entrance")
    for sx in range(3):
        room.add("o_forest_music", sx * 320 + 24, 40)
        room.add("o_darkness", sx * 320, 0, code="alpha_top_ = 0.35;\nalpha_bottom_ = 0.3;")
    room.add("o_camera", 0, 0)
    return room


# =====================================================================================
#  THE SOUTHERN DESERT (the sword shrine screen; the rest of the region comes later)
# =====================================================================================
def desert():
    room = Room("r_desert", 320, 180, bg_sprite="s_grass_background")
    solids = set()
    autotile(room, "Tiles_Ground", rect(0, 0, 19, 11), SAND)
    # Rocky edges, with the road north to the Post Office
    for c in range(20):
        for r in (0, 10, 11):
            if r == 0 and c in (8, 9, 10):
                continue
            room.set_tile("Tiles_Decor", c, r, ROCK); solids.add((c, r))
    for r in range(1, 10):
        for c in (0, 19):
            room.set_tile("Tiles_Decor", c, r, ROCK); solids.add((c, r))
    # The Magic Sword on its stone platform
    for dr in range(2):
        for dc in range(2):
            room.set_tile("Tiles_Decor", 9 + dc, 5 + dr, PLATFORM[dr][dc])
    room.add("o_sword_pickup", 10 * TILE, 5 * TILE - 6)
    for (c, r) in [(4, 3), (15, 7), (13, 2), (5, 8)]:
        room.set_tile("Tiles_Decor", c, r, ROCK); solids.add((c, r))
    for (c, r) in [(3, 6), (16, 3)]:
        room.add("o_old_tree1", c * TILE + 8, r * TILE + 16)
    sign(room, 6, 3, ["THE SOUTHERN DESERT", "Legend says a magic sword rests here."])
    edge_door(room, 8, 0, 3, "r_village", "i_village_south", h=0.6)
    room.add("o_start_position", 9 * TILE + 8, 3 * TILE, name="i_desert_entrance")
    room.add("o_desert_music", 24, 40)
    room.add("o_camera", 0, 0)
    room.solid_cells(solids)
    return room
