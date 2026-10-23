/// @description porcupine.attack

// Animate
image_speed = 0.35;

// On the 4th animation frame
if (animation_hit_frame(1))
{
	var _life = 1;
	var _damage = 1;
	var _knockback = 4;
	
	create_hitbox(s_porcupine_hitbox, x, y - 8, 0, _life, [o_player], _damage, _knockback);
	play_sfx(a_porcupine_attack, 5);
}

// When the attack animation finishes
if (animation_hit_frame(image_number - 1))
{
	// Return to idle state
	state_ = porcupine.idle;
	sprite_index = s_porcupine_run;
	// Reset Move alarm
	alarm[1] = 2 * global.one_second;
}