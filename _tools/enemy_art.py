"""Pixel art for the new enemies, in the style of the existing ones: a 1px black outline round
every shape, 3-4 shades per colour, lit from the top left. Maps are text: '.' is clear, the other
characters are looked up in the sprite's palette; the outline is added automatically."""
from PIL import Image
import math, random

def draw(rows, pal, outline=True):
    h = len(rows); w = max(len(r) for r in rows)
    im = Image.new("RGBA", (w + 2, h + 2), (0, 0, 0, 0))
    px = im.load()
    for y, row in enumerate(rows):
        for x, ch in enumerate(row):
            if ch != "." and ch != " ":
                px[x + 1, y + 1] = pal[ch] + (255,)
    if outline:
        filled = {(x, y) for x in range(w + 2) for y in range(h + 2) if px[x, y][3] > 0}
        for x, y in filled:
            for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                nx, ny = x + dx, y + dy
                if 0 <= nx < w + 2 and 0 <= ny < h + 2 and (nx, ny) not in filled:
                    px[nx, ny] = (0, 0, 0, 255)
    return im

def overlay(base, top, at=(0, 0)):
    im = base.copy(); im.alpha_composite(top, at); return im

K = (24, 24, 24); W = (250, 250, 240); R = (210, 50, 60)

# ---------- Armadillo ----------
ARM = {"1": (84, 66, 60), "2": (128, 100, 84), "3": (176, 146, 112), "4": (222, 198, 150),
       "5": (150, 98, 86), "6": (206, 146, 122), "k": K}
arm_walk = [
    ["......222222.....",
     "....2233333322...",
     "...234343434332..",
     "..23434343434332.",
     "..121212121212226",
     "..11111111111112666",
     "...55.55...55.5.6k6",
     "...5..5....5..5..66"],
    ["......222222.....",
     "....2233333322...",
     "...234343434332..",
     "..23434343434332.",
     "..121212121212226",
     "..11111111111112666",
     "....55.55...55.56k6",
     "....5...5....5...66"],
]
arm_roll = []
for ph in range(4):
    rows = []
    for y in range(12):
        row = ""
        for x in range(12):
            dx, dy = x - 5.5, y - 5.5
            if dx * dx + dy * dy > 33: row += "."; continue
            band = int((dx * math.cos(ph * math.pi / 4) + dy * math.sin(ph * math.pi / 4) + 8) // 2) % 2
            light = (-dx - dy) / 8
            shade = 3 if light > 0.35 else 2 if light > -0.4 else 1
            if band and shade > 1: shade -= 1
            if light > 0.75 and not band: shade = 4
            row += str(shade)
        rows.append(row)
    arm_roll.append(rows)

# ---------- Snake ----------
SNK = {"1": (38, 84, 46), "2": (66, 132, 62), "3": (118, 184, 78), "4": (184, 222, 120), "k": K, "r": R, "y": (230, 200, 70)}
snake = {
 "idle": [
    ["..........333..",
     ".........34433.",
     ".........3k333r",
     "..........333..",
     "..........33...",
     "......222223...",
     "....2233332....",
     "...23y3y3y32...",
     "...234343432...",
     "....12121212...",
     ".....111111...."],
    ["...............",
     "..........333..",
     ".........34433.",
     ".........3k333.",
     "..........333..",
     "......22223....",
     "....2233332....",
     "...23y3y3y32...",
     "...234343432...",
     "....12121212...",
     ".....111111...."]],
 "strike": [
    ["...............",
     "...............",
     "...............",
     "...............",
     "......2222.....",
     "....2233332.333.",
     "...23y3y3y33443.",
     "...234343433k333r",
     "....12121212333.",
     ".....111111....."],
 ]}

# ---------- Dust devil ----------
DST = {"1": (138, 104, 70), "2": (184, 146, 98), "3": (220, 190, 140), "4": (246, 228, 188)}
def dust(ph):
    rnd = random.Random(ph)
    rows = []
    H = 22
    for y in range(H):
        half = max(0.8, 8.5 * (1 - y / (H + 2)) ** 1.3) + 0.8 * math.sin(y * 0.6 + ph * 1.6)
        cx = 9 + 2.2 * math.sin(y * 0.3 + ph * 1.2) * (y / H)
        row = ""
        for x in range(19):
            if abs(x - cx) > half: 
                row += "4" if rnd.random() < 0.02 else "."
                continue
            stripe = math.sin((x - cx) * 0.9 + y * 0.8 - ph * 1.7)
            v = 3 if stripe > 0.35 else 2 if stripe > -0.4 else 1
            if x - cx < -half + 1.2 and v < 3: v += 1
            if y < 2 and v < 4: v += 1
            row += str(v)
        rows.append(row)
    return rows

# ---------- Skeleton warrior ----------
SKL = {"1": (110, 102, 92), "2": (176, 166, 146), "3": (226, 220, 200), "4": (252, 250, 236), "k": K}
skel_walk = [
    [".....3333.....",
     "....344443....",
     "....3k44k3....",
     "....334433....",
     ".....3223.....",
     "......33......",
     "...23343332...",
     "..2.3.33.3.2..",
     "..2..3333..2..",
     "..3..3..3..3..",
     ".....3333.....",
     ".....3..3.....",
     ".....3..3.....",
     "....33...3....",
     ".........33..."],
    [".....3333.....",
     "....344443....",
     "....3k44k3....",
     "....334433....",
     ".....3223.....",
     "......33......",
     "...23343332...",
     "..2.3.33.3.2..",
     "..2..3333..2..",
     "..3..3..3..3..",
     ".....3333.....",
     ".....3..3.....",
     ".....3..3.....",
     "....3...33....",
     "...33........."],
]
ITEM = {"s": (150, 160, 176), "S": (210, 220, 232), "h": (120, 80, 50), "H": (170, 120, 70), "g": (200, 160, 60),
        "e": (90, 60, 40), "E": (140, 100, 60), "m": (190, 190, 200)}
sword = ["...S", "...S", "...S", "..sS", "..sS", ".ggg.", "..h.", "..h."]
spear = [".m.", "mSm", ".S.", ".h.", ".h.", ".h.", ".H.", ".h.", ".h.", ".H.", ".h.", ".h.", ".h."]
shield = [".EEEE.", "EeEEeE", "EEmmEE", "EEmmEE", "EeEEeE", ".EEEE.", "..EE.."]

# ---------- Blob ----------
def blob(phase, col):
    """phase 0 sitting (squashed), 1 rising (stretched), 2 in the air."""
    w, h, lift = {0: (15, 9, 0), 1: (11, 13, 0), 2: (12, 11, 4)}[phase]
    W_, H_ = 17, 15
    rows = []
    for y in range(H_):
        row = ""
        for x in range(W_):
            cx, cy = W_ / 2 - 0.5, H_ - 1 - lift - h / 2
            dx, dy = (x - cx) / (w / 2), (y - cy) / (h / 2)
            if dy > 0 and phase != 2: d = dx * dx + dy * dy * 0.7
            else: d = dx * dx + dy * dy
            if d > 1: row += "."; continue
            light = -(dx * 0.6 + dy)
            v = 4 if (light > 0.9 and dx < 0) else 3 if light > 0.2 else 2 if light > -0.6 else 1
            row += str(v)
        rows.append(row)
    # eyes
    ey = int(H_ - 1 - lift - h / 2) - (1 if phase != 1 else 2)
    for ex in (6, 10):
        r = list(rows[ey]); r[ex] = "k"; rows[ey] = "".join(r)
    pal = {str(i + 1): c for i, c in enumerate(col)}
    pal.update({"k": K, "s": (0, 0, 0)})
    im = draw(rows, pal)
    if phase == 2:  # a soft shadow on the ground under it
        sh = Image.new("RGBA", im.size, (0, 0, 0, 0)); sp = sh.load()
        cx, cy = im.width / 2 - 0.5, im.height - 2
        for x in range(im.width):
            for y in range(im.height - 3, im.height):
                if ((x - cx) / 4.5) ** 2 + ((y - cy) / 1.2) ** 2 <= 1:
                    sp[x, y] = (0, 0, 0, 80)
        sh.alpha_composite(im); im = sh
    return im
BLOBS = {"green (slow)": [(40, 110, 50), (70, 160, 70), (120, 210, 100), (200, 245, 180)],
         "blue (fast)": [(36, 70, 140), (60, 110, 200), (110, 170, 240), (200, 230, 255)],
         "purple (splits once)": [(80, 40, 120), (130, 70, 180), (180, 120, 220), (230, 200, 250)],
         "red (splits twice)": [(120, 30, 40), (180, 50, 60), (230, 100, 100), (255, 200, 200)]}

# ---------- Scorpion ----------
SCO = {"1": (96, 40, 30), "2": (150, 66, 44), "3": (200, 104, 62), "4": (236, 160, 104), "k": K}
scorp = [
    ["..33.............",
     ".3443............",
     ".3..3............",
     "..3.3............",
     "...33............",
     "....3.......2.2..",
     "....33.....22222.",
     ".....3222233333k2",
     "......2343434332.",
     ".......22222222..",
     "......1.1.1.1.1.."],
    ["..33.............",
     ".3443............",
     ".3..3............",
     "..3.3............",
     "...33............",
     "....3.......2.2..",
     "....33.....22222.",
     ".....3222233333k2",
     "......2343434332.",
     ".......22222222..",
     ".......1.1.1.1.1."],
]
MOUND = {"1": (170, 132, 86), "2": (206, 170, 118), "3": (236, 210, 160)}
mound = [
    ["................",
     "................",
     "......2332......",
     "....22333332....",
     "..1122222222211.",
     "..11111111111111"],
    ["................",
     ".......23.......",
     ".....223332.....",
     "...1222333322...",
     "..1122222222211.",
     "..11111111111111"],
]

def sheet():
    S = 5
    items = []
    items.append(("Armadillo: walking (faces the way it goes)", [draw(f, ARM) for f in arm_walk]))
    items.append(("Armadillo: rolled up (can't be hurt), rolling", [draw(f, ARM) for f in arm_roll]))
    items.append(("Snake: waiting (tongue flicks)", [draw(f, SNK) for f in snake["idle"]]))
    items.append(("Snake: strike", [draw(f, SNK) for f in snake["strike"]]))
    items.append(("Dust devil (only bombs hurt it)", [draw(dust(p), DST) for p in range(4)]))
    base = [draw(f, SKL) for f in skel_walk]
    items.append(("Skeleton warrior: no weapon", base))
    items.append(("Skeleton: sword", [overlay(b, draw(sword, ITEM), (11, 6)) for b in base]))
    items.append(("Skeleton: throwing spear", [overlay(b, draw(spear, ITEM), (0, 0)) for b in base]))
    items.append(("Skeleton: shield", [overlay(b, draw(shield, ITEM), (0, 7)) for b in base]))
    for name, col in BLOBS.items():
        items.append((f"Blob: {name}", [blob(p, col) for p in range(3)]))
    items.append(("Scorpion: scuttling", [draw(f, SCO) for f in scorp]))
    items.append(("Scorpion: burrowed (the mound moves)", [draw(f, MOUND) for f in mound]))
    return items

if __name__ == "__main__":
    from PIL import ImageDraw, ImageFont
    F = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 16)
    items = sheet()
    S = 5
    cols = 2
    cellw = 640
    rowsh = []
    for i in range(0, len(items), cols):
        rowsh.append(max(max(f.height for f in it[1]) * S + 40 for it in items[i:i + cols]))
    im = Image.new("RGBA", (cellw * cols + 20, sum(rowsh) + 20), (74, 150, 70, 255))
    d = ImageDraw.Draw(im)
    y = 10
    for ri, i in enumerate(range(0, len(items), cols)):
        for j, (name, frames) in enumerate(items[i:i + cols]):
            x = 10 + j * cellw
            d.text((x, y), name, fill=(255, 255, 255), font=F)
            fx = x
            for f in frames:
                big = f.resize((f.width * S, f.height * S), Image.NEAREST)
                im.alpha_composite(big, (fx, y + 26)); fx += big.width + 12
        y += rowsh[ri]
    im.save("/tmp/claude-0/enemy_sheet.png")
    print(im.size)
