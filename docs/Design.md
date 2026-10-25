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

Room `r_canyon` (3 × 3 screens), Liam's layout. Reached by bombing the cracked rocks on the Desert's west side; the way in is on screen 6's east edge, the way out (to the next area) up the steps of the Gate plateau on screen 2. Built from the tileset's raised-ground pieces: plateaus with white rims and layered cliff faces, stairs cut into the cliffs, open edges to jump from. The caves are `r_canyon_caves`.

| Step | Where | What happens |
|---|---|---|
| 1 | Screens 6, 3 | Up onto the band, then the one-way jump north from its notch onto the mesa (cave 2, a Heart Container), and down its stairs to the floor north of the band. Cave 5's north end is here: its switch opens the tunnel back to screen 6. |
| 2 | Screens 2, 1, 4, 7, 8, 9 | At ground level, anticlockwise round the canyon to cave 6 in screen 9. This floor is sealed off from screens 5 and 6. |
| 3 | Screen 9 to 5 | Cave 6 runs north and west through three cave rooms and comes up through steps on top of the Tower. |
| 4 | Screens 5, 4, 1, 2 | Down from the Tower onto the long plateau, stairs up to the Ledge, the Ledge's notch north onto the Shelf, east to the Gate plateau, and out. |

Coming back from the north: drop off the Gate plateau's east edge, and home through cave 5. Other secrets: cave 1 (gems) behind cracked rocks in the Ledge's cliff, cave 3 (Liam's scratched map, "L.H.") behind a cracked rock in screen 7, cave 4 (a gem stash) behind a cracked patch of cliff in screen 6. Dungeon 3's entrance is still to place.

**Cave plans (agreed, to build).**

| Cave | Puzzle |
|---|---|
| 1 (gems, under the Ledge) | Spike rhythm: a corridor of spikes on their timer; wait in the gaps, dash between. A heart on a side ledge. |
| 2 (Heart Container, on the mesa) | A room of pits with the Heart Container on an island: jump tile to tile with the boots; the island opens when both floor switches (one each end) have been pressed. |
| 3 (Liam's map, screen 7) | Looks empty: a line of gems points to a cracked wall; bomb it for the alcove with the map. |
| 4 (gem stash, screen 6) | Treasure vault: the gems are behind blocks that sink when a switch is pressed, on the far side of a block maze, with bats. |
| 5 (the switch tunnel) | As it is: it only opens from the north side. |
| 6 (the long tunnel) | A mini-dungeon (the canyon has no dungeon): room 1, the crevice to jump with the boots; room 2, a switch that sinks one row of blocks and raises another (only one way through), or spikes and a pit; room 3, the **giant scorpion** (`o_scorpion_boss`), before the steps up to the Tower. |

**Giant scorpion (cave 6 boss).** Built. It dives under the sand and tunnels as a mound to the spot behind Jordan (opposite the way he's facing), bursts out (half a heart if he's on it), turns, cocks its tail (shakes: the warning), stings in front of its claws (1 heart), then sits with its tail stuck for 1.5s: the moment to hit it. It can't be hurt under the sand; a hit sends it back under. 6 hits; at half health it tunnels faster and recovers quicker. Touching it above the sand costs half a heart. Beating it sets `canyon_boss`, drops a heart container, and removes the block in front of the steps up to the Tower.

New mechanics: **pushable blocks**, only once Jordan has a later item (so some caves are worth coming back to), and **switches that only hold while something stands on them** (push a block onto one to keep a door open). Spikes and floor switches on sandy floors use sandstone versions (tiles 490/491 for sand spikes; switches pick theirs automatically).

**Jumping (the Winged Boots).** Jordan can jump over a pit (`o_gap`) right in front of him, landing just past it. On raised ground he can only jump from an open edge of a plateau, where there's no stone parapet (tiles 478, 479, 480 and 172, facing out of the edge), and only to somewhere the same height or lower, landing inside its rim (up to 4½ tiles away). A plateau's height is the rows of cliff below it, rim included (0 is the canyon floor); a plateau whose cliff comes down behind another one is on the floor behind it. If there's nowhere to land, the boots do nothing: no falls, no lost hearts. Cave 5's blocks only sink once the switch on its north side is pressed (flag `canyon_tunnel`).

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

Liam's notes. Art for all of these is in `art/enemies/` (one strip of frames each; `_all.png` shows them together), drawn by `_tools/enemy_art/` (run `sheet.py` to redraw). It isn't in the GameMaker project yet.

**Changes to every enemy:** replace the code that sends enemies shooting across the screen when they're hit (a short knock-back instead).

| Enemy | Where | How it behaves | Hurt by |
|---|---|---|---|
| Bat (redo) | Anywhere | Flies about in a random pattern, then lands for a second. Doesn't target or swoop at Jordan: it only hurts if it flies into him. | Sword, bombs |
| Armadillo | Desert, canyon | Walks about. If Jordan is in range and lined up with it (same row or column), it rolls up and rolls straight at him, horizontally or vertically. | Sword and bombs, but not while rolled up |
| Snake | Desert, forest | Slithers about; coils up and waits, tongue flicking. If Jordan comes close, it pauses, then strikes. | Sword, bombs |
| Dust devil | Desert, canyon | Moves erratically; doesn't target Jordan. Hurts if it touches him. | Bombs only |
| Skeleton warrior | Dungeons | Variations: no weapon; with a sword; with a throwing spear; with a shield that blocks hits from the front, plus a sword or a spear. | Sword, bombs (shield: from behind or the sides) |
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
