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
wander_speed_ = 0.25;		// pottering about
hover_speed_ = 0.3;			// drifting to its spot in front of Jordan
swoop_speed_ = 1.6;			// the attack (Jordan runs at 1.5)
swoop_damage_ = 0.5;		// half a heart
notice_range_ = 72;			// starts hovering when Jordan is this close
give_up_range_ = 120;		// goes back to wandering past this
hover_distance_ = 40;		// how far in front of Jordan it hovers
hover_slack_ = 14;			// only repositions when this far off its spot
windup_time_ = 0.6;			// seconds of warning before a swoop
hover_time_min_ = 1.8;		// seconds between swoops
hover_time_max_ = 3;

state_timer_ = 0;
wander_timer_ = 0;
swoop_direction_ = 0;
target_x_ = x;
target_y_ = y;
return_x_ = x;			// where the swoop started: the bat flies back here afterwards
return_y_ = y;
rest_time_ = 0.6;			// seconds it sits still after a swoop (a good moment to hit it)

mask_index = s_bat;
image_index = 0;
image_xscale = choose(-1, 1);
image_speed = 0.4;
