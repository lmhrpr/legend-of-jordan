"""Room/tileset writer for GameMaker 2024, plus a preview renderer."""
import os, random
from PIL import Image
from gm import OUT, write, ref, folder, uid

EMPTY = -2147483648
TILE = 16
TS_NAME = "ts_top_down"
_used_names = set()


def tileset():
    write(f"tilesets/{TS_NAME}/{TS_NAME}.yy", {
        "$GMTileSet": "v1", "%Name": TS_NAME, "autoTileSets": [],
        "macroPageTiles": {"SerialiseHeight": 0, "SerialiseWidth": 0, "TileSerialiseData": []},
        "name": TS_NAME, "out_columns": 16, "out_tilehborder": 2, "out_tilevborder": 2,
        "parent": folder("Tile Sets"), "resourceType": "GMTileSet", "resourceVersion": "2.0",
        "spriteId": ref("sprites", "s_top_down"), "spriteNoExport": True,
        "textureGroupId": {"name": "Default", "path": "texturegroups/Default"},
        "tileAnimationFrames": [], "tileAnimationSpeed": 15.0, "tileHeight": 16, "tilehsep": 0,
        "tilevsep": 0, "tileWidth": 16, "tilexoff": 0, "tileyoff": 0, "tile_count": 480,
    })


def compress(cells):
    """GameMaker TileCompressedData RLE: -n,v = v repeated n times; +n,v1..vn = literals."""
    out = []
    i = 0
    n = len(cells)
    while i < n:
        j = i
        while j + 1 < n and cells[j + 1] == cells[i]:
            j += 1
        run = j - i + 1
        if run >= 2:
            out += [-run, cells[i]]
            i = j + 1
        else:
            lit = [cells[i]]
            i += 1
            while i < n and (i + 1 >= n or cells[i + 1] != cells[i]):
                lit.append(cells[i])
                i += 1
            out += [len(lit)] + lit
    return out


class Room:
    def __init__(self, name, w_px, h_px, bg_sprite=None, bg_colour=4278190080, persistent=False):
        self.name, self.w, self.h = name, w_px, h_px
        self.cols, self.rows = -(-w_px // TILE), -(-h_px // TILE)
        self.tile_layers = {}          # name -> 2D list
        self.tile_order = []
        self.instances = []            # dicts
        self.bg_sprite, self.bg_colour = bg_sprite, bg_colour
        self.persistent = persistent

    def layer(self, lname):
        if lname not in self.tile_layers:
            self.tile_layers[lname] = [[EMPTY] * self.cols for _ in range(self.rows)]
            self.tile_order.append(lname)
        return self.tile_layers[lname]

    def set_tile(self, lname, c, r, idx):
        if 0 <= c < self.cols and 0 <= r < self.rows:
            self.layer(lname)[r][c] = idx

    def get_tile(self, lname, c, r):
        if lname not in self.tile_layers or not (0 <= c < self.cols and 0 <= r < self.rows):
            return EMPTY
        return self.tile_layers[lname][r][c]

    def add(self, obj, x, y, name=None, code=None, sx=1.0, sy=1.0):
        if name is None:
            n = 0
            while True:
                key = f"{self.name}/{len(self.instances)}/{obj}/{x}/{y}/{n}"
                name = "inst_" + uid(key).replace("-", "")[:8].upper()
                if name not in _used_names:
                    break
                n += 1
        assert name not in _used_names, f"duplicate instance name {name}"
        _used_names.add(name)
        self.instances.append({"obj": obj, "x": float(x), "y": float(y), "name": name, "code": code,
                               "sx": float(sx), "sy": float(sy)})
        return name

    def solid_rect(self, c0, r0, c1, r1):
        """Invisible wall over cells c0..c1, r0..r1 inclusive (one scaled instance)."""
        self.add("o_solid", c0 * TILE, r0 * TILE, sx=c1 - c0 + 1, sy=r1 - r0 + 1)

    def solid_cells(self, cells):
        """Merge a set of (c, r) cells into horizontal runs of o_solid."""
        rows = {}
        for c, r in cells:
            rows.setdefault(r, []).append(c)
        for r, cs in rows.items():
            cs.sort()
            start = prev = cs[0]
            for c in cs[1:] + [None]:
                if c is not None and c == prev + 1:
                    prev = c
                    continue
                self.solid_rect(start, r, prev, r)
                if c is not None:
                    start = prev = c

    # ---------------- writing ----------------
    def write(self):
        layers = []
        depth = 0
        inst_list = []
        for inst in self.instances:
            has_code = inst["code"] is not None
            inst_list.append({
                "$GMRInstance": "v4", "%Name": inst["name"], "colour": 4294967295, "frozen": False,
                "hasCreationCode": has_code, "ignore": False, "imageIndex": 0, "imageSpeed": 1.0,
                "inheritCode": False, "inheritedItemId": None, "inheritItemSettings": False, "isDnd": False,
                "name": inst["name"], "objectId": ref("objects", inst["obj"]), "properties": [],
                "resourceType": "GMRInstance", "resourceVersion": "2.0", "rotation": 0.0,
                "scaleX": inst["sx"], "scaleY": inst["sy"], "x": inst["x"], "y": inst["y"],
            })
            if has_code:
                write(f"rooms/{self.name}/InstanceCreationCode_{inst['name']}.gml", inst["code"].strip() + "\n")
        layers.append({
            "$GMRInstanceLayer": "", "%Name": "Instances", "depth": depth, "effectEnabled": True,
            "effectType": None, "gridX": 16, "gridY": 16, "hierarchyFrozen": False, "inheritLayerDepth": False,
            "inheritLayerSettings": False, "inheritSubLayers": True, "inheritVisibility": True,
            "instances": inst_list, "layers": [], "name": "Instances", "properties": [],
            "resourceType": "GMRInstanceLayer", "resourceVersion": "2.0", "userdefinedDepth": False, "visible": True,
        })
        # Tile layers: listed top-most first
        for lname in reversed(self.tile_order):
            depth += 100
            flat = [v for row in self.tile_layers[lname] for v in row]
            layers.append({
                "$GMRTileLayer": "", "%Name": lname, "depth": depth, "effectEnabled": True, "effectType": None,
                "gridX": 16, "gridY": 16, "hierarchyFrozen": False, "inheritLayerDepth": False,
                "inheritLayerSettings": False, "inheritSubLayers": True, "inheritVisibility": True, "layers": [],
                "name": lname, "properties": [], "resourceType": "GMRTileLayer", "resourceVersion": "2.0",
                "tiles": {"SerialiseHeight": self.rows, "SerialiseWidth": self.cols,
                          "TileCompressedData": compress(flat), "TileDataFormat": 1},
                "tilesetId": ref("tilesets", TS_NAME), "userdefinedDepth": False, "visible": True, "x": 0, "y": 0,
            })
        depth += 100
        layers.append({
            "$GMRBackgroundLayer": "", "%Name": "Background", "animationFPS": 15.0, "animationSpeedType": 0,
            "colour": self.bg_colour if not self.bg_sprite else 4294967295, "depth": depth, "effectEnabled": True,
            "effectType": None, "gridX": 16, "gridY": 16, "hierarchyFrozen": False, "hspeed": 0.0,
            "htiled": bool(self.bg_sprite), "inheritLayerDepth": False, "inheritLayerSettings": False,
            "inheritSubLayers": True, "inheritVisibility": True, "layers": [], "name": "Background",
            "properties": [], "resourceType": "GMRBackgroundLayer", "resourceVersion": "2.0",
            "spriteId": ref("sprites", self.bg_sprite) if self.bg_sprite else None, "stretch": False,
            "userdefinedAnimFPS": False, "userdefinedDepth": False, "visible": True, "vspeed": 0.0,
            "vtiled": bool(self.bg_sprite), "x": 0, "y": 0,
        })
        view_on = {"hborder": 32, "hport": 540, "hspeed": -1, "hview": 180, "inherit": False, "objectId": None,
                   "vborder": 32, "visible": True, "vspeed": -1, "wport": 960, "wview": 320, "xport": 0,
                   "xview": 0, "yport": 0, "yview": 0}
        view_off = dict(view_on, visible=False, hport=768, wport=1366, hview=768, wview=1366)
        yy = {
            "$GMRoom": "v1", "%Name": self.name, "creationCodeFile": "", "inheritCode": False,
            "inheritCreationOrder": False, "inheritLayers": False,
            "instanceCreationOrder": [{"name": i["name"], "path": f"rooms/{self.name}/{self.name}.yy"} for i in self.instances],
            "isDnd": False, "layers": layers, "name": self.name, "parent": folder("Rooms"), "parentRoom": None,
            "physicsSettings": {"inheritPhysicsSettings": False, "PhysicsWorld": False, "PhysicsWorldGravityX": 0.0,
                                "PhysicsWorldGravityY": 10.0, "PhysicsWorldPixToMetres": 0.1},
            "resourceType": "GMRoom", "resourceVersion": "2.0",
            "roomSettings": {"Height": self.h, "inheritRoomSettings": False, "persistent": self.persistent, "Width": self.w},
            "sequenceId": None,
            "views": [view_on] + [view_off] * 7,
            "viewSettings": {"clearDisplayBuffer": True, "clearViewBackground": False, "enableViews": True,
                             "inheritViewSettings": False},
            "volume": 1.0,
        }
        write(f"rooms/{self.name}/{self.name}.yy", yy)

    # ---------------- preview ----------------
    def preview(self, path, sprite_frames, tiles_img, show_hidden=True):
        im = Image.new("RGBA", (self.w, self.h), (0, 0, 0, 255))
        if self.bg_sprite:
            bg = sprite_frames[self.bg_sprite][0]
            for y in range(0, self.h, bg.height):
                for x in range(0, self.w, bg.width):
                    im.alpha_composite(bg, (x, y))
        for lname in self.tile_order:
            for r, row in enumerate(self.tile_layers[lname]):
                for c, v in enumerate(row):
                    if v != EMPTY and v > 0:
                        t = tiles_img.crop(((v % 16) * 16, (v // 16) * 16, (v % 16) * 16 + 16, (v // 16) * 16 + 16))
                        im.alpha_composite(t, (c * 16, r * 16))
        # Instances sorted by y (like depth = -y)
        from objects_table import OBJECTS
        for inst in sorted(self.instances, key=lambda i: i["y"]):
            spr = OBJECTS[inst["obj"]][0]
            visible = OBJECTS[inst["obj"]][2]
            if inst["obj"] == "o_solid":
                if show_hidden:
                    ov = Image.new("RGBA", (int(16 * inst["sx"]), int(16 * inst["sy"])), (255, 0, 0, 70))
                    im.alpha_composite(ov, (int(inst["x"]), int(inst["y"])))
                continue
            if inst["obj"] in ("o_door",):
                ov = Image.new("RGBA", (int(16 * inst["sx"]), int(16 * inst["sy"])), (255, 255, 0, 120))
                im.alpha_composite(ov, (int(inst["x"]), int(inst["y"])))
                continue
            if spr is None or (not visible and not show_hidden):
                continue
            frames, (ox, oy) = sprite_frames[spr], sprite_frames[spr + "#origin"]
            f = frames[0]
            px, py = int(inst["x"] - ox), int(inst["y"] - oy)
            if 0 - f.width < px < self.w and 0 - f.height < py < self.h:
                tmp = Image.new("RGBA", im.size, (0, 0, 0, 0))
                tmp.paste(f, (px, py), f)
                im.alpha_composite(tmp)
        im.save(path)
        return im


TREE_OBJS = {"o_tree", "o_tree_dark"}
BORDER_ROWS = {32.0, 192.0, 368.0, 544.0}
BORDER_COLS = {8.0: 0, 312.0: 1, 328.0: 0, 632.0: 1, 648.0: 0, 952.0: 0}


def thin_trees(room):
    """Same rules as _tools/thin_trees.py: border lines keep every other tree (staggered between
    screens, openings' edge trees always kept); other trees on a 32px grid clear of the borders."""
    trees = {(i["x"], i["y"]): i for i in room.instances if i["obj"] in TREE_OBJS}
    pos = set(trees)
    kept = set()
    for (x, y) in pos:
        if y in BORDER_ROWS:
            edge = (x - 16, y) not in pos or (x + 16, y) not in pos
            if int((x - 8) // 16) % 2 == 0 or edge:
                kept.add((x, y))
        elif x in BORDER_COLS:
            edge = (x, y - 16) not in pos or (x, y + 16) not in pos
            if (int((y - 16) // 16) + BORDER_COLS[x]) % 2 == 0 or edge:
                kept.add((x, y))
    for (x, y) in sorted(pos - kept, key=lambda p: (p[1], p[0])):
        if not any(abs(x - kx) < 32 and abs(y - ky) < 32 for kx, ky in kept):
            kept.add((x, y))
    drop = {id(trees[p]) for p in pos - kept}
    room.instances = [i for i in room.instances if id(i) not in drop]
