/// @description scorp.intro: wait a moment once Jordan is in the arena, then dive
sprite_index = s_scorpion_boss_walk;
image_speed = 0.1;
speed_ = 0;
scorp_face_player();
intro_time_ -= 1;
if (intro_time_ <= 0)
{
	state_ = scorp.burrow;
}
