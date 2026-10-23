/// @description Take damage, but it's too heavy to be knocked far
event_inherited();
speed_ = min(speed_, 1.5);
starting_state_ = boss.chase;		// after a hit it goes back to chasing
