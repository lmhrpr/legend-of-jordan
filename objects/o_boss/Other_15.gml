/// @description boss.intro: wait a moment once Jordan is in the arena, then come for him
image_speed = 0.1;
speed_ = 0;
intro_time_ -= 1;
if (intro_time_ <= 0)
{
	state_ = boss.chase;
	alarm[1] = global.one_second * 1.5;
}
