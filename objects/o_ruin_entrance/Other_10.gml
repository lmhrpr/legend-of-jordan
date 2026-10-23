/// @description Look at the ruins
if (!global.met_keeper)
{
	text = [
		"A heavy stone slab covers some old steps going down.",
		"It won't budge."
	];
}
else
{
	text = [
		"Worn steps lead down into the dark.",
		"Is Liam really down there?"
	];
	// Down the steps when the text box closes
	textbox_on_close(function() {
		global.player_start_position = i_dungeon1_in;
		o_player.persistent = true;
		room_transition(trans_type.iris, r_dungeon1, 0.02, 0);
	});
}
