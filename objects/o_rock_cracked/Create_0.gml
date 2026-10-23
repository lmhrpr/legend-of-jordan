/// @description A cracked rock: a bomb blows it apart (and it stays gone)
event_inherited();
initialise_hurtbox_entity();
key_ = "rock:" + room_get_name(room) + ":" + string(x) + ":" + string(y);
if (flag_get(key_)) instance_destroy(id, false);
