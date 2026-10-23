image_index = flag_get(flag_);
if (!flag_get(flag_) and place_meeting(x, y, o_player))
{
	flag_set(flag_);
	image_index = 1;
	play_sfx(a_menu_select, 8);
	global.active_textbox = create_textbox([
		"Click!",
		"Somewhere in the ruins, a gate rumbles open."
	], noone, false);
}
