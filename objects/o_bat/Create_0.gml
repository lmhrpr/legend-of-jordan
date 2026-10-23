// Inherit the parent event
event_inherited();
initialise_movement_entity(0.25, 0.5, o_solid);

enum bat 
{
	hit,
	move,
	attack
}

max_health_ = 2;
health_ = max_health_;

starting_state_ = bat.move;
state_ = starting_state_;

range_ = 36;

image_index = 0;
image_xscale = choose(-1, 1);
image_speed = 0.5;
mask_index = s_bat;