/// @description bat.swoop: fly to the locked-on spot, then stop

image_speed = 0.6;
var _remaining = point_distance(x, y, target_x_, target_y_);
set_movement(swoop_direction_, min(swoop_speed_, _remaining));
move_movement_entity(true);

// Hit Jordan on the way?
if (instance_exists(o_player) and point_distance(x, y, o_player.x, o_player.y) < 10)
{
	create_hitbox(s_porcupine_hitbox, x, y, 0, 1, [o_player], swoop_damage_, 3);
	state_ = bat.recover;
	state_timer_ = round(global.one_second * 1);
	set_movement(swoop_direction_ + 180, 0.4);
	exit;
}

// Reached the spot, or bumped into a tree
if (_remaining <= swoop_speed_ or speed_ < 0.1)
{
	state_ = bat.recover;
	state_timer_ = round(global.one_second * 1);
	set_movement(swoop_direction_ + 180, 0.3);
}
