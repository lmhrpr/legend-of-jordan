"""Helpers to write GameMaker 2024 (.yy) resource files."""
import json, os, re, uuid

OUT = "/home/claude/out/TheLegendOfJordan"


_NS = uuid.UUID("5d1c0a7e-4a0b-4c8e-9c0e-1e6d0f5a9b21")


def uid(key=None):
    """A UUID. With a key it's deterministic, so rebuilding doesn't churn git history."""
    return str(uuid.uuid5(_NS, key)) if key is not None else str(uuid.uuid4())


def load_yy(path):
    t = open(path, encoding="utf-8").read()
    return json.loads(re.sub(r",(\s*[}\]])", r"\1", t))


def _val(v, ind, inline):
    if isinstance(v, dict):
        return _obj(v, ind, inline)
    if isinstance(v, list):
        return _arr(v, ind, inline)
    if isinstance(v, bool):
        return "true" if v else "false"
    if v is None:
        return "null"
    if isinstance(v, float):
        return repr(v)
    return json.dumps(v)


def _obj(d, ind, inline):
    if inline or not d:
        return "{" + "".join(f'{json.dumps(k)}:{_val(v, ind, True)},' for k, v in d.items()) + "}"
    pad = "  " * (ind + 1)
    s = "{\n"
    for k, v in d.items():
        s += f"{pad}{json.dumps(k)}:{_val(v, ind + 1, False)},\n"
    return s + "  " * ind + "}"


def _arr(a, ind, inline):
    if not a:
        return "[]"
    if inline:
        return "[" + ",".join(_val(v, ind, True) for v in a) + ",]"
    pad = "  " * (ind + 1)
    s = "[\n"
    for v in a:
        s += f"{pad}{_val(v, ind + 1, True)},\n"
    return s + "  " * ind + "]"


def dumps(d):
    return _obj(d, 0, False)


def write(relpath, data):
    p = os.path.join(OUT, relpath)
    os.makedirs(os.path.dirname(p), exist_ok=True)
    with open(p, "w", encoding="utf-8", newline="\n") as f:
        f.write(data if isinstance(data, str) else dumps(data))


def ref(kind, name):
    return {"name": name, "path": f"{kind}/{name}/{name}.yy"}


def folder(path):
    name = path.split("/")[-1]
    return {"name": name, "path": f"folders/{path}.yy"}
