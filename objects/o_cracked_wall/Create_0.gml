/// @description A cracked wall over a dungeon doorway: a bomb blows it open
// Set in the instance creation code:
//   flag_ = "d2_crack_entrance";   remembers it's been blown open (both sides of a doorway share it)
//   dir_ = 90;                     the way through it (as for o_dungeon_door), to turn the cracks
flag_ = "";
dir_ = 90;
initialise_hurtbox_entity();
name = "";
text[0] = "";
voice = a_text;
speaker = id;
depth = -(y - 8);		// over the doorway arch
