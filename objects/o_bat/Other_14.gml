/// @description bat.swoop

image_speed = 0.6;
var _speed_before = speed_;
move_movement_entity(true);

// Hit Jordan?
if (instance_exists(o_player) and point_distance(x, y, o_player.x, o_player.y) < 12)
{
	create_hitbox(s_porcupine_hitbox, x, y, 0, 1, [o_player], 1, 4);
	state_ = bat.recover;
	state_timer_ = round(global.one_second * 0.8);
	set_movement(swoop_direction_ + 180, 0.8);
	exit;
}

// Ran out of puff, or hit a tree
state_timer_ -= 1;
if (state_timer_ <= 0 or speed_ < _speed_before * 0.9)
{
	state_ = bat.recover;
	state_timer_ = round(global.one_second * 0.8);
	set_movement(swoop_direction_ + 180, 0.6);
}
