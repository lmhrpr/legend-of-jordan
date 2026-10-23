/// @description A new scene's room has loaded: carry on
if (waiting_for_room_)
{
	waiting_for_room_ = false;
	next_step();
}
