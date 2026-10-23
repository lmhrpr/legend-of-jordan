/// @description player.evade: a jump (the Winged Boots), over small gaps

// Take off
if (jump_t_ == 0)
{
	jump_from_x_ = x;
	jump_from_y_ = y;
	collision_object_ = o_solid;		// gaps don't stop him in the air
	play_sfx(a_swipe, 5);
}

image_speed = 0;
image_index = 1;
jump_t_ += 1;
var _t = jump_t_ / jump_time_;
jump_z_ = -sin(_t * pi) * jump_height_;
set_movement(roll_direction_, jump_distance_ / jump_time_);
move_movement_entity(false);

// Land
if (jump_t_ >= jump_time_)
{
	jump_t_ = 0;
	jump_z_ = 0;
	speed_ = 0;
	collision_object_ = [o_solid, o_gap];
	state_ = player.move;

	// Came down in a gap: fall, lose half a heart, and climb back out where he jumped from
	if (position_meeting(x, y - 3, o_gap))
	{
		global.player_health -= 0.5;
		play_sfx(a_hurt, 6);
		x = jump_from_x_;
		y = jump_from_y_;
		invincible_ = true;
		alarm[0] = global.one_second;
	}
}
