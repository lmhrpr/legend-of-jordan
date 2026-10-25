/// @description A block that sinks into the floor while its hold switch is down
// Set in the instance creation code:
//   link_ = "a";        (the o_hold_switch with the same link_)
//   invert_ = true;     (optional: up while the switch is down, sunk while it's up)
event_inherited();
link_ = "a";
invert_ = false;
open_ = false;
image_speed = 0;
