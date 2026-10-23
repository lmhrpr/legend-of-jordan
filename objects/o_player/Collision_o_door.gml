/// @description Go to next room

if (instance_exists(o_transition)) exit;
if (other.room_ == noone) exit;

global.player_start_position = other.start_;
persistent = true;
room_transition(other.type_, other.room_, 0.02, 0);