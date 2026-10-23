/// @description Initialise transition
type_ = trans_type.slide;
target_ = room;
on_cover_ = undefined;	// if set, called when the screen is covered instead of changing room
speed_ = 0.02;
delay_ = 0;
progress_ = 0;
closing_ = true;
hold_ = 0;			// steps to stay black between rooms (set when the room changes)
surface_ = -1;		// used to cut the circle out of the black for the iris

if (instance_exists(o_player))
{
	o_player.state_ = player.locked;
	o_player.image_speed = 0;
	o_player.image_index = 0;
}
