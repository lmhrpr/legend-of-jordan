"""The Legend of Jordan: overworld and interior layouts."""
import random
from roomgen import Room, EMPTY, TILE

# ---- Tile indices in s_top_down ----
PATH = dict(tl=19, t=20, tr=21, l=35, c=450, r=37, bl=51, b=52, br=53)
SAND = dict(tl=13, t=14, tr=15, l=29, c=42, r=31, bl=45, b=46, br=47)
WATER = 64
ROCK = 68
FLOWERS = [160, 161]
SIGNPOST = 476
PLATFORM = [[170, 171], [186, 187]]
BLACK = 1
FLOOR = 450
BRICK_TOP = [361, 362]
BRICK_BOT = [377, 378]
WALL_SIDE = 464

# House pieces (rows of tile indices); None = no tile
HOUSE_RED = [[119, 120, 121], [135, 136, 137], [180, 181, 182]]        # home
COTTAGE_TEAL = [[164, 165, 166], [180, 181, 182]]                       # Granny & Granda's
POST_OFFICE = [[116, 117, 117, 117, 118],
               [132, 133, 133, 133, 134],
               [356, 357, 420, 361, 362],
               [372, 373, 436, 377, 378]]

W, H = 60, 34            # overworld in cells (960 x 540 px, 3 x 3 screens)


def autotile(room, layer, cells, ts):
    cells = set(cells)
    for (c, r) in cells:
        n, s, e, w = (c, r - 1) in cells, (c, r + 1) in cells, (c + 1, r) in cells, (c - 1, r) in cells
        if not n and not s:
            n = s = True
        if not e and not w:
            e = w = True
        if not n and not w: t = ts["tl"]
        elif not n and not e: t = ts["tr"]
        elif not n: t = ts["t"]
        elif not s and not w: t = ts["bl"]
        elif not s and not e: t = ts["br"]
        elif not s: t = ts["b"]
        elif not w: t = ts["l"]
        elif not e: t = ts["r"]
        else: t = ts["c"]
        room.set_tile(layer, c, r, t)


def place_building(room, tiles, c0, r0, door=None, solids=None):
    for dr, row in enumerate(tiles):
        for dc, t in enumerate(row):
            if t is not None:
                room.set_tile("Tiles_Decor", c0 + dc, r0 + dr, t)
            if door != (c0 + dc, r0 + dr):
                solids.add((c0 + dc, r0 + dr))


def tree(room, c, r, kind="o_tree"):
    room.add(kind, c * TILE + 8, r * TILE + 16)


def overworld():
    rnd = random.Random(1983)
    room = Room("r_overworld", W * TILE, 540, bg_sprite="s_grass_background")
    solids = set()
    path, sand = set(), set()
    blocked = set()      # cells kept clear of random trees

    # ---------------- Screen borders (tree lines) with openings ----------------
    v_open = {19: set(), 20: set(), 39: set(), 40: set()}
    h_open = {11: set(), 22: set()}
    # vertical openings (rows), per screen-row
    # (trees are tall, so each gap extends two rows below the road it carries)
    for rows, cols in [(range(5, 10), (19, 20)),     # Forest A <-> Forest B
                       (range(4, 9), (39, 40)),      # Forest B <-> Forest C
                       (range(16, 21), (19, 20)),    # Granny's <-> Village
                       (range(16, 21), (39, 40)),    # Village <-> Post Office
                       (range(26, 31), (19, 20)),    # Fields <-> Meadow
                       (range(26, 31), (39, 40))]:   # Meadow <-> Desert
        for col in cols:
            v_open[col] |= set(rows)
    for cols, row in [(range(8, 11), 11),            # Granny's -> Old Forest
                      (range(28, 31), 22),           # Village -> Meadow
                      (range(48, 51), 22)]:          # Post Office -> Desert
        h_open[row] |= set(cols)

    border = set()
    for c in range(W):
        border.add((c, 1)); border.add((c, 33))
        for row in (11, 22):
            if c not in h_open[row]:
                border.add((c, row))
    for r in range(1, 34):
        border.add((0, r)); border.add((59, r))
        for col in (19, 20, 39, 40):
            if r not in v_open[col]:
                border.add((col, r))
    for (c, r) in sorted(border, key=lambda p: (p[1], p[0])):
        tree(room, c, r)
    # Keep the very edge solid as well (in case of gaps between tree masks)
    room.solid_rect(0, 0, W - 1, 0)
    room.solid_rect(0, 33, W - 1, 33)

    # ---------------- Paths ----------------
    def path_rect(c0, r0, c1, r1):
        for c in range(c0, c1 + 1):
            for r in range(r0, r1 + 1):
                path.add((c, r))
    path_rect(4, 17, 49, 18)          # main east-west road (Granny's - Village - Post Office)
    path_rect(29, 16, 30, 28)         # village -> meadow (south)
    path_rect(18, 27, 38, 28)         # fields - meadow - desert road
    path_rect(9, 12, 10, 16)          # Granny's -> Old Forest
    path_rect(6, 16, 7, 16)           # cottage door
    path_rect(48, 17, 49, 22)         # post office -> desert
    for p in path:
        blocked.add(p)
    autotile(room, "Tiles_Ground", path, PATH)

    # ================= Screen (0,1): Granny & Granda's cottage =================
    place_building(room, COTTAGE_TEAL, 5, 14, door=(6, 15), solids=solids)
    room.add("o_door", 6 * TILE, 15 * TILE, code="room_ = r_granny;\nstart_ = i_granny_in;")
    room.add("o_start_position", 6 * TILE + 8, 17 * TILE + 6, name="i_granny_out")
    # Granda's flower garden
    for c in range(11, 17):
        for r in range(13, 16):
            if (c + r) % 3 != 0:
                room.set_tile("Tiles_Decor", c, r, FLOWERS[(c * 7 + r) % 2])
    room.add("o_granda", 13 * TILE + 8, 16 * TILE + 4)
    room.add("o_sign", 3 * TILE + 8, 16 * TILE, code='text[0] = "Granny & Granda\'s house.";\ntext[1] = "Wipe your feet!";')
    room.add("o_sign", 12 * TILE + 8, 13 * TILE - 2,
             code='text[0] = "THE OLD FOREST";\ntext[1] = "DANGER! Keep out!";\ntext[2] = "(The path is overgrown. You\'d need something sharp to get through.)";')
    # Bushes blocking the forest path: cut them with the sword
    for bx in (142, 162):
        room.add("o_bush", bx, 12 * TILE + 12)
    for (c, r) in [(2, 13), (3, 13), (2, 20), (17, 13), (16, 20), (3, 20)]:
        tree(room, c, r)
    for (c, r) in [(13, 20), (14, 20), (15, 20), (12, 20), (17, 19), (2, 19)]:
        room.add("o_grass", c * TILE, r * TILE)

    # ================= Screen (1,1): Village, Jordan's home =================
    place_building(room, HOUSE_RED, 28, 13, door=(29, 15), solids=solids)
    room.add("o_door", 29 * TILE, 15 * TILE, code="room_ = r_home;\nstart_ = i_home_in;")
    room.add("o_start_position", 29 * TILE + 8, 17 * TILE + 2, name="i_home_out")
    room.add("o_sign", 32 * TILE + 8, 16 * TILE, code='text[0] = "Home sweet home.";')
    room.add("o_sign", 21 * TILE + 8, 16 * TILE, code='image_index = 2;\ntext[0] = "West: Granny & Granda\'s house";')
    room.add("o_sign", 36 * TILE + 8, 16 * TILE, code='image_index = 1;\ntext[0] = "East: The Post Office";')
    for (c, r) in [(23, 13), (25, 14), (35, 13), (37, 14), (23, 20), (36, 20), (26, 21)]:
        tree(room, c, r)
    for c in range(31, 35):
        room.set_tile("Tiles_Decor", c, 14, FLOWERS[c % 2])
    for (c, r) in [(24, 15), (33, 20), (34, 20), (22, 20), (37, 19)]:
        room.add("o_grass", c * TILE, r * TILE)

    # ================= Screen (2,1): Post Office =================
    place_building(room, POST_OFFICE, 46, 13, door=(48, 16), solids=solids)
    room.add("o_door", 48 * TILE, 16 * TILE, code="room_ = r_post_office;\nstart_ = i_post_office_in;")
    room.add("o_start_position", 48 * TILE + 8, 18 * TILE + 6, name="i_post_office_out")
    room.add("o_sign", 51 * TILE + 8, 17 * TILE, code='text[0] = "POST OFFICE";\ntext[1] = "Letters, parcels and saving your progress.";')
    room.add("o_sign", 47 * TILE + 8, 20 * TILE + 8, code='text[0] = "South: The Southern Desert";')
    for (c, r) in [(43, 13), (55, 13), (57, 15), (53, 20), (56, 19), (43, 20)]:
        tree(room, c, r)
    for (c, r) in [(44, 15), (52, 14), (54, 19), (55, 19), (42, 19)]:
        room.add("o_grass", c * TILE, r * TILE)

    # ================= Screen (1,2): Meadow, where Jordan naps =================
    room.add("o_start_position", 31 * TILE, 30 * TILE + 6, name="i_game_start")
    for (c, r) in [(33, 30), (24, 24), (36, 24), (23, 31), (37, 31), (26, 30)]:
        tree(room, c, r)
    room.add("o_sign", 27 * TILE + 8, 26 * TILE, code='text[0] = "North: Home";')
    room.add("o_sign", 21 * TILE + 8, 26 * TILE, code='image_index = 2;\ntext[0] = "West: The Fields";')
    room.add("o_sign", 37 * TILE, 26 * TILE, code='image_index = 1;\ntext[0] = "East: The Southern Desert";')
    for (c, r) in [(22, 25), (23, 25), (33, 24), (34, 24), (35, 25), (25, 31), (26, 32), (36, 30)]:
        room.add("o_grass", c * TILE, r * TILE)

    # ================= Screen (0,2): The Fields =================
    for c in range(5, 10):
        for r in range(29, 32):
            room.set_tile("Tiles_Ground", c, r, WATER)
            solids.add((c, r))
            blocked.add((c, r))
    for c in range(2, 18):
        for r in range(23, 32):
            if (c, r) in blocked or (c, r) in path:
                continue
            if rnd.random() < 0.42:
                room.add("o_grass", c * TILE, r * TILE)
    for (c, r) in [(12, 30), (14, 24)]:
        room.set_tile("Tiles_Decor", c, r, ROCK)
        solids.add((c, r))
    room.add("o_heart_pickup", 15 * TILE + 8, 31 * TILE)
    room.add("o_gem_pickup", 3 * TILE + 8, 24 * TILE + 8)
    room.add("o_gem_pickup", 11 * TILE + 8, 30 * TILE + 8)

    # ================= Screen (2,2): The Southern Desert =================
    for c in range(41, 59):
        for r in range(23, 33):
            sand.add((c, r))
    for r in range(26, 29):        # sand spills through the west entrance
        sand.add((39, r)); sand.add((40, r))
    autotile(room, "Tiles_Ground", sand, SAND)
    # Stone platform with the Magic Sword
    for dr in range(2):
        for dc in range(2):
            room.set_tile("Tiles_Decor", 52 + dc, 27 + dr, PLATFORM[dr][dc])
    room.add("o_sword_pickup", 53 * TILE, 27 * TILE - 6)
    for (c, r) in [(44, 24), (56, 24), (45, 31), (57, 30), (50, 31), (47, 26)]:
        room.set_tile("Tiles_Decor", c, r, ROCK)
        solids.add((c, r))
    for (c, r) in [(42, 30), (55, 31), (57, 26)]:
        room.add("o_old_tree1", c * TILE + 8, r * TILE + 16)
    room.add("o_sign", 43 * TILE + 8, 27 * TILE, code='text[0] = "THE SOUTHERN DESERT";\ntext[1] = "Legend says a magic sword rests here.";')

    # ================= Forest screens (row 0) =================
    def forest(c0, keep_clear, density, olds):
        # Staggered rows of trees everywhere except the trail
        for r in range(3, 11):
            for c in range(c0 + 1, c0 + 19):
                if (c, r) in keep_clear or (c + r) % 2:
                    continue
                if rnd.random() < density:
                    if rnd.random() < olds:
                        room.add("o_old_tree1", c * TILE + 8, r * TILE + 16)
                    else:
                        tree(room, c, r)
                elif rnd.random() < 0.5:
                    room.add("o_grass", c * TILE, r * TILE)

    def clear_rect(c0, r0, c1, r1):
        return {(c, r) for c in range(c0, c1 + 1) for r in range(r0, r1 + 1)}

    # Forest A: a trail up from Granny's, then east
    keep = clear_rect(8, 6, 10, 11) | clear_rect(8, 6, 19, 8)
    forest(0, keep, 0.9, 0.2)
    room.add("o_bat", 12 * TILE, 7 * TILE)
    room.add("o_bat", 16 * TILE, 7 * TILE)
    room.add("o_heart_pickup", 18 * TILE, 7 * TILE + 8)
    # Forest B: the trail climbs north, then drops back down to the east
    keep = clear_rect(20, 6, 25, 8) | clear_rect(23, 3, 25, 8) | clear_rect(23, 3, 33, 5) | clear_rect(31, 3, 33, 8) | clear_rect(31, 6, 39, 8)
    forest(20, keep, 0.9, 0.25)
    room.add("o_porcupine", 28 * TILE, 4 * TILE + 8)
    room.add("o_porcupine", 36 * TILE, 7 * TILE + 8)
    room.add("o_bat", 24 * TILE, 7 * TILE)
    room.add("o_gem_pickup", 32 * TILE, 4 * TILE)
    # Forest C: the clearing where Liam's letter lies
    keep = clear_rect(40, 6, 45, 8) | clear_rect(45, 3, 55, 10)
    forest(40, keep, 0.9, 0.35)
    room.add("o_letter", 50 * TILE, 6 * TILE + 8)
    room.add("o_porcupine", 47 * TILE, 4 * TILE + 8)
    room.add("o_porcupine", 53 * TILE, 9 * TILE)
    for (c, r) in [(48, 8), (52, 4), (51, 9), (46, 9), (54, 5)]:
        room.add("o_grass", c * TILE, r * TILE)

    # ---------------- Music, camera, walls ----------------
    music = {(0, 0): "o_forest_music", (1, 0): "o_forest_music", (2, 0): "o_forest_music",
             (0, 1): "o_village_music", (1, 1): "o_village_music", (2, 1): "o_village_music",
             (0, 2): "o_village_music", (1, 2): "o_village_music", (2, 2): "o_desert_music"}
    for (sx, sy), obj in music.items():
        room.add(obj, sx * 320 + 24, sy * 180 + 40)
    room.add("o_camera", 0, 0)
    room.solid_cells(solids)
    return room


def interior(name, music_obj, door_room, door_start, inside_name, furnish):
    room = Room(name, 320, 180)
    solids = set()
    c0, c1, r0, r1 = 4, 15, 1, 9       # floor/wall area; bottom wall at r1+1
    for c in range(20):
        for r in range(12):
            room.set_tile("Tiles_Ground", c, r, BLACK)
    for c in range(c0, c1 + 1):
        room.set_tile("Tiles_Ground", c, r0, BRICK_TOP[c % 2])
        room.set_tile("Tiles_Ground", c, r0 + 1, BRICK_BOT[c % 2])
        for r in range(r0 + 2, r1 + 1):
            room.set_tile("Tiles_Ground", c, r, FLOOR)
    for r in range(r0, r1 + 1):
        room.set_tile("Tiles_Ground", c0 - 1, r, WALL_SIDE)
        room.set_tile("Tiles_Ground", c1 + 1, r, WALL_SIDE)
    # Doorway in the bottom wall
    door_cols = (9, 10)
    for c in door_cols:
        room.set_tile("Tiles_Ground", c, r1 + 1, FLOOR)
    # Walls: everything that isn't floor
    for c in range(20):
        for r in range(12):
            floor = c0 <= c <= c1 and r0 + 2 <= r <= r1
            doorway = c in door_cols and r == r1 + 1
            if not floor and not doorway:
                solids.add((c, r))
    room.add("o_door", door_cols[0] * TILE, (r1 + 1) * TILE, sx=2, code=f"room_ = {door_room};\nstart_ = {door_start};")
    room.add("o_start_position", 10 * TILE, r1 * TILE + 4, name=inside_name)
    furnish(room, solids)
    room.add(music_obj, 24, 24)
    room.add("o_camera", 0, 0)
    room.solid_cells(solids)
    return room


def furniture(room, solids, tiles, c, r):
    for dr, row in enumerate(tiles):
        for dc, t in enumerate(row):
            room.set_tile("Tiles_Decor", c + dc, r + dr, t)
            solids.add((c + dc, r + dr))


def home(room, solids):
    furniture(room, solids, [[199], [215]], 4, 3)          # Jordan's bed
    furniture(room, solids, [[200], [216]], 5, 3)          # Liam's bed
    furniture(room, solids, [[196], [212]], 7, 3)          # dresser
    furniture(room, solids, [[202], [218]], 14, 3)         # kitchen
    furniture(room, solids, [[203]], 15, 3)
    furniture(room, solids, [[228, 229, 230]], 11, 6)      # table
    room.add("o_mum", 11 * TILE, 3 * TILE + 4)


def granny(room, solids):
    furniture(room, solids, [[201], [217]], 4, 3)
    furniture(room, solids, [[198], [214]], 6, 3)
    furniture(room, solids, [[197], [213]], 15, 3)
    furniture(room, solids, [[202], [218]], 14, 3)
    furniture(room, solids, [[234]], 12, 6)
    room.add("o_granny", 9 * TILE, 3 * TILE + 4)
    room.add("o_sweetie_tin", 12 * TILE + 8, 6 * TILE + 10)


def post_office(room, solids):
    furniture(room, solids, [[231, 232, 233, 228, 229, 230]], 7, 5)   # counter
    furniture(room, solids, [[196, 197, 198], [212, 213, 214]], 4, 3)  # pigeon holes
    furniture(room, solids, [[203, 203]], 14, 3)
    furniture(room, solids, [[203]], 15, 4)
    room.add("o_dad", 9 * TILE, 3 * TILE)
    room.add("o_save_point", 5 * TILE + 8, 8 * TILE + 6)
    room.add("o_sign", 14 * TILE + 8, 8 * TILE + 4, code='text[0] = "Dad\'s Post Office.";\ntext[1] = "Use the post box to save your progress.";')


def all_rooms():
    rooms = []
    init = Room("r_init", 320, 180)
    init.add("o_game", 16, 16)
    rooms.append(init)
    title = Room("r_title", 320, 180)
    title.add("o_title", 0, 0)
    title.add("o_title_music", 24, 24)
    rooms.append(title)
    import regions
    rooms.append(regions.village())
    rooms.append(regions.old_forest())
    rooms.append(regions.desert())
    rooms.append(interior("r_home", "o_home_music", "r_village", "i_home_out", "i_home_in", home))
    rooms.append(interior("r_granny", "o_home_music", "r_village", "i_granny_out", "i_granny_in", granny))
    rooms.append(interior("r_post_office", "o_village_music", "r_village", "i_post_office_out", "i_post_office_in", post_office))
    return rooms
