/// @description bat.swoop: fly in a straight line to the locked-on spot, and stop dead there

image_speed = 0.6;
var _remaining = point_distance(x, y, target_x_, target_y_);
var _arrived = (_remaining <= swoop_speed_);

if (_arrived)
{
	// Land exactly on the spot (no overshoot)
	x = target_x_;
	y = target_y_;
	speed_ = 0;
}
else
{
	set_movement(swoop_direction_, swoop_speed_);
	move_movement_entity(false);
}

// Hit Jordan on the way?
var _hit = instance_exists(o_player) and point_distance(x, y, o_player.x, o_player.y) < 10;
if (_hit)
{
	create_hitbox(s_porcupine_hitbox, x, y, 0, 1, [o_player], swoop_damage_, 3);
}

// Arrived, hit Jordan, or bumped into a tree: stop and rest
if (_arrived or _hit or speed_ < 0.1)
{
	speed_ = 0;
	state_ = bat.recover;
	state_timer_ = round(global.one_second * rest_time_);
}
