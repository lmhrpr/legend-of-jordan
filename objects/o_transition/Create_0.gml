/// @description Initialise transition
type_ = trans_type.slide;
target_ = room;
speed_ = 0.02;
delay_ = 0;
progress_ = 0;
closing_ = true;

if (instance_exists(o_player))
{
	o_player.state_ = player.locked;
	o_player.image_speed = 0;
	o_player.image_index = 0;
}
