if (closed_)
{
	if (flip_) draw_sprite_ext(s_door_bars, 0, x, y + 16, 1, -1, 0, c_white, 1);
	else draw_sprite(s_door_bars, 0, x, y);
}
