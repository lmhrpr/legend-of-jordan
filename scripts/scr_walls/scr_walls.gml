/// Cliffs and walls painted on a room's "Tiles_Walls" layer block movement.
/// When a room starts, invisible o_wall_solid blocks are laid along the drawn
/// rim and cliff face of each wall tile, so Jordan and the enemies stop at
/// the edge you can see (not at the edge of the 32px tile).

// For each tile in ts_dirt_walls: which 8x8 parts of the 32x32 tile are solid.
// Bit (row * 4 + column) is set when that part has rim or cliff-face pixels.
// (Made from the tileset image; regenerate if the tileset art changes.)
#macro WALL_TILE_MASKS [0,0,65416,65297,65280,34959,34952,34817,34816,0,4383,580,4369,4352,15,8,1,0]
#macro WALL_CELL 8

/// @function walls_make_solid()
function walls_make_solid()
{
	var _layer = layer_get_id("Tiles_Walls");
	if (_layer == -1) return;
	if (instance_exists(o_wall_solid)) return;		// already done (persistent room)

	var _map = layer_tilemap_get_id(_layer);
	var _tw = tilemap_get_tile_width(_map);
	var _per = _tw div WALL_CELL;					// 8px parts across one tile
	var _cols = tilemap_get_width(_map) * _per;
	var _rows = tilemap_get_height(_map) * _per;
	var _masks = WALL_TILE_MASKS;

	// One row of 8px cells at a time; join neighbouring solid cells into one block
	for (var _r = 0; _r < _rows; _r++)
	{
		var _run_start = -1;
		for (var _c = 0; _c <= _cols; _c++)
		{
			var _solid = false;
			if (_c < _cols)
			{
				var _index = tile_get_index(tilemap_get(_map, _c div _per, _r div _per));
				if (_index > 0 and _index < array_length(_masks))
				{
					_solid = (_masks[_index] >> ((_r mod _per) * 4 + (_c mod _per))) & 1;
				}
			}
			if (_solid and _run_start == -1) _run_start = _c;
			if (!_solid and _run_start != -1)
			{
				var _block = instance_create_layer(_run_start * WALL_CELL, _r * WALL_CELL, "Instances", o_wall_solid);
				_block.image_xscale = (_c - _run_start) * WALL_CELL / sprite_get_width(s_solid);
				_block.image_yscale = WALL_CELL / sprite_get_height(s_solid);
				_run_start = -1;
			}
		}
	}
}
