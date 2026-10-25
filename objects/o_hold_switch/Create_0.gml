/// @description A plate that only stays down while something stands on it (Jordan or a push block)
// Set in the instance creation code:  link_ = "a";   (the o_hold_gate blocks with the same link_ answer to it)
link_ = "a";
pressed_ = false;
image_speed = 0;
image_index = 0;
depth = 50;		// under everything standing on it
if (floor_is_sand(x, y)) sprite_index = s_hold_switch_sand;
