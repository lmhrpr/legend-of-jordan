/// @description porcupine.idle

// Knockback after being hit (enemy.hit)
event_inherited();
sprite_index = s_porcupine_run;

image_index = 0;
image_speed = 0;

// If Move alarm has gone off
if (alarm[1] <= 0)
{
	// Reset Move alarm
	alarm[1] = random_range(2, 4) * global.one_second;
	// Enter move state
	state_ = porcupine.move;
	direction_ = random(360);
}

porcupine_attack();