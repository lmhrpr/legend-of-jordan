"""Synthesise chiptune sound effects and music loops, and write GameMaker sound resources."""
import os, wave
import numpy as np
from gm import OUT, write, folder

SR = 22050


def note_freq(n):
    """n like 'C4', 'F#3', 'Bb2' or None for rest."""
    names = {"C": 0, "D": 2, "E": 4, "F": 5, "G": 7, "A": 9, "B": 11}
    p = names[n[0]]
    i = 1
    if n[i] == "#":
        p += 1; i += 1
    elif n[i] == "b":
        p -= 1; i += 1
    octave = int(n[i:])
    midi = 12 * (octave + 1) + p
    return 440.0 * 2 ** ((midi - 69) / 12)


def osc(kind, freq, dur, duty=0.5, vol=1.0):
    t = np.arange(int(SR * dur)) / SR
    if kind == "square":
        ph = (t * freq) % 1.0
        w = np.where(ph < duty, 1.0, -1.0)
    elif kind == "tri":
        ph = (t * freq) % 1.0
        w = 4 * np.abs(ph - 0.5) - 1
    elif kind == "sine":
        w = np.sin(2 * np.pi * freq * t)
    elif kind == "noise":
        # Stepped noise sounds more 8-bit
        step = max(1, int(SR / max(freq, 1)))
        n = np.random.uniform(-1, 1, len(t) // step + 2)
        w = np.repeat(n, step)[: len(t)]
    return w * vol


def env(sig, a=0.005, d=0.05, s=0.6, r=0.05):
    n = len(sig)
    e = np.ones(n) * s
    na, nd, nr = int(a * SR), int(d * SR), int(r * SR)
    na = min(na, n);
    e[:na] = np.linspace(0, 1, na) if na else e[:na]
    nd = min(nd, n - na)
    e[na:na + nd] = np.linspace(1, s, nd) if nd else e[na:na + nd]
    nr = min(nr, n)
    if nr:
        e[n - nr:] *= np.linspace(1, 0, nr)
    return sig * e


def sweep(kind, f0, f1, dur, duty=0.5, vol=1.0, curve=1.0):
    n = int(SR * dur)
    t = np.linspace(0, 1, n) ** curve
    f = f0 + (f1 - f0) * t
    ph = np.cumsum(f) / SR
    if kind == "square":
        w = np.where((ph % 1) < duty, 1.0, -1.0)
    elif kind == "tri":
        w = 4 * np.abs((ph % 1) - 0.5) - 1
    else:
        w = np.sin(2 * np.pi * ph)
    return w * vol


def cat(*parts):
    return np.concatenate(parts)


def save_wav(path, sig, peak=0.8):
    sig = np.asarray(sig, dtype=np.float64)
    m = np.max(np.abs(sig)) or 1
    sig = sig / m * peak
    data = (sig * 32767).astype(np.int16)
    with wave.open(path, "wb") as w:
        w.setnchannels(1); w.setsampwidth(2); w.setframerate(SR)
        w.writeframes(data.tobytes())
    return len(sig) / SR


# ---------------- Sound effects ----------------

def sfx():
    s = {}
    s["a_text"] = env(osc("square", 660, 0.035, duty=0.25), a=0.001, d=0.02, s=0.4, r=0.01)
    s["a_item"] = env(sweep("square", 500, 1200, 0.12, duty=0.25), a=0.001, d=0.05, s=0.5, r=0.04)
    s["a_hit"] = env(osc("noise", 3000, 0.12) * 0.7 + sweep("square", 300, 80, 0.12, duty=0.5) * 0.5, a=0.001, d=0.05, s=0.4, r=0.05)
    s["a_hurt"] = env(sweep("square", 520, 120, 0.3, duty=0.5) + osc("noise", 2000, 0.3) * 0.3, a=0.001, d=0.1, s=0.5, r=0.12)
    s["a_swipe"] = env(osc("noise", 8000, 0.13) * np.linspace(0.2, 1, int(SR * 0.13)), a=0.02, d=0.05, s=0.6, r=0.06)
    s["a_collect_item"] = cat(env(osc("square", note_freq("E6"), 0.06, 0.25), a=0.001, d=0.02, s=0.7, r=0.01),
                              env(osc("square", note_freq("B6"), 0.16, 0.25), a=0.001, d=0.05, s=0.5, r=0.1))
    s["a_menu_move"] = env(osc("square", 880, 0.05, 0.5), a=0.001, d=0.02, s=0.5, r=0.02)
    s["a_menu_select"] = cat(env(osc("square", 660, 0.06, 0.5), a=0.001, d=0.02, s=0.6, r=0.01),
                             env(osc("square", 990, 0.12, 0.5), a=0.001, d=0.04, s=0.6, r=0.06))
    s["a_pause"] = cat(*[env(osc("square", note_freq(n), 0.07, 0.25), a=0.001, d=0.03, s=0.6, r=0.02) for n in ["C5", "E5", "G5", "C6"]])
    s["a_unpause"] = cat(*[env(osc("square", note_freq(n), 0.07, 0.25), a=0.001, d=0.03, s=0.6, r=0.02) for n in ["C6", "G5", "E5", "C5"]])
    s["a_set_bomb"] = env(osc("noise", 6000, 0.4) * 0.5, a=0.01, d=0.1, s=0.5, r=0.1)
    s["a_explosion"] = env(osc("noise", 600, 0.9) + sweep("sine", 120, 30, 0.9) * 0.8, a=0.001, d=0.25, s=0.4, r=0.6)
    s["a_porcupine_attack"] = env(osc("noise", 4000, 0.18) * 0.6 + sweep("square", 900, 400, 0.18, 0.25) * 0.4, a=0.001, d=0.05, s=0.5, r=0.08)
    s["a_save"] = cat(*[env(osc("tri", note_freq(n), 0.12) + osc("square", note_freq(n), 0.12, 0.125) * 0.3, a=0.002, d=0.05, s=0.6, r=0.05)
                        for n in ["G5", "C6", "E6"]], env(osc("tri", note_freq("G6"), 0.5) + osc("square", note_freq("G6"), 0.5, 0.125) * 0.3, a=0.002, d=0.1, s=0.5, r=0.35))
    # "Item get" fanfare
    fan = []
    for n, d in [("G4", 0.14), ("A4", 0.14), ("B4", 0.14), ("C5", 0.14), ("D5", 0.14), ("E5", 0.14), ("F#5", 0.14), ("G5", 0.9)]:
        lead = osc("square", note_freq(n), d, 0.5) * 0.6
        harm = osc("square", note_freq(n) * 1.5, d, 0.25) * 0.25
        fan.append(env(lead + harm, a=0.003, d=0.05, s=0.7, r=0.04 if d < 0.5 else 0.5))
    s["a_found_item"] = cat(*fan)
    return s


# ---------------- Music ----------------

def render_track(bpm, voices, bars, beats_per_bar=4):
    """voices: list of (kind, duty, vol, notes) where notes = list of (note or None, beats)."""
    beat = 60.0 / bpm
    total = int(SR * beat * beats_per_bar * bars)
    mix = np.zeros(total)
    for kind, duty, vol, notes in voices:
        pos = 0.0
        while pos < bars * beats_per_bar:
            for n, b in notes:
                if pos >= bars * beats_per_bar:
                    break
                start = int(pos * beat * SR)
                dur = b * beat
                if n is not None:
                    if kind == "drum":
                        if n == "K":
                            sig = env(sweep("sine", 150, 40, 0.15), a=0.001, d=0.05, s=0.5, r=0.08) * 1.2
                        elif n == "S":
                            sig = env(osc("noise", 5000, 0.12), a=0.001, d=0.04, s=0.3, r=0.06)
                        else:  # hat
                            sig = env(osc("noise", 11000, 0.04), a=0.001, d=0.01, s=0.3, r=0.02) * 0.6
                    else:
                        sig = osc(kind, note_freq(n), dur * 0.95, duty)
                        sig = env(sig, a=0.004, d=min(0.08, dur * 0.3), s=0.65, r=min(0.04, dur * 0.2))
                    end = min(total, start + len(sig))
                    mix[start:end] += sig[: end - start] * vol
                pos += b
    return mix


def music():
    m = {}
    # --- Title: heroic, bright (C major, 112 bpm) ---
    lead = [("C5", 1), ("G4", 0.5), ("C5", 0.5), ("E5", 1), ("D5", 0.5), ("C5", 0.5),
            ("D5", 1.5), ("G4", 0.5), ("G4", 2),
            ("A4", 1), ("C5", 0.5), ("F5", 0.5), ("E5", 1), ("D5", 0.5), ("C5", 0.5),
            ("D5", 3), (None, 1),
            ("C5", 1), ("G4", 0.5), ("C5", 0.5), ("E5", 1), ("G5", 1),
            ("A5", 1.5), ("G5", 0.5), ("F5", 1), ("E5", 1),
            ("F5", 1), ("E5", 0.5), ("D5", 0.5), ("E5", 1), ("D5", 0.5), ("B4", 0.5),
            ("C5", 3), (None, 1)]
    bass = [("C3", 1), ("C3", 1), ("G2", 1), ("G2", 1), ("G2", 1), ("G2", 1), ("G2", 1), ("G2", 1),
            ("F2", 1), ("F2", 1), ("C3", 1), ("C3", 1), ("G2", 1), ("G2", 1), ("G2", 1), ("G2", 1),
            ("C3", 1), ("C3", 1), ("E3", 1), ("E3", 1), ("F2", 1), ("F2", 1), ("A2", 1), ("A2", 1),
            ("F2", 1), ("F2", 1), ("G2", 1), ("G2", 1), ("C3", 1), ("G2", 1), ("C3", 2)]
    drums = [("K", 1), ("H", 0.5), ("H", 0.5), ("S", 1), ("H", 0.5), ("H", 0.5)]
    m["a_title_music"] = render_track(112, [("square", 0.5, 0.35, lead), ("tri", 0.5, 0.55, bass), ("drum", 0, 0.35, drums)], 8)

    # --- Village: cheerful, bouncy (G major, 120 bpm) ---
    lead = [("B4", 0.5), ("D5", 0.5), ("G5", 1), ("F#5", 0.5), ("E5", 0.5), ("D5", 1),
            ("E5", 0.5), ("D5", 0.5), ("B4", 0.5), ("A4", 0.5), ("G4", 2),
            ("A4", 0.5), ("B4", 0.5), ("C5", 1), ("E5", 0.5), ("D5", 0.5), ("C5", 1),
            ("B4", 0.5), ("C5", 0.5), ("A4", 1), ("D5", 2),
            ("B4", 0.5), ("D5", 0.5), ("G5", 1), ("F#5", 0.5), ("E5", 0.5), ("D5", 1),
            ("E5", 0.5), ("G5", 0.5), ("F#5", 0.5), ("E5", 0.5), ("D5", 2),
            ("C5", 0.5), ("E5", 0.5), ("D5", 0.5), ("C5", 0.5), ("B4", 1), ("A4", 1),
            ("G4", 3), (None, 1)]
    bass = [("G2", 0.5), ("D3", 0.5)] * 4 + [("C3", 0.5), ("G3", 0.5)] * 2 + [("G2", 0.5), ("D3", 0.5)] * 2 + \
           [("A2", 0.5), ("E3", 0.5)] * 2 + [("C3", 0.5), ("G3", 0.5)] * 2 + [("D3", 0.5), ("A3", 0.5)] * 4 + \
           [("G2", 0.5), ("D3", 0.5)] * 2 + [("E2", 0.5), ("B2", 0.5)] * 2 + [("C3", 0.5), ("G3", 0.5)] * 2 + [("D3", 0.5), ("A3", 0.5)] * 2 + \
           [("C3", 0.5), ("G3", 0.5)] * 2 + [("D3", 0.5), ("A3", 0.5)] * 2 + [("G2", 0.5), ("D3", 0.5)] * 4
    drums = [("K", 1), ("H", 1), ("S", 1), ("H", 1)]
    m["a_village_music"] = render_track(120, [("square", 0.25, 0.32, lead), ("tri", 0.5, 0.55, bass), ("drum", 0, 0.25, drums)], 8)

    # --- Home: gentle (F major, 92 bpm) ---
    lead = [("A4", 1), ("C5", 1), ("F5", 2), ("E5", 1), ("D5", 1), ("C5", 2),
            ("Bb4", 1), ("D5", 1), ("C5", 1), ("A4", 1), ("G4", 4),
            ("A4", 1), ("C5", 1), ("F5", 2), ("G5", 1), ("A5", 1), ("G5", 2),
            ("F5", 1), ("E5", 1), ("G5", 1), ("E5", 1), ("F5", 4)]
    bass = [("F2", 2), ("C3", 2), ("C3", 2), ("A2", 2), ("Bb2", 2), ("G2", 2), ("C3", 2), ("C3", 2),
            ("F2", 2), ("A2", 2), ("Bb2", 2), ("C3", 2), ("Bb2", 2), ("C3", 2), ("F2", 4)]
    m["a_home_music"] = render_track(92, [("tri", 0.5, 0.5, lead), ("square", 0.125, 0.12, lead), ("tri", 0.5, 0.45, bass)], 8)

    # --- Old Forest: tense, minor (A minor, 100 bpm) ---
    lead = [("A4", 1.5), ("B4", 0.5), ("C5", 1), ("E5", 1), ("D5", 1.5), ("C5", 0.5), ("B4", 2),
            ("C5", 1.5), ("B4", 0.5), ("A4", 1), ("G#4", 1), ("A4", 3), (None, 1),
            ("E5", 1.5), ("F5", 0.5), ("E5", 1), ("C5", 1), ("D5", 1.5), ("E5", 0.5), ("B4", 2),
            ("C5", 1), ("B4", 1), ("A4", 1), ("G#4", 1), ("A4", 3), (None, 1)]
    bass = [("A2", 0.5), ("A2", 0.5), ("E3", 0.5), ("A2", 0.5)] * 2 + [("G2", 0.5), ("G2", 0.5), ("D3", 0.5), ("G2", 0.5)] * 2 + \
           [("F2", 0.5), ("F2", 0.5), ("C3", 0.5), ("F2", 0.5)] * 2 + [("E2", 0.5), ("E2", 0.5), ("B2", 0.5), ("E2", 0.5)] * 2
    drums = [("K", 1), ("H", 0.5), ("H", 0.5), ("K", 0.5), ("K", 0.5), ("S", 1)]
    m["a_forest_music"] = render_track(100, [("square", 0.5, 0.28, lead), ("tri", 0.5, 0.6, bass), ("drum", 0, 0.28, drums)], 8)

    # --- Southern desert: exotic (D phrygian-ish, 104 bpm) ---
    lead = [("D5", 1), ("Eb5", 0.5), ("F#5", 0.5), ("G5", 1), ("F#5", 1), ("Eb5", 1), ("D5", 3),
            ("C5", 1), ("D5", 0.5), ("Eb5", 0.5), ("D5", 1), ("C5", 1), ("Bb4", 1), ("A4", 3),
            ("D5", 1), ("Eb5", 0.5), ("F#5", 0.5), ("A5", 1), ("G5", 1), ("F#5", 1), ("G5", 0.5), ("F#5", 0.5), ("Eb5", 2),
            ("D5", 1), ("C5", 1), ("Eb5", 1), ("C#5", 1), ("D5", 4)]
    bass = [("D3", 1), ("A2", 0.5), ("D3", 0.5)] * 6 + [("C3", 1), ("G2", 0.5), ("C3", 0.5)] * 2 + [("D3", 1), ("A2", 0.5), ("D3", 0.5)] * 8
    drums = [("K", 1), ("H", 0.5), ("K", 0.5), ("S", 1), ("H", 0.5), ("H", 0.5)]
    m["a_desert_music"] = render_track(104, [("square", 0.25, 0.3, lead), ("tri", 0.5, 0.6, bass), ("drum", 0, 0.3, drums)], 8)
    return m


def sound_yy(name, duration):
    return {
        "$GMSound": "v2", "%Name": name,
        "audioGroupId": {"name": "audiogroup_default", "path": "audiogroups/audiogroup_default"},
        "bitDepth": 1, "channelFormat": 0, "compression": 0, "compressionQuality": 6, "conversionMode": 0,
        "duration": round(duration, 3), "exportDir": "", "name": name,
        "parent": folder("Sounds/Music" if name.endswith("_music") else "Sounds/Effects"),
        "preload": not name.endswith("_music"), "resourceType": "GMSound", "resourceVersion": "2.0",
        "sampleRate": SR, "soundFile": f"{name}.wav", "volume": 0.6 if name.endswith("_music") else 0.8,
    }


def build(preview_dir=None):
    np.random.seed(40)
    allsounds = {**sfx(), **music()}
    for name, sig in allsounds.items():
        d = f"{OUT}/sounds/{name}"
        os.makedirs(d, exist_ok=True)
        dur = save_wav(f"{d}/{name}.wav", sig, peak=0.7 if name.endswith("_music") else 0.8)
        write(f"sounds/{name}/{name}.yy", sound_yy(name, dur))
        if preview_dir:
            save_wav(f"{preview_dir}/{name}.wav", sig, 0.7)
    return list(allsounds)
