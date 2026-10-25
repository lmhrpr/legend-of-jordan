/// @description A switch in the floor: step on it to set flag_
// Set in the instance creation code:  flag_ = "d1_switch";
flag_ = "";
image_speed = 0;
depth = 50;		// under everything standing on it
lines_ = ["Click!", "Somewhere in the ruins, a gate rumbles open."];	// what it says when pressed
if (floor_is_sand(x, y)) sprite_index = s_floor_switch_sand;	// sandstone, on sandy floors
