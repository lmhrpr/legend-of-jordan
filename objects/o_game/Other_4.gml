/// @description Create Jordan at the start position

tile_animations_scan();

if (room == r_title or room == r_init) { exit; }

if (!instance_exists(o_player) and instance_exists(global.player_start_position))
{
	var _start = global.player_start_position;
	instance_create_layer(_start.x, _start.y, "Instances", o_player);
}
