/// Spikes: paint spike tiles (288 down, 289 up) on a room's "Tiles_Decor" layer, and when the
/// room starts each one becomes an o_spike that pops up and down every SPIKE_PERIOD seconds.
/// Tiles painted "up" (289) start up; "down" (288) start down, so mixing them makes patterns.

#macro SPIKE_TILE_DOWN 288
#macro SPIKE_TILE_UP 289
#macro SPIKE_TILE_SAND_DOWN 490		// the same on sandstone, for sandy floors
#macro SPIKE_TILE_SAND_UP 491
#macro SPIKE_PERIOD 1.5		// seconds between moves

/// @function spikes_make()
function spikes_make()
{
	var _layer = layer_get_id("Tiles_Decor");
	if (_layer == -1) return;
	var _map = layer_tilemap_get_id(_layer);
	var _tw = tilemap_get_tile_width(_map), _th = tilemap_get_tile_height(_map);
	for (var _r = 0; _r < tilemap_get_height(_map); _r++)
	{
		for (var _c = 0; _c < tilemap_get_width(_map); _c++)
		{
			var _index = tile_get_index(tilemap_get(_map, _c, _r));
			if (_index == SPIKE_TILE_DOWN or _index == SPIKE_TILE_UP or _index == SPIKE_TILE_SAND_DOWN or _index == SPIKE_TILE_SAND_UP)
			{
				var _up = (_index == SPIKE_TILE_UP or _index == SPIKE_TILE_SAND_UP);
				var _sand = (_index == SPIKE_TILE_SAND_DOWN or _index == SPIKE_TILE_SAND_UP) or floor_is_sand(_c * _tw + 8, _r * _th + 8);
				instance_create_layer(_c * _tw, _r * _th, "Instances", o_spike, { start_up_: _up, sand_: _sand });
				tilemap_set(_map, 0, _c, _r);		// the spike object draws it from now on
			}
		}
	}
}

/// @function floor_is_sand(x, y)
/// @desc True if the ground at a spot is sand (canyon, desert, sandy caves): spikes and floor
///       switches there use their sandstone sprites.
function floor_is_sand(_x, _y)
{
	var _layer = layer_get_id("Tiles_Ground");
	if (_layer == -1) return false;
	var _t = tile_get_index(tilemap_get_at_pixel(layer_tilemap_get_id(_layer), _x, _y));
	return array_contains([190, 36, 54, 450, 452], _t);
}
