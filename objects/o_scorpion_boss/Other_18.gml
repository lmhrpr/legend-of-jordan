/// @description scorp.exposed: tail stuck in the sand after the strike (a good time to hit it)
sprite_index = s_scorpion_boss_strike;
image_speed = 0;
speed_ = 0;
if (alarm[1] <= 0)
{
	state_ = scorp.burrow;
}
