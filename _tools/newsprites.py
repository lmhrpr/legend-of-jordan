"""Small new pixel-art sprites drawn to match the original style (black outline, flat colours)."""
from PIL import Image
from sprites import new_sprite

PAL = {
    ".": None,
    "k": (20, 16, 24, 255),      # outline
    "r": (200, 40, 48, 255),     # post-box red
    "R": (140, 24, 36, 255),     # red shade
    "h": (240, 110, 100, 255),   # red highlight
    "y": (250, 210, 90, 255),    # gold
    "g": (60, 60, 70, 255),      # slot
    "w": (245, 240, 225, 255),   # paper
    "W": (200, 192, 175, 255),   # paper shade
    "b": (70, 110, 200, 255),    # tin blue
    "B": (40, 70, 140, 255),     # tin shade
    "c": (130, 170, 240, 255),   # tin highlight
    "p": (240, 120, 170, 255),   # sweetie pink
    "o": (250, 170, 60, 255),    # sweetie orange
    "e": (120, 200, 90, 255),    # sweetie green
    "s": (200, 60, 60, 255),     # wax seal
}


def art(rows):
    h = len(rows); w = max(len(r) for r in rows)
    im = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    for y, row in enumerate(rows):
        for x, ch in enumerate(row):
            if PAL.get(ch):
                im.putpixel((x, y), PAL[ch])
    return im


POST_BOX = [
    "....kkkkkkkk....",
    "...khhhhhhrrk...",
    "..khrrrrrrrrRk..",
    "..kkkkkkkkkkkk..",
    "..krrrrrrrrrRk..",
    "..kgggggggggRk..",
    "..krrrrrrrrrRk..",
    "..khrrrrrrrrRk..",
    "..khrkkkkkkrRk..",
    "..khrkyyyykrRk..",
    "..khrkkkkkkrRk..",
    "..khrrrrrrrrRk..",
    "..khrrrrrrrrRk..",
    "..khrrrrrrrrRk..",
    "..khrrrrrrrrRk..",
    "..khrrrrrrrrRk..",
    "..khrrrrrrrrRk..",
    "..khrrrrrrrrRk..",
    "..krrrrrrrrrRk..",
    ".kkkkkkkkkkkkkk.",
    ".kRRRRRRRRRRRRk.",
    ".kkkkkkkkkkkkkk.",
]

SWEETIE_TIN = [
    "................",
    "................",
    "....pk.ok.ek....",
    "...kppkookeek...",
    "..kkkkkkkkkkkk..",
    ".kccccccccccccBk",
    ".kbbbbbbbbbbbbBk",
    ".kkkkkkkkkkkkkkk",
    ".kbbyybbbbyybbBk",
    ".kbbbbyyyybbbbBk",
    ".kbbbbbbbbbbbbBk",
    ".kbbyybbbbyybbBk",
    ".kBBBBBBBBBBBBBk",
    "..kkkkkkkkkkkkk.",
    "................",
    "................",
]

LETTER = [
    "kkkkkkkkkkkkkk",
    "kwWwwwwwwwwWwk",
    "kwwWwwwwwwWwwk",
    "kwwwWwwwwWwwwk",
    "kwwwwWsswwwwwk",
    "kwwwwwsswwwwwk",
    "kwwwwwwwwwwwwk",
    "kWWWWWWWWWWWWk",
    "kkkkkkkkkkkkkk",
]


def signposts():
    """Three sign frames from the original s_sign: plain board, pointing right, pointing left."""
    import glob, json, re
    d = "/home/claude/sprites_in/sprites/s_sign"
    y = json.loads(re.sub(r",(\s*[}\]])", r"\1", open(f"{d}/s_sign.yy").read()))
    src = Image.open(f"{d}/{y['frames'][0]['compositeImage']['FrameId']['name']}.png").convert("RGBA")
    half = src.crop((0, 0, 8, 16))
    board = Image.new("RGBA", (16, 16), (0, 0, 0, 0))
    board.paste(half, (0, 0)); board.paste(half.transpose(Image.FLIP_LEFT_RIGHT), (8, 0))
    return [board, src, src.transpose(Image.FLIP_LEFT_RIGHT)]


def dark_tree():
    """A gloomier, blue-green version of the original s_tree for the darker woods."""
    import colorsys, json, re
    d = "/home/claude/sprites_in/sprites/s_tree"
    y = json.loads(re.sub(r",(\s*[}\]])", r"\1", open(f"{d}/s_tree.yy").read()))
    im = Image.open(f"{d}/{y['frames'][0]['compositeImage']['FrameId']['name']}.png").convert("RGBA")
    px = im.load()
    for yy in range(im.height):
        for xx in range(im.width):
            r, g, b, a = px[xx, yy]
            if a == 0:
                continue
            h, s, v = colorsys.rgb_to_hsv(r / 255, g / 255, b / 255)
            if v < 0.15:
                continue        # keep the black outline
            r, g, b = colorsys.hsv_to_rgb((h + 0.06) % 1, min(1, s * 0.85), v * 0.62)
            px[xx, yy] = (int(r * 255), int(g * 255), int(b * 255), a)
    return im


def build():
    new_sprite("s_tree_dark", [dark_tree()], 16, 44, "Sprites/World Sprites", bbox=(4, 13, 27, 46), bbox_mode=2)
    new_sprite("s_signpost", signposts(), 0, 16, "Sprites/World Sprites")
    new_sprite("s_post_box", [art(POST_BOX)], 8, 21, "Sprites/World Sprites")
    new_sprite("s_sweetie_tin", [art(SWEETIE_TIN)], 8, 13, "Sprites/World Sprites")
    new_sprite("s_letter", [art(LETTER)], 7, 8, "Sprites/Item Sprites")
    new_sprite("s_keeper", keeper_frames(), 16, 30, "Sprites/NPC Sprites", speed=3.0)
    new_sprite("s_ruin_lid", [ruin_lid()], 16, 16, "Sprites/World Sprites")
    new_sprite("s_button_badge", button_badges(), 0, 0, "Sprites/UI Sprites")
    return ["s_button_badge", "s_keeper", "s_ruin_lid", "s_tree_dark", "s_signpost", "s_post_box", "s_sweetie_tin", "s_letter"]


def outline(im):
    """Add a 1px black outline round the opaque pixels (like the original sprites)."""
    out = im.copy()
    px, opx = im.load(), out.load()
    for y in range(im.height):
        for x in range(im.width):
            if px[x, y][3] == 0:
                for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                    nx, ny = x + dx, y + dy
                    if 0 <= nx < im.width and 0 <= ny < im.height and px[nx, ny][3] > 0 and px[nx, ny][:3] != (20, 16, 24):
                        opx[x, y] = (20, 16, 24, 255)
                        break
    return out


def keeper_frames():
    """Stand-in Keeper of the Old Forest: a small hooded moss creature with a beard and a staff."""
    from PIL import ImageDraw
    frames = []
    for bob, blink in ((0, False), (1, False), (1, True), (0, False)):
        im = Image.new("RGBA", (32, 32), (0, 0, 0, 0))
        d = ImageDraw.Draw(im)
        y0 = 1 + bob
        moss, moss_dark, moss_light = (74, 122, 64, 255), (46, 84, 52, 255), (124, 170, 88, 255)
        # Staff
        d.line([(25, 8 + y0), (25, 29)], fill=(120, 78, 44, 255), width=2)
        d.ellipse([22, 3 + y0, 28, 9 + y0], fill=(108, 180, 92, 255))           # leafy top
        # Robe
        d.polygon([(9, 29), (23, 29), (21, 14 + y0), (11, 14 + y0)], fill=moss)
        d.polygon([(9, 29), (12, 29), (12, 16 + y0), (11, 14 + y0)], fill=moss_light)
        d.polygon([(20, 29), (23, 29), (21, 14 + y0), (20, 16 + y0)], fill=moss_dark)
        # Hood
        d.ellipse([8, 3 + y0, 24, 19 + y0], fill=moss)
        d.ellipse([9, 4 + y0, 15, 12 + y0], fill=moss_light)
        d.ellipse([11, 8 + y0, 21, 17 + y0], fill=(30, 26, 40, 255))              # shadowed face
        # Glowing eyes
        if not blink:
            for ex in (13, 18):
                d.rectangle([ex, 11 + y0, ex + 1, 12 + y0], fill=(255, 226, 92, 255))
        else:
            for ex in (13, 18):
                d.line([(ex, 12 + y0), (ex + 1, 12 + y0)], fill=(255, 226, 92, 255))
        # Beard
        d.polygon([(12, 15 + y0), (20, 15 + y0), (16, 26 + y0)], fill=(238, 236, 226, 255))
        d.line([(14, 17 + y0), (16, 23 + y0)], fill=(200, 196, 186, 255))
        # Postbag strap and bag (he's on the round too)
        d.line([(11, 15 + y0), (20, 24)], fill=(150, 60, 50, 255))
        d.rectangle([18, 22, 22, 26], fill=(196, 64, 56, 255))
        # Feet
        d.rectangle([11, 29, 13, 30], fill=(60, 44, 40, 255))
        d.rectangle([18, 29, 20, 30], fill=(60, 44, 40, 255))
        frames.append(outline(im))
    return frames


def ruin_lid():
    """The stone slab sealing the way into the ruins (tiles 243/244/259/260)."""
    src = Image.open("/tmp/claude-0/-home-claude/bfa170d3-60b9-5a2e-b951-afe43e5c5976/scratchpad/top_down_raw.png").convert("RGBA")
    return src.crop((3 * 16, 15 * 16, 5 * 16, 17 * 16))


def button_badges():
    """Corner badges for the equipped-item boxes: frame 0 = Z, frame 1 = X.
    Uses the green and black of s_inv_box_equipped's border."""
    letters = {
        "Z": ["#####", "...#.", "..#..", ".#...", "#####"],
        "X": ["#...#", ".#.#.", "..#..", ".#.#.", "#...#"],
    }
    black, green, light = (0, 0, 0, 255), (60, 184, 120, 255), (172, 212, 115, 255)
    frames = []
    for key in ("Z", "X"):
        im = Image.new("RGBA", (9, 9), black)
        for y in range(1, 8):
            for x in range(1, 8):
                im.putpixel((x, y), green)
        for x in range(1, 8):
            im.putpixel((x, 1), light)            # highlight along the top, like the box border
        for y, row in enumerate(letters[key]):
            for x, ch in enumerate(row):
                if ch == "#":
                    im.putpixel((2 + x, 2 + y), black)
        frames.append(im)
    return frames
