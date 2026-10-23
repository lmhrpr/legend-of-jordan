/// @description bat.windup: shake and flash red, then swoop

speed_ = 0;
image_speed = 1;		// frantic flapping

state_timer_ -= 1;
if (state_timer_ <= 0)
{
	if (!instance_exists(o_player) or !o_player.visible)
	{
		state_ = bat.wander;
		exit;
	}
	// Aim where Jordan is now: he can still sidestep
	swoop_direction_ = point_direction(x, y, o_player.x, o_player.y);
	set_movement(swoop_direction_, swoop_speed_);
	state_ = bat.swoop;
	state_timer_ = round(global.one_second * 0.5);
	play_sfx(a_swipe, 4);
}
