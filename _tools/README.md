# Build tools

Python scripts used to rebuild and extend the project. GameMaker ignores this folder.

| Script | What it does |
|---|---|
| `regions.py` | Layout of the Village, Old Forest and Southern Desert |
| `world.py` | Tile constants, building pieces and the house interiors |
| `roomgen.py` | Writes GameMaker room files (tile layers, instances) and map previews |
| `check_reach.py` | Simulates Jordan's collision box to check every door, person, sign and item can be reached |
| `objects_table.py` | Sprite, parent and flags for every object |
| `sounds.py` | Synthesises the chiptune sound effects and music |
| `sprites.py`, `newsprites.py` | Sprite conversion and the small extra sprites |
| `build.py` | Runs everything |
| `dungeon_solids.py` | Rebuilds a room's invisible walls from its tiles (`python3 dungeon_solids.py r_canyon_caves`) |
| `pit_gaps.py` | Rebuilds the pits in one screen from its tiles, then the walls (`python3 pit_gaps.py r_canyon_caves 2 2 32`: room, screen column, screen row, jump reach in px) |

> **Rooms are now edited by hand in GameMaker.** Don't re-run `build.py` over the project: it would
> overwrite those edits. Changes are made directly in the project files and merged with git.
