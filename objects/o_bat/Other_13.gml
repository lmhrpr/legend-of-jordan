/// @description bat.windup: shake and flash red, then swoop at the spot it locked on to

speed_ = 0;
image_speed = 1;		// frantic flapping

state_timer_ -= 1;
if (state_timer_ <= 0)
{
	swoop_direction_ = point_direction(x, y, target_x_, target_y_);
	state_ = bat.swoop;
	play_sfx(a_swipe, 4);
}
