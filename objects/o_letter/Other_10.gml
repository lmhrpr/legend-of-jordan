/// @description Pick up the letter
text = [
	"A letter, stamped by Dad's Post Office.",
	"It's addressed to: The Keeper of the Old Forest.",
	"Liam must have dropped it!"
];
textbox_on_close(function() {
	global.found_letter = true;
	play_sfx(a_collect_item, 5);
	with (o_letter) instance_destroy();
});
