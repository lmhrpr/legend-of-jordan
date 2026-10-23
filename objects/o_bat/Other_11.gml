/// @description bat.wander

// Still flying backwards from a hit?
if (speed_ > wander_speed_ + 0.1)
{
	move_movement_entity(true);
	apply_friction_to_movement_entity();
	exit;
}

image_speed = 0.4;

wander_timer_ -= 1;
if (wander_timer_ <= 0)
{
	wander_timer_ = global.one_second * random_range(1, 2);
	direction_ = random(360);
}
add_movement_maxspeed(direction_, 0.03, wander_speed_);
move_movement_entity(true);
set_sprite_facing();

// Notice Jordan
if (instance_exists(o_player) and o_player.visible and distance_to_object(o_player) < notice_range_)
{
	state_ = bat.hover;
	state_timer_ = global.one_second * random_range(1, 1.8);
}
