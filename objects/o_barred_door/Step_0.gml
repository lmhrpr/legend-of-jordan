var _closed;
if (shut_in_)
{
	// The room this door belongs to is above it (the door sits in its bottom wall)
	_closed = !flag_get(flag_) and instance_exists(o_player) and on_player_screen(x, y - 32) and o_player.y < bbox_top - 6;
}
else
{
	_closed = !flag_get(flag_);
}

if (_closed != closed_)
{
	closed_ = _closed;
	if (!first_step_) play_sfx(closed_ ? a_hit : a_menu_select, 8);
}
first_step_ = false;
mask_index = closed_ ? s_door_bars : -1;
