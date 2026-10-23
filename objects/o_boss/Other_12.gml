/// @description boss.chase: lumber towards Jordan
image_speed = 0.3;
if (instance_exists(o_player))
{
	add_movement_maxspeed(point_direction(x, y, o_player.x, o_player.y), 0.03, 0.35);
}
move_movement_entity(false);

if (alarm[1] <= 0)
{
	state_ = boss.windup;
	speed_ = 0;
	alarm[1] = global.one_second * 1;		// a clear wind-up, so Jordan can get out of the way
}
