/// Cliffs and walls painted on a room's "Tiles_Walls" layer block movement.
/// When a room starts, invisible o_wall_solid blocks are laid along the drawn
/// rim and cliff face of each wall tile, so Jordan and the enemies stop at
/// the edge you can see (not at the edge of the 32px tile).

// For each tile in ts_dirt_walls: which 8x8 parts of the 32x32 tile are solid.
// Bit (row * 4 + column) is set when that part has rim or cliff-face pixels.
// (Made from the tileset image; regenerate if the tileset art changes.)
#macro WALL_TILE_MASKS [0,0,65416,65297,65280,34959,34952,34817,34816,0,4383,580,4369,4352,15,8,1,0]
#macro WALL_CELL 8

// Stair tiles (ts_top_down) placed on the ground or decor layer cut a way through a
// cliff: the wall underneath them isn't solid.
#macro WALL_STAIR_TILES [294]

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
	var _stairs = WALL_STAIR_TILES;
	var _stair_maps = [];
	var _names = ["Tiles_Decor", "Tiles_Ground"];
	for (var _n = 0; _n < array_length(_names); _n++)
	{
		var _l = layer_get_id(_names[_n]);
		if (_l != -1) array_push(_stair_maps, layer_tilemap_get_id(_l));
	}

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
				if (_solid and wall_is_stair(_stair_maps, _stairs, _c * WALL_CELL + 1, _r * WALL_CELL + 1)) _solid = false;
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

/// @function wall_is_stair(tilemaps, stair_tiles, x, y)
/// @desc True if any of the tilemaps has a stair tile at room position x, y
function wall_is_stair(_maps, _stairs, _x, _y)
{
	for (var _m = 0; _m < array_length(_maps); _m++)
	{
		var _index = tile_get_index(tilemap_get_at_pixel(_maps[_m], _x, _y));
		if (array_contains(_stairs, _index)) return true;
	}
	return false;
}

/// @function high_ground_at(x, y)
/// @desc True if the spot is on top of raised ground (a plateau): looking up from it, the first
///       ledge reached is a top rim (the plateau's own far edge), not a cliff face.
function high_ground_at(_x, _y)
{
	var _layer = layer_get_id("Tiles_Ground");
	if (_layer == -1) return false;
	var _map = layer_tilemap_get_id(_layer);
	var _c = floor(_x / 16), _r = floor((_y - 3) / 16);
	var _top_rims = [110, 111, 126, 127, 141, 142, 143, 157, 158, 159, 173, 174, 175];
	// Stairs, cave mouths and the tips of plateau tongues are cut into cliffs: standing below one,
	// Jordan is on the canyon floor, even though the plateau's top rim is further up.
	var _cut_in = [2, 3, 4, 5, 294, 237, 172];
	for (var _rr = _r - 1; _rr >= max(0, _r - 14); _rr--)
	{
		if (array_contains(_cut_in, tile_get_index(tilemap_get(_map, _c, _rr)))) return false;
		if (position_meeting(_c * 16 + 8, _rr * 16 + 8, o_ledge))
		{
			return array_contains(_top_rims, tile_get_index(tilemap_get(_map, _c, _rr)));
		}
	}
	return false;
}
