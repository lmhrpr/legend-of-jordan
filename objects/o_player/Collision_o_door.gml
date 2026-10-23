/// @description Go to next room

if (instance_exists(o_transition)) exit;
if (other.room_ == noone) exit;

global.player_start_position = other.start_;
// A dungeon's way out names its stairs instead (Jordan comes out in front of them)
global.arrive_at_ = variable_instance_exists(other, "arrive_at_") ? other.arrive_at_ : "";
persistent = true;
room_transition(other.type_, other.room_, 0.02, 0);