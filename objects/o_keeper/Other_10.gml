/// @description Talk to the Keeper
if (!global.found_letter)
{
	text = [
		"Hmm? A human child, all the way out here?",
		"You haven't brought my post, have you?",
		"No? Then I can't help you. Rules are rules."
	];
}
else if (!global.met_keeper and variable_instance_exists(id, "threw_bomb_"))
{
	text = ["Give it a moment..."];
}
else if (!global.met_keeper)
{
	text = [
		"Ah! At last! My post!",
		"Hmm. You're not the usual postboy, though. You must be his big brother. Same nose.",
		"Your Dad's Post Office has delivered to us forest folk for years, you know.",
		"...He never told you? No, I suppose he wouldn't.",
		"Your brother was due this morning with a whole bag of letters for the forest folk. He never came.",
		"And yet you found my letter lying on the path. So he did come this way...",
		"He was always asking me about the old ruins. What's down there? Who lives there?",
		"I'd wager that's where he's gone. Nobody goes into the ruins. Not even the post!",
		"Those old ruins are sealed with stone. A good bomb usually opens them up.",
		"Lucky for you, I keep one handy. Stand back..."
	];
	textbox_on_close(function() {
		// He lobs a bomb onto the slab (o_ruin_entrance opens when it goes off)
		with (o_keeper)
		{
			var _ruin = instance_nearest(x, y, o_ruin_entrance);
			if (_ruin != noone)
			{
				instance_create_layer(x, y - 8, "Instances", o_set_bomb, {
					target_x_: _ruin.x + 8, target_y_: _ruin.y + 8, hurts_player_: false, stop_at_walls_: false
				});
				audio_play_sound(a_set_bomb, 5, false);
				threw_bomb_ = true;
			}
			else global.met_keeper = true;
		}
	});
}
else
{
	text = [
		"The way into the ruins is open. Be careful down there.",
		"And if you find your brother, tell him I'm still waiting for the rest of the post!"
	];
}
