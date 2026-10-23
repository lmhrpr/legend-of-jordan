/// @description Initialise bat
// Bats flutter about slowly. When Jordan comes near they hover in front of him,
// then every so often wind up (shaking and flashing red) and swoop at him.
// The wind-up and the pause afterwards are Jordan's chance to strike first.

// Inherit the parent event
event_inherited();
initialise_movement_entity(0.25, 0.5, o_solid);

enum bat
{
	locked,		// 0: shared with enemy.locked
	wander,		// 1: shared with enemy.hit, so being hit knocks the bat back here
	hover,
	windup,
	swoop,
	recover
}

max_health_ = 2;
health_ = max_health_;

starting_state_ = bat.wander;
state_ = starting_state_;

// Tuning
wander_speed_ = 0.35;		// pottering about
hover_speed_ = 0.6;			// keeping station in front of Jordan
swoop_speed_ = 2.4;			// the attack (Jordan runs at 1.5)
notice_range_ = 72;			// starts hovering when Jordan is this close
give_up_range_ = 120;		// goes back to wandering past this
hover_distance_ = 36;		// how far in front of Jordan it hovers

state_timer_ = 0;
wander_timer_ = 0;
swoop_direction_ = 0;

mask_index = s_bat;
image_index = 0;
image_xscale = choose(-1, 1);
image_speed = 0.4;
