/// @description boss.charge: straight line, bouncing off walls
image_speed = 0.6;
move_movement_entity(true);
if (alarm[1] <= 0)
{
	apply_friction_to_movement_entity();
	if (speed_ < 0.1)
	{
		state_ = boss.dizzy;
		alarm[1] = global.one_second * 1.5;
	}
}
