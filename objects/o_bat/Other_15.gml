/// @description bat.recover: drift back, catching its breath (a good moment to hit it)

image_speed = 0.25;
speed_ = approach(speed_, 0, 0.01);
move_movement_entity(true);

state_timer_ -= 1;
if (state_timer_ <= 0)
{
	state_ = bat.hover;
	state_timer_ = global.one_second * random_range(hover_time_min_, hover_time_max_);
}
