/// @description player.wake

// If current frame is the final frame in the sprite
if image_index > image_number - 1 
{
	// Stop animating
	image_speed = 0;
	
	state_ = player.move;
	starting_state_ = player.move;	
	image_index = 0;
}