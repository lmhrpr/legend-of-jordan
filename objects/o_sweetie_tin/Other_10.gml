/// @description Take a sweetie
if (global.player_health < global.player_max_health)
{
	global.player_health = global.player_max_health;
	text = ["Jordan takes a sweetie from Granny's tin.", "Mmm! Hearts restored."];
	play_sfx(a_collect_item, 4);
}
else
{
	text = ["Granny's sweetie tin.", "Better save them for when you need them!"];
}
