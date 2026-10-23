/// @description player.sword

image_speed = 0.8;

// On the 2nd animation frame
if (animation_hit_frame(1))
{
	var _angle = facing_direction_ * 90;
	var _life = 3;
	var _damage = 1;
	var _knockback = 8;
	
	var _hitbox = create_hitbox(s_sword_hitbox, x, y, _angle, _life, [o_enemy, o_grass, o_bush], _damage, _knockback);
	play_sfx(a_swipe, 8);
	
	switch (facing_direction_)
	{
		case dir.up: 
			_hitbox.y -= 4; 
			break;
		default:
			_hitbox.y -= 8;
			break;
	}
}

// When the attack animation finishes
if (animation_hit_frame(image_number - 1))
{
	// Return to move state
	state_ = player.move;
}