/// @description scorp.strike: the tail lashes forward
sprite_index = s_scorpion_boss_strike;
image_speed = 0;
if (alarm[1] <= 0)
{
	state_ = scorp.exposed;
	alarm[1] = global.one_second * ((health_ <= max_health_ / 2) ? 1.1 : 1.5);
}
