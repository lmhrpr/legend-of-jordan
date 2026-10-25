/// @description scorp.burrow: sink into the sand
sprite_index = s_scorpion_boss_emerge;
image_speed = 0;
speed_ = 0;
if (burrow_t_ < 0) burrow_t_ = global.one_second * 0.4;
burrow_t_ -= 1;
if (burrow_t_ <= 0)
{
	burrow_t_ = -1;
	create_animation_effect(s_death_effect, x, y - 4, 0.5, false);
	state_ = scorp.tunnel;
	sprite_index = s_scorpion_boss_mound;
	alarm[1] = global.one_second * 3;		// longest it stays under before coming up anyway
}
