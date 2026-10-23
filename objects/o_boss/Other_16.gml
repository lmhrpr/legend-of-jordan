/// @description boss.dizzy: worn out after a charge (a good time to hit it)
image_speed = 0;
speed_ = 0;
if (alarm[1] <= 0)
{
	state_ = boss.chase;
	alarm[1] = random_range(2.5, 3.5) * global.one_second;
}
