/// @description Set the depth

// Already cut down on an earlier visit? Then it stays gone (no drop).
bush_key_ = room_get_name(room) + ":" + string(xstart) + ":" + string(ystart);
if (variable_struct_exists(global.cut_bushes, bush_key_))
{
	instance_destroy(id, false);
	exit;
}

depth = -y;
health_ = 2;
initialise_hurtbox_entity();

// Hidden treasure: set in the instance creation code, e.g.
//   hidden_item_ = o_gem_pickup;  hidden_count_ = 3;
hidden_item_ = noone;
hidden_count_ = 1;
