"""Draws every new enemy: art/enemies/<name>.png (a strip of frames each) and art/enemies/_all.png."""
import os, re, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from PIL import Image, ImageDraw, ImageFont
import arma, snake, dust, skel, blob, scorp
items = []
items += [("Armadillo: " + k, v) for k, v in arma.frames.items()]
items += [("Snake: slithering", snake.frames["slither"]), ("Snake: coiled, waiting", snake.frames["coiled"]), ("Snake: strike", snake.frames["strike"])]
items += [("Dust devil (only bombs hurt it)", dust.frames["dust devil"])]
items += [("Skeleton: " + k, v) for k, v in skel.frames.items()]
items += [("Blob: " + k, v) for k, v in blob.frames.items()]
items += [("Scorpion: " + k, v) for k, v in scorp.frames.items()]
OUT = sys.argv[1] if len(sys.argv) > 1 else "/home/claude/legend-of-jordan/art/enemies"
os.makedirs(OUT, exist_ok=True)
for f in os.listdir(OUT):
    if f.endswith(".png"): os.remove(os.path.join(OUT, f))
for name, frames in items:
    slug = re.sub(r"[^a-z0-9]+", "_", name.lower().split(" (")[0]).strip("_")
    w = max(f.width for f in frames); h = max(f.height for f in frames)
    strip = Image.new("RGBA", (w * len(frames), h), (0, 0, 0, 0))
    for i, f in enumerate(frames): strip.alpha_composite(f, (i * w + (w - f.width) // 2, h - f.height))
    strip.save(f"{OUT}/{slug}.png")
S = 5; cols = 2; cellw = 760
F = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 17)
rowh = [max(max(f.height for f in it[1]) * S + 40 for it in items[i:i + cols]) for i in range(0, len(items), cols)]
im = Image.new("RGBA", (cellw * cols + 20, sum(rowh) + 20), (74, 150, 70, 255)); d = ImageDraw.Draw(im)
y = 10
for ri, i in enumerate(range(0, len(items), cols)):
    for j, (name, frames) in enumerate(items[i:i + cols]):
        x = 10 + j * cellw; d.text((x, y), name, fill=(255, 255, 255), font=F)
        hmax = max(f.height for f in frames) * S
        for f in frames:
            big = f.resize((f.width * S, f.height * S), Image.NEAREST)
            im.alpha_composite(big, (x, y + 28 + hmax - big.height)); x += big.width + 12
    y += rowh[ri]
im.save(f"{OUT}/_all.png"); im.save("/tmp/claude-0/enemy_sheet2.png")
print(len(items), "sets", im.size)
