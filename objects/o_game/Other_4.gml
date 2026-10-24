/// @description Create Jordan at the start position

tile_animations_scan();
global.dungeon = dungeon_for_room(room);

if (room == r_title or room == r_init) { exit; }

walls_make_solid();		// cliffs on the Tiles_Walls layer block movement
spikes_make();			// spike tiles become spikes that pop up and down
doorways_make();		// dungeon doorway tiles walk Jordan through to the next room

if (!instance_exists(o_player) and instance_exists(global.player_start_position))
{
	var _start = global.player_start_position;
	instance_create_layer(_start.x, _start.y, "Instances", o_player);
}
