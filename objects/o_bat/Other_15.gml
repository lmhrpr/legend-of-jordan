/// @description bat.recover: drift back, catching its breath (a good moment to hit it)

image_speed = 0.25;
speed_ = approach(speed_, 0.2, 0.02);
move_movement_entity(true);

state_timer_ -= 1;
if (state_timer_ <= 0)
{
	state_ = bat.hover;
	state_timer_ = global.one_second * random_range(1.2, 2.2);
}
