/// Dungeon doorways painted with doorway tiles: when Jordan steps into one, he walks himself
/// through to the next room (like Zelda) while the camera moves across.
///   top/bottom walls:  263 264 (in a bottom wall)  ...  247 248 or 279 280 (in the top wall below)
///   side walls:        249 250 (top row), 265 266 (bottom row)

#macro DOORWAY_WALK_SPEED 1.5

/// @function doorways_make()
function doorways_make()
{
	var _layer = layer_get_id("Tiles_Ground");
	if (_layer == -1 or global.dungeon == "") return;
	var _map = layer_tilemap_get_id(_layer);
	var _w = tilemap_get_width(_map), _h = tilemap_get_height(_map);
	var _tile = function(_m, _c, _r) { return tile_get_index(tilemap_get(_m, _c, _r)); };

	for (var _r = 0; _r < _h; _r++)
	{
		for (var _c = 0; _c < _w - 1; _c++)
		{
			var _t = _tile(_map, _c, _r);
			// A doorway in a bottom wall (left half 263): find the top wall below it
			if (_t == 263 and _tile(_map, _c + 1, _r) == 264)
			{
				for (var _r2 = _r + 1; _r2 < min(_h, _r + 4); _r2++)
				{
					var _below = _tile(_map, _c, _r2);
					if (_below == 247 or _below == 279)
					{
						var _x = (_c + 1) * 16;			// middle of the two-tile doorway
						// going down: step into the bottom wall's doorway, come out below the top wall
						instance_create_depth(_x, 0, 0, o_doorway, { dir_: 270,
							zone_: [_x - 8, _r * 16, _x + 8, _r * 16 + 16], target_: (_r2 + 1) * 16 + 10 });
						// going up: step into the top wall's doorway, come out above the bottom wall
						instance_create_depth(_x, 0, 0, o_doorway, { dir_: 90,
							zone_: [_x - 8, _r2 * 16, _x + 8, _r2 * 16 + 16], target_: _r * 16 - 4 });
						break;
					}
				}
			}
			// A doorway in side walls (top row 249 250, bottom row 265 266)
			if (_t == 249 and _tile(_map, _c + 1, _r) == 250 and _r + 1 < _h and _tile(_map, _c, _r + 1) == 265)
			{
				var _y = (_r + 1) * 16;					// the line between the two rows
				var _mid = (_c + 1) * 16;				// the border between the two walls
				instance_create_depth(_mid, _y, 0, o_doorway, { dir_: 0,
					zone_: [_c * 16, _y - 8, _mid, _y + 8], target_: _mid + 24 });
				instance_create_depth(_mid, _y, 0, o_doorway, { dir_: 180,
					zone_: [_mid, _y - 8, _mid + 16, _y + 8], target_: _mid - 24 });
			}
		}
	}
}
