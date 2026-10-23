/// @description porcupine.move
//event_inherited();

// Animate
image_speed = 0.35;

// Face direction of movement
set_sprite_facing();

// If Idle alarm has gone off
if (alarm[1] <= 0)
{
	// Slow down
	apply_friction_to_movement_entity();
}
else
{
	// Speed up
	add_movement_maxspeed(direction_, 0.05, 0.25);
}

// Move
move_movement_entity(true);

if (speed_ == 0)
{
	// Reset Move alarm
	alarm[1] = random_range(1, 3) * global.one_second;
	// Enter idle state
	state_ = porcupine.idle;
}

porcupine_attack();