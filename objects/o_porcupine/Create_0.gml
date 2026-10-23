/// @description Initialise porcupine

// Inherit the parent event
event_inherited();
initialise_movement_entity(0.4, 0.5, [o_solid, o_gap]);

// idle uses the same user event number as enemy.hit, so knockback still works
enum porcupine
{
	locked,
	idle,
	move,
	attack
}

max_health_ = 3;
health_ = max_health_;

starting_state_ = porcupine.idle;
state_ = starting_state_;

range_ = 28;

mask_index = s_porcupine_run;
sprite_index = s_porcupine_run;
image_xscale = choose(-1, 1);
image_index = 0;

alarm[1] = random_range(1, 3) * global.one_second;
