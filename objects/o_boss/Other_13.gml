/// @description boss.windup: shake, then charge at where Jordan is
image_speed = 0;
if (alarm[1] <= 0)
{
	state_ = boss.charge;
	if (instance_exists(o_player)) direction_ = point_direction(x, y, o_player.x, o_player.y);
	speed_ = 2;
	alarm[1] = global.one_second * 1.2;
	play_sfx(a_porcupine_attack, 7);
}
