/// @description player.evade: a jump with the Winged Boots, from an open plateau edge
// (inventory_use_item only lets him start one when jump_landing() finds somewhere to land)

// Take off
if (jump_t_ == 0)
{
	var _landing = jump_landing(facing_direction_ * 90);
	if (is_undefined(_landing))
	{
		state_ = player.move;
		exit;
	}
	jump_from_x_ = x;
	jump_from_y_ = y;
	jump_to_x_ = _landing.x;
	jump_to_y_ = _landing.y;
	play_sfx(a_swipe, 5);
}

image_speed = 0;
image_index = 1;
jump_t_ += 1;
var _t = jump_t_ / jump_time_;
jump_z_ = -sin(_t * pi) * jump_height_;
x = lerp(jump_from_x_, jump_to_x_, _t);
y = lerp(jump_from_y_, jump_to_y_, _t);
speed_ = 0;

// Land
if (jump_t_ >= jump_time_)
{
	jump_t_ = 0;
	jump_z_ = 0;
	x = jump_to_x_;
	y = jump_to_y_;
	state_ = player.move;
}
