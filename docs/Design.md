# The Legend of Jordan — Design

*A Golden Axe Warrior–style adventure made for Jordan's 40th. Kid Jordan follows his little brother Liam's trail through a world of hidden forest folk and old ruins, and only at the very end discovers what Liam was doing: making this game.*

---

## 1. The story

### The setup
Liam has gone to deliver a letter for Dad and hasn't come home. Mum sends Jordan to find him. The trail leads from Granny & Granda's to Dad's Post Office, then to the Old Forest, and Jordan needs the Magic Sword from the Southern Desert to get through.

### The twists
1. **Dad's secret post round** *(revealed by the Keeper in the Old Forest)*. Dad's Post Office has always secretly delivered mail to the hidden folk of the forest and beyond. Liam was due at the Keeper's with a whole bag of letters, but never arrived. The Keeper suggests the old ruins: Liam was always asking about them.
2. **Liam is going in on purpose** *(clear by dungeon 2–3)*. Jordan starts out rescuing him, but the evidence says Liam is going deeper by choice. Jordan can't work out why.
3. **Liam is making a game** *(revealed at the end)*. Liam has been gathering knowledge of the dungeons, monsters and world to put into a game for Jordan: *The Legend of Jordan*.

### The reveal, step by step

| Point in game | What Jordan learns | What Jordan thinks |
|---|---|---|
| The Keeper (Old Forest) | The letter was for the Keeper. Dad's Post Office secretly serves the forest folk. Liam was expected but never arrived; the Keeper thinks he's gone into the ruins he was always asking about. | He's lost in the ruins. |
| Dungeon 1 (Old Forest) | Liam's post bag, left in the ruins. Half the letters are gone. Delivered? Down here? | He's in there, but something's odd. |
| Dungeon 2 | "Your brother? He asked what I was called and drew me in a little notebook. Then he asked the way to the next ruin." | Why would he go *further in*? |
| Dungeon 3 | Liam's own map: the ruins numbered, three ticked off. | Baffled, and a bit cross. |
| Dungeons 4–7 | "He asked how hard my puzzles were and wrote it down." "He made me roar three times to get it right." "He asked where I'd hide my treasure." | Wrong guesses, each a chance for a joke: running away, a spy, a present for Mum. |
| Dungeon 8 | The craftsman: "The lad ordered a cartridge. Black, fits a Master System. Wanted a gold label." | Knows where Liam will be, but not why. |
| Finale | Liam hands over the cartridge: *The Legend of Jordan*. | Understands everything. |

### The ending
Cut to the present day, in Jordan's home in Baku. The doorbell rings: it's grown-up Liam. Jordan, Liam and Mavi sit round an old CRT telly with a Master System plugged in, playing *The Legend of Jordan*. The TV shows the LiamFilm Games splash and the title card, so the game ends on its own beginning.

### Present-day interludes
After each dungeon, a short scene in Baku: grown-up Jordan is telling the story to his daughter Mavi. Her questions ("Why did Uncle Liam keep going?") echo kid Jordan's confusion. Grown-up Jordan knows the ending and teases it ("I didn't understand. Not till the very end."). Each scene shows that dungeon's item as it is now.

---

## 2. The world (9 × 9 screens)

Nine regions of 3 × 3 screens, with the Village in the middle.

|   | A–C | D–F | G–I |
|---|---|---|---|
| **1–3** | Hills | **Old Forest** | Lake |
| **4–6** | Fields | **Village** *(built)* | Riverside |
| **7–9** | Canyon | **Southern Desert** *(sword screen built)* | Coast |

### The Village (Liam's plan)

| Screen | Contents | Exits |
|---|---|---|
| 1 | Woods & Lake | 2, 4 |
| 2 | Dark forest | 1, 3, **Old Forest** (north, behind bushes) |
| 3 | Dark forest, dead end with hidden treasure | 2 |
| 4 | Home (Mum) | 1, 5, 7 |
| 5 | **Flowery Meadow: Jordan wakes here** | 4 |
| 6 | Woods, dead end with a pond and treasure | 9 |
| 7 | Woods | 4, 8 |
| 8 | Granny & Granda's | 7, 9 |
| 9 | Post Office (Dad, save point) | 6, 8, **Southern Desert** (south) |

No enemies in the Village.

### The Old Forest (north of the Village)

| Screen | Contents | Exits |
|---|---|---|
| 1 | Dead end: gem stash under bushes | 4 |
| 2 | **The Keeper's glade**: Liam's letter, the Keeper, the sealed ruins (Dungeon 1) | 5 |
| 3 | Old-tree clearing, a heart | 6 |
| 4 | Winding trail | 1, 5 |
| 5 | Crossroads | 2, 4, 8 |
| 6 | Pond | 3, 9 |
| 7 | Dead end: hidden heart and gems | 8 |
| 8 | Entrance from the Village (screen 2) | 5, 7, 9, Village |
| 9 | Bats | 6, 8 |

Bats and porcupines everywhere except the Keeper's glade. Gloom deepens towards the north.

### The Southern Desert (south of the Village)

| Screen | Contents | Exits |
|---|---|---|
| 1 | Dead end: buried stash | 2 |
| 2 | Rocks and dead trees | 1, 3, 5 |
| 3 | Entrance from the Post Office (Village screen 9) | 2, 6, Village |
| 4 | Oasis | 5 |
| 5 | **The Magic Sword shrine** | 2, 4, 8 |
| 6 | Porcupine flats | 3, 9 |
| 7 | Dead end: treasure | 8 |
| 8 | **The sealed pyramid** (Dungeon 2, behind cracked rocks: bomb them) | 5, 7, 9 |
| 9 | Rocky maze | 6, 8 |

---

### The Canyon (west of the Southern Desert)

Room `r_canyon` (3 × 3 screens), reached by bombing the cracked rocks on the Desert's west side (the exit is on screen 4's west edge). Built from the tileset's raised-ground pieces: plateaus with white rims and layered cliff faces, stairs cut into the cliffs, and cracks (`o_gap`) to jump with the Winged Boots. High ground along the screen borders makes a maze; the gaps between screens are:

| Between | Way through |
|---|---|
| Desert → 6 | The way in (east edge) |
| 6 ↔ 5 | Open |
| 5 ↔ 2, 5 ↔ 8 | Open |
| 2 ↔ 3 | A crack to jump |
| 8 | A long crack splits it in two |
| 8 ↔ 7 ↔ 4 ↔ 1 | Open |

Secrets: a cave in screen 1 behind cracked rocks (gems and a heart), a cave in screen 3's high mesa (a Heart Container), a cave in screen 7 behind a cracked rock (Liam's scratched map: "L.H."), a gem guarded by a cracked rock on screen 2's mesa, and gems beyond cracks on the mesas in screens 4 and 6. The caves are `r_canyon_caves`. Dungeon 3's entrance is still to place.

**Jumping (the Winged Boots).** Jordan can jump over a pit (`o_gap`) right in front of him, landing just past it. On raised ground he can only jump from an open edge of a plateau, where there's no stone parapet (tiles 478, 479, 480 and 172, facing out of the edge), and only to somewhere the same height or lower, landing inside its rim. A plateau's height is the rows of cliff below it, rim included (0 is the canyon floor); a plateau whose cliff comes down behind another one is on the floor behind it. If there's nowhere to land, the boots do nothing: no falls, no lost hearts. So the jump north from the band in screen 3 (height 3) to the mesa (height 2) is one-way, and the way back is the tunnel (cave 5): its blocks only sink once the switch on its north side is pressed (flag `canyon_tunnel`).

**Test copy: `r_canyon_test`** (F1 menu: "Canyon (test copy)"). Liam's canyon with screens 3 and 6 kept and the rest rebuilt so the way out (north, from the plateau on screen 2) comes last:

| Step | Where | What happens |
|---|---|---|
| 1 | Screens 6 to 3 | Up onto the band, then the one-way jump north onto the mesa, down its stairs to the strip of floor north of the band (cave 5's north end is here: its switch opens the way back to screen 6). |
| 2 | Screens 2, 1, 4, 7, 8, 9 | At ground level, counter-clockwise: west along the strip and the foot of the Shelf, down the west edge, through the gap into screen 7, east along the bottom to screen 9. This part of the floor is sealed off from screens 5 and 6 (rocks in the passage under the Tower; no gap in the wall above screens 8 and 9). |
| 3 | Screen 9 to 5 | Cave 6, in the cliff of the plateau in screen 9, runs north and west (Liam's cave rooms) and comes up through steps on top of the Tower (height 4). |
| 4 | Screens 5, 4, 1, 2 | Step down: Tower west to the Ledge (3), north from the Ledge's notch over the path to the Shelf (2), east to the Gate plateau (2), and out. |

Coming back from the north: jump west from the Gate plateau to the Shelf, then drop off the Shelf's west end to the floor of screen 1 (one way). Cave 1 is in the Ledge's cliff, behind the cracked rocks. Caves 1 to 5 in the copy lead back to the real `r_canyon`.

## 3. Dungeons and progression

Each outer region hides a ruin holding **one of Liam's undelivered letters** (the Golden Axe Warrior "crystals"). Delivering all eight opens the way to Liam.

| # | Dungeon | To get in, you need | Reward item | What it unlocks | Boss |
|---|---|---|---|---|---|
| — | Desert shrine *(done)* | — | Magic Sword | Cut the bushes into the Old Forest | — |
| 1 | Old Forest ruins | The Keeper throws a bomb at the slab | Bombs | Blow open cracked rocks and old trees | *TBD* (stand-in: a giant charging porcupine) |
| 2 | Southern Desert pyramid *(built)* | Bombs (blow open the sealed entrance) | Winged Boots | Jump over small gaps | *TBD* (stand-in: a sand-coloured giant porcupine) |
| 3 | Canyon (west of the Desert, through the cracked rocks) | Bombs to get in; Winged Boots to cross its gaps | Lantern? | Light dark caves | *TBD* |
| 4 | Hills | Lantern | Catapult | Hit far-off switches and flying enemies | *TBD* |
| 5 | Riverside | Catapult | Wellies | Wade through shallow water | *TBD* |
| 6 | Lake | Wellies | Raft | Cross deep water | *TBD* |
| 7 | Coast | Raft | Gloves | Lift and throw boulders | *TBD* |
| 8 | Fields | Gloves | Last letter | — | *TBD* |
| 9 | Where Liam is | All 8 letters | **The cartridge** | The ending | *TBD* |

### Dungeon 1: the Old Forest ruins (built)

A 4 × 3 grid of one-screen rooms joined like a maze (room `r_dungeon1`):

|   | Col 0 | Col 1 | Col 2 | Col 3 |
|---|---|---|---|---|
| **Row 0** | — | **Boss arena** (bars drop behind you) | Key room | Treasure (gems, heart) |
| **Row 1** | Switch room | Liam's post bag; **locked door** north | East hall (zig-zag) | — |
| **Row 2** | Bat room | **Entrance** (barred door north; steps out south) | Side room (heart) | — |

The route: Entrance → Bat room → Switch room (the switch lifts the Entrance bars) → post-bag corridor → East hall → Key room (beat everyone and a key drops) → back to the locked door → Boss → Heart Container, then a chest with Bombs appears.

Building blocks for later dungeons: `o_locked_door` (uses a key), `o_barred_door` (opens on a flag; or shuts you in until a flag), `o_floor_switch` (sets a flag), `o_key_spawner` (drops a key when a screen is cleared), `o_chest`, `o_heart_container`. Flags and keys are saved.

### Dungeon 2: the desert pyramid (built)

Room `r_dungeon2`. The pyramid is sealed by a cracked stone slab (`o_dungeon_entrance`): a bomb blows it open, then Jordan walks down the steps. Every dungeon from here on is opened the same way. Coming back out, Jordan appears just below the entrance.

|   | Col 0 | Col 1 | Col 2 | Col 3 |
|---|---|---|---|---|
| **Row 0** | — | **Boss arena** (bars drop behind you) | Key room | — |
| **Row 1** | Switch room | Centre hall; **locked door** north | East hall | Treasure (behind a secret **cracked wall**) |
| **Row 2** | West room | **Entrance** (cracked wall north; steps out south) | East room (barred door north) | — |

The route: bomb the entrance's cracked north wall → centre hall (locked door) → west room → switch room (lifts the east room's bars) → east room → east hall (a cracked wall east hides the treasure) → key room → back to the locked door → boss → Heart Container, then a chest with the Winged Boots.

### Character progression

| Upgrade | Source |
|---|---|
| +1 heart | Every boss |
| Stamina ("magic pots") | Secrets and the shop; items cost stamina |
| Sword upgrades | Dungeons 4 and 7 |
| Armour | Post Office shop, late game |
| Gems | Grass, bushes, enemies, hidden treasure |

---

## 3b. Enemies (to build)

Liam's notes. First-pass art for all of these is in `art/enemies/` (one strip of frames each; `_all.png` shows them together). It isn't in the GameMaker project yet.

**Changes to every enemy:** replace the code that sends enemies shooting across the screen when they're hit (a short knock-back instead).

| Enemy | Where | How it behaves | Hurt by |
|---|---|---|---|
| Bat (redo) | Anywhere | Flies about in a random pattern, then lands for a second. Doesn't target or swoop at Jordan: it only hurts if it flies into him. | Sword, bombs |
| Armadillo | Desert, canyon | Walks about. If Jordan is in range and lined up with it (same row or column), it rolls up and rolls straight at him, horizontally or vertically. | Sword and bombs, but not while rolled up |
| Snake | Desert, forest | Waits, tongue flicking. If Jordan comes close, it pauses, then strikes. | Sword, bombs |
| Dust devil | Desert, canyon | Moves erratically; doesn't target Jordan. Hurts if it touches him. | Bombs only |
| Skeleton warrior | Dungeons | Variations: no weapon; with a sword; with a throwing spear; with a shield that blocks hits from the front. | Sword, bombs (shield: from behind or the sides) |
| Gelatinous blob | Dungeons, caves | Hops around slowly. Variations: green (slow); blue (faster hops); purple (splits in two when killed, once); red (splits twice). | Sword, bombs |
| Scorpion | Desert, canyon | Burrows under the sand (a moving mound), then pops up behind Jordan to attack. | Sword and bombs once it's up |

---

## 4. Art needed

| Art | Status |
|---|---|
| Regular enemies (~14 types) | First pass drawn for the armadillo, snake, dust devil, skeleton warriors, blobs and scorpion (`art/enemies/`); bat and porcupine as before |
| Bosses (8) | *TBD* |
| The Keeper | Stand-in |
| Kid Liam, grown-up Jordan, grown-up Liam, Mavi | To make |
| Baku flat with the Flame Towers through the window | To make |
| CRT TV, Master System, cartridge | To make |

---

## 5. Memories to fill in

| Dungeon | Memory / theme | Item's real-life version | Boss idea |
|---|---|---|---|
| 1 Old Forest | | | |
| 2 Southern Desert | | | |
| 3 Fields | | | |
| 4 Hills | | | |
| 5 Riverside | | | |
| 6 Lake | | | |
| 7 Coast | | | |
| 8 Canyon | | | |
| 9 Liam's hideout | | | |
