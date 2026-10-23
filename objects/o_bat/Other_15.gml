/// @description bat.recover: rest where the swoop ended, then fly back the way it came

image_speed = 0.25;

if (state_timer_ > 0)
{
	// Resting: sits still (a good moment to hit it)
	state_timer_ -= 1;
	speed_ = 0;
	exit;
}

// Fly back to where the swoop started
var _distance = point_distance(x, y, return_x_, return_y_);
if (_distance > hover_speed_ * 2)
{
	set_movement(point_direction(x, y, return_x_, return_y_), min(hover_speed_ * 1.5, _distance));
	move_movement_entity(true);
	if (speed_ > 0.05) exit;		// still on its way (unless something's in the way)
}

speed_ = 0;
state_ = bat.hover;
state_timer_ = global.one_second * random_range(hover_time_min_, hover_time_max_);
