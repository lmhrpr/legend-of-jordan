/// @description Talk to the Keeper
if (!global.found_letter)
{
	text = [
		"Hmm? A human child, all the way out here?",
		"You haven't brought my post, have you?",
		"No? Then I can't help you. Rules are rules."
	];
}
else if (!global.met_keeper)
{
	text = [
		"Ah! At last! My post!",
		"Hmm. You're not the usual postboy, though. You must be his big brother. Same nose.",
		"Your Dad's Post Office has delivered to us forest folk for years, you know.",
		"...He never told you? No, I suppose he wouldn't.",
		"Your brother came by this morning with a whole bag of letters for the forest folk.",
		"Then something came crashing out of the trees after him. Something big.",
		"He dropped my letter and ran into the old ruins.",
		"Nobody goes into the ruins. Not even the post!",
		"If you're going after him, you'll need to get past the stone. Stand back..."
	];
	textbox_on_close(function() {
		global.met_keeper = true;
		with (o_ruin_entrance)
		{
			create_animation_effect(s_explosion_effect, x + 8, y + 16, 1, false);
		}
		play_sfx(a_explosion, 8);
	});
}
else
{
	text = [
		"The way into the ruins is open. Be careful down there.",
		"And if you find your brother, tell him I'm still waiting for the rest of the post!"
	];
}
