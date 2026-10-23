/// @description Steps down into a dungeon (walk onto them)
// Defaults go to Dungeon 2. For another dungeon, set in the instance creation code:
//   room_ = r_dungeon3;  start_ = i_dungeon3_in;  dungeon_ = "d3";
// Coming back out, Jordan appears just in front of the stairs whose dungeon_ matches.
event_inherited();
room_ = r_dungeon2;
start_ = i_dungeon2_in;
type_ = trans_type.iris;
dungeon_ = "d2";
depth = 50;		// on the ground, under Jordan
