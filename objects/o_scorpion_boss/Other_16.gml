/// @description scorp.windup: tail cocked and shaking, then strike
sprite_index = s_scorpion_boss_windup;
image_speed = 0;
if (alarm[1] <= 0)
{
	state_ = scorp.strike;
	sprite_index = s_scorpion_boss_strike;
	// The sting lands just in front of its claws
	create_hitbox(s_scorpion_boss_sting, x + facing_ * 26, y - 8, 0, 8, [o_player], 1, 5);
	play_sfx(a_porcupine_attack, 7);
	alarm[1] = global.one_second * 0.3;
}
