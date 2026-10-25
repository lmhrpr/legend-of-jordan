/// @description A heavy block Jordan can push one tile at a time, once he has the Gloves
// Without them it won't budge (he gets told so once).
event_inherited();
push_t_ = 0;			// how long Jordan has been pushing
moving_ = 0;			// frames of sliding left
move_dx_ = 0;
move_dy_ = 0;
told_ = false;			// "too heavy" message shown
