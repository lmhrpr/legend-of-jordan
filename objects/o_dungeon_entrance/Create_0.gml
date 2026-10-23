/// @description A sealed stone slab over the steps into a dungeon: bomb it open, then walk in
// Place it where the entrance should be (it's 32x32, origin in the middle).
// Defaults go to Dungeon 2. For another dungeon, set in the instance creation code:
//   room_ = r_dungeon3;  start_ = i_dungeon3_in;  dungeon_ = "d3";  flag_ = "d3_open";
// Coming back out of the dungeon, Jordan appears just below it.
room_ = r_dungeon2;
start_ = i_dungeon2_in;
dungeon_ = "d2";
flag_ = "d2_open";
initialise_hurtbox_entity();
name = "";
text[0] = "";
voice = a_text;
speaker = id;
sprite_index = -1;			// drawn in the Draw event
mask_index = s_dungeon_entrance;
depth = -y;
