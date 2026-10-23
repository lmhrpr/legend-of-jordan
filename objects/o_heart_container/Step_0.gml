/// @description Already taken? (for heart containers placed in a room)
if (flag_get(flag_)) { instance_destroy(id, false); exit; }
event_inherited();
