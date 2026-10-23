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
    return ["s_tree_dark", "s_signpost", "s_post_box", "s_sweetie_tin", "s_letter"]
