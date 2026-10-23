/// @description Found the letter
if (!global.found_letter)
{
	global.found_letter = true;
	play_sfx(a_found_item, 9);
	text = [
		"It's a letter, stamped by the Post Office...",
		"This is the letter Liam was delivering for Dad!",
		"There are small footprints leading deeper into the forest.",
		"Liam must be somewhere close by...",
		"TO BE CONTINUED"
	];
}
else
{
	text = ["Liam's footprints lead deeper into the Old Forest...", "TO BE CONTINUED"];
}
