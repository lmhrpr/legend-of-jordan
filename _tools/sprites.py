"""Convert the original (2.3-format) sprites to GameMaker 2024 format, and create new sprites."""
import os, shutil
from PIL import Image
from gm import OUT, uid, load_yy, write, ref, folder

SRC = "/home/claude/sprites_in/sprites"


def sprite_yy(name, w, h, frame_ids, layer_ids, xorig, yorig, bbox, parent, speed=15.0,
              speed_type=0, collision_kind=1, bbox_mode=0, origin=9, tolerance=0):
    keyframes = []
    for i, fid in enumerate(frame_ids):
        keyframes.append({
            "$Keyframe<SpriteFrameKeyframe>": "",
            "Channels": {"0": {"$SpriteFrameKeyframe": "", "Id": {"name": fid, "path": f"sprites/{name}/{name}.yy"},
                               "resourceType": "SpriteFrameKeyframe", "resourceVersion": "2.0"}},
            "Disabled": False, "id": uid(f"{name}/keyframe/{i}"), "IsCreationKey": False, "Key": float(i), "Length": 1.0,
            "resourceType": "Keyframe<SpriteFrameKeyframe>", "resourceVersion": "2.0", "Stretch": False,
        })
    return {
        "$GMSprite": "v2", "%Name": name,
        "bboxMode": bbox_mode, "bbox_bottom": bbox[3], "bbox_left": bbox[0], "bbox_right": bbox[2], "bbox_top": bbox[1],
        "collisionKind": collision_kind, "collisionTolerance": tolerance, "DynamicTexturePage": False,
        "edgeFiltering": False, "For3D": False,
        "frames": [{"$GMSpriteFrame": "v1", "%Name": f, "name": f, "resourceType": "GMSpriteFrame", "resourceVersion": "2.0"} for f in frame_ids],
        "gridX": 0, "gridY": 0, "height": h, "HTile": False,
        "layers": [{"$GMImageLayer": "", "%Name": l, "blendMode": 0, "displayName": "default" if i == 0 else f"Layer {i}",
                    "isLocked": False, "name": l, "opacity": 100.0, "resourceType": "GMImageLayer", "resourceVersion": "2.0",
                    "visible": True} for i, l in enumerate(layer_ids)],
        "name": name, "nineSlice": None, "origin": origin, "parent": parent, "preMultiplyAlpha": False,
        "resourceType": "GMSprite", "resourceVersion": "2.0",
        "sequence": {
            "$GMSequence": "v1", "%Name": name, "autoRecord": True, "backdropHeight": 768, "backdropImageOpacity": 0.5,
            "backdropImagePath": "", "backdropWidth": 1366, "backdropXOffset": 0.0, "backdropYOffset": 0.0,
            "events": {"$KeyframeStore<MessageEventKeyframe>": "", "Keyframes": [], "resourceType": "KeyframeStore<MessageEventKeyframe>", "resourceVersion": "2.0"},
            "eventStubScript": None, "eventToFunction": {}, "length": float(len(frame_ids)), "lockOrigin": False,
            "moments": {"$KeyframeStore<MomentsEventKeyframe>": "", "Keyframes": [], "resourceType": "KeyframeStore<MomentsEventKeyframe>", "resourceVersion": "2.0"},
            "name": name, "playback": 1, "playbackSpeed": float(speed), "playbackSpeedType": speed_type,
            "resourceType": "GMSequence", "resourceVersion": "2.0", "showBackdrop": True, "showBackdropImage": False,
            "timeUnits": 1,
            "tracks": [{"$GMSpriteFramesTrack": "", "builtinName": 0, "events": [], "inheritsTrackColour": True,
                        "interpolation": 1, "isCreationTrack": False,
                        "keyframes": {"$KeyframeStore<SpriteFrameKeyframe>": "", "Keyframes": keyframes,
                                      "resourceType": "KeyframeStore<SpriteFrameKeyframe>", "resourceVersion": "2.0"},
                        "modifiers": [], "name": "frames", "resourceType": "GMSpriteFramesTrack", "resourceVersion": "2.0",
                        "spriteId": None, "trackColour": 0, "tracks": [], "traits": 0}],
            "visibleRange": None, "volume": 1.0, "xorigin": xorig, "yorigin": yorig,
        },
        "swatchColours": None, "swfPrecision": 2.525,
        "textureGroupId": {"name": "Default", "path": "texturegroups/Default"},
        "type": 0, "VTile": False, "width": w,
    }


def convert_all():
    names = []
    for name in sorted(os.listdir(SRC)):
        j = load_yy(f"{SRC}/{name}/{name}.yy")
        dst = f"{OUT}/sprites/{name}"
        fids = [f["compositeImage"]["FrameId"]["name"] for f in j["frames"]]
        lids = [l["name"] for l in j["layers"]]
        # Copy only the images the sprite actually uses (old folders hold stale leftovers)
        os.makedirs(dst, exist_ok=True)
        for fid in fids:
            shutil.copy(f"{SRC}/{name}/{fid}.png", f"{dst}/{fid}.png")
            for lid in lids:
                os.makedirs(f"{dst}/layers/{fid}", exist_ok=True)
                shutil.copy(f"{SRC}/{name}/layers/{fid}/{lid}.png", f"{dst}/layers/{fid}/{lid}.png")
        seq = j["sequence"]
        yy = sprite_yy(name, j["width"], j["height"], fids, lids, seq["xorigin"], seq["yorigin"],
                       (j["bbox_left"], j["bbox_top"], j["bbox_right"], j["bbox_bottom"]), j["parent"],
                       speed=seq["playbackSpeed"], speed_type=seq["playbackSpeedType"],
                       collision_kind=j["collisionKind"], bbox_mode=j["bboxMode"], origin=j["origin"],
                       tolerance=j.get("collisionTolerance", 0))
        write(f"sprites/{name}/{name}.yy", yy)
        names.append(name)
    return names


def new_sprite(name, images, xorig, yorig, parent_path, speed=15.0, bbox=None, bbox_mode=0):
    """Create a brand-new sprite from PIL images (all same size)."""
    w, h = images[0].size
    lid = uid(f"{name}/layer")
    fids = []
    d = f"{OUT}/sprites/{name}"
    os.makedirs(d, exist_ok=True)
    minx, miny, maxx, maxy = w, h, 0, 0
    for n, im in enumerate(images):
        fid = uid(f"{name}/frame/{n}")
        fids.append(fid)
        im.save(f"{d}/{fid}.png")
        os.makedirs(f"{d}/layers/{fid}", exist_ok=True)
        im.save(f"{d}/layers/{fid}/{lid}.png")
        bb = im.getbbox()
        if bb:
            minx, miny = min(minx, bb[0]), min(miny, bb[1])
            maxx, maxy = max(maxx, bb[2] - 1), max(maxy, bb[3] - 1)
    if maxx < minx:
        minx, miny, maxx, maxy = 0, 0, w - 1, h - 1
    if bbox is not None:
        minx, miny, maxx, maxy = bbox
    write(f"sprites/{name}/{name}.yy",
          sprite_yy(name, w, h, fids, [lid], xorig, yorig, (minx, miny, maxx, maxy), folder(parent_path), speed=speed, bbox_mode=bbox_mode))
    return name
