"""Pixel-art helpers: shape maps shaded like hand-made pixel art.
A map is text rows; each character is a material ('.' clear). Materials have a colour ramp (dark
to light). Each pixel's shade comes from a rounded 'height' (distance from the edge of its part),
lit from the top left, quantised to the ramp; edges between parts get a darker line; the outside
gets a 1px black outline. Fixed colours (eyes etc.) are materials with a one-colour ramp."""
from PIL import Image
import math

def shade(rows, mats, light=(-0.7, -0.7), outline=(0, 0, 0), inner_lines=True, flat=(), bias=None, tex=None, alpha=None):
    h = len(rows); w = max(len(r) for r in rows)
    rows = [r.ljust(w, ".") for r in rows]
    grid = [[rows[y][x] for x in range(w)] for y in range(h)]
    inside = lambda x, y: 0 <= x < w and 0 <= y < h and grid[y][x] != "."
    # distance from the edge of each part (same material), BFS
    INF = 99
    dist = [[INF] * w for _ in range(h)]
    from collections import deque
    q = deque()
    for y in range(h):
        for x in range(w):
            if not inside(x, y): continue
            m = grid[y][x]
            for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                nx, ny = x + dx, y + dy
                if not inside(nx, ny) or grid[ny][nx] != m:
                    dist[y][x] = 1; q.append((x, y)); break
    while q:
        x, y = q.popleft()
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            nx, ny = x + dx, y + dy
            if inside(nx, ny) and grid[ny][nx] == grid[y][x] and dist[ny][nx] > dist[y][x] + 1:
                dist[ny][nx] = dist[y][x] + 1; q.append((nx, ny))
    def H(x, y):
        if not inside(x, y): return 0
        return min(dist[x and y and 0 or 0] if False else dist[y][x], 6)
    im = Image.new("RGBA", (w + 2, h + 2), (0, 0, 0, 0)); px = im.load()
    lx, ly = light; ln = math.hypot(lx, ly); lx, ly = lx / ln, ly / ln
    for y in range(h):
        for x in range(w):
            if not inside(x, y): continue
            m = grid[y][x]; ramp = mats[m]
            if len(ramp) == 1 or m in flat:
                c = ramp[0] if len(ramp) == 1 else ramp[len(ramp) // 2]
            else:
                gx = (H(x + 1, y) if inside(x + 1, y) and grid[y][x + 1] == m else 0) - (H(x - 1, y) if inside(x - 1, y) and grid[y][x - 1] == m else 0)
                gy = (H(x, y + 1) if inside(x, y + 1) and grid[y + 1][x] == m else 0) - (H(x, y - 1) if inside(x, y - 1) and grid[y - 1][x] == m else 0)
                # surface normal ~ -gradient of height; facing the light = brighter
                v = -(gx * lx + gy * ly) * 0.45 + min(H(x, y), 4) * 0.18 - 0.25
                if bias: v += bias.get(m, 0)
                n = len(ramp)
                i = int(round((v + 0.6) / 1.6 * (n - 1)))
                if tex: i = tex(m, x, y, i, H(x, y))
                c = ramp[max(0, min(n - 1, i))]
            a = alpha.get(m, 255) if alpha else 255
            px[x + 1, y + 1] = c + (a,) if len(c) == 3 else c
    # darker line where two parts meet (on the lower/right part)
    if inner_lines:
        for y in range(h):
            for x in range(w):
                if not inside(x, y): continue
                m = grid[y][x]
                if m in flat or len(mats[m]) == 1: continue
                for dx, dy in ((-1, 0), (0, -1)):
                    nx, ny = x + dx, y + dy
                    if inside(nx, ny) and grid[ny][nx] != m and len(mats[grid[ny][nx]]) > 1 and grid[ny][nx] not in flat:
                        px[x + 1, y + 1] = mats[m][0] + (255,); break
    if outline:
        filled = {(x, y) for x in range(w + 2) for y in range(h + 2) if px[x, y][3] > 0}
        for x, y in filled:
            for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                nx, ny = x + dx, y + dy
                if 0 <= nx < w + 2 and 0 <= ny < h + 2 and (nx, ny) not in filled:
                    px[nx, ny] = outline + (255,)
    return im

def put(im, pts, col):
    px = im.load()
    for x, y in pts:
        px[x, y] = col + (255,) if len(col) == 3 else col
    return im

def flip(im): return im.transpose(Image.FLIP_LEFT_RIGHT)
