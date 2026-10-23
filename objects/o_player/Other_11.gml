/// @description player.sword

image_speed = 0.8;

// On the 2nd animation frame
if (animation_hit_frame(1))
{
	var _angle = facing_direction_ * 90;
	var _life = 3;
	var _damage = 1;
	var _knockback = 8;
	
	// A simple box reaching 24px out in front of Jordan's middle (turned to face his way),
	// so it covers the whole swipe you see
	var _hitbox = create_hitbox(s_sword_reach, x, y - 8, _angle, _life, [o_enemy, o_grass, o_bush], _damage, _knockback);
	play_sfx(a_swipe, 8);
}

// When the attack animation finishes
if (animation_hit_frame(image_number - 1))
{
	// Return to move state
	state_ = player.move;
}