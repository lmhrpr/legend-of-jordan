/// @description scorp.emerge: out of the sand, turning on Jordan
sprite_index = s_scorpion_boss_emerge;
image_speed = 0;
if (alarm[1] <= 0)
{
	state_ = scorp.windup;
	sprite_index = s_scorpion_boss_windup;
	scorp_face_player();
	alarm[1] = global.one_second * ((health_ <= max_health_ / 2) ? 0.45 : 0.6);		// the warning
}
