/// Spikes: paint spike tiles (288 down, 289 up) on a room's "Tiles_Decor" or "Tiles_Ground" layer, and when the
/// room starts each one becomes an o_spike that pops up and down every SPIKE_PERIOD seconds.
/// Tiles painted "up" (289) start up; "down" (288) start down, so mixing them makes patterns.

#macro SPIKE_TILE_DOWN 288
#macro SPIKE_TILE_UP 289
#macro SPIKE_TILE_SAND_DOWN 490		// the same on sandstone, for sandy floors
#macro SPIKE_TILE_SAND_UP 491
#macro SPIKE_PERIOD 1.5		// seconds between moves

/// @function spikes_make()
/// @desc Turns spike tiles into o_spike objects. They can be painted on "Tiles_Decor" or
///       straight onto "Tiles_Ground" (the floor under them is filled in from a neighbour).
function spikes_make()
{
	var _layers = ["Tiles_Decor", "Tiles_Ground"];
	for (var _l = 0; _l < array_length(_layers); _l++)
	{
		var _layer = layer_get_id(_layers[_l]);
		if (_layer == -1) continue;
		var _map = layer_tilemap_get_id(_layer);
		if (_map == -1) continue;
		var _on_ground = (_layers[_l] == "Tiles_Ground");
		var _tw = tilemap_get_tile_width(_map), _th = tilemap_get_tile_height(_map);
		var _w = tilemap_get_width(_map), _h = tilemap_get_height(_map);
		var _found = [];
		for (var _r = 0; _r < _h; _r++)
		{
			for (var _c = 0; _c < _w; _c++)
			{
				var _index = tile_get_index(tilemap_get(_map, _c, _r));
				if (spike_tile(_index)) array_push(_found, [_c, _r, _index]);
			}
		}
		for (var _i = 0; _i < array_length(_found); _i++)
		{
			var _c = _found[_i][0], _r = _found[_i][1], _index = _found[_i][2];
			var _up = (_index == SPIKE_TILE_UP or _index == SPIKE_TILE_SAND_UP);
			var _floor = 0;		// what goes under it (the decor layer is just cleared)
			if (_on_ground) _floor = spike_floor_under(_map, _c, _r, _w, _h);
			tilemap_set(_map, _floor, _c, _r);		// the spike object draws it from now on
			var _sand = (_index == SPIKE_TILE_SAND_DOWN or _index == SPIKE_TILE_SAND_UP) or floor_is_sand(_c * _tw + 8, _r * _th + 8);
			instance_create_layer(_c * _tw, _r * _th, "Instances", o_spike, { start_up_: _up, sand_: _sand });
		}
	}
}

/// @function spike_tile(index)
function spike_tile(_index)
{
	return _index == SPIKE_TILE_DOWN or _index == SPIKE_TILE_UP or _index == SPIKE_TILE_SAND_DOWN or _index == SPIKE_TILE_SAND_UP;
}

/// @function spike_floor_under(map, c, r, w, h)
/// @desc The nearest floor tile beside a spike painted on the ground layer (spreading out a row of spikes)
function spike_floor_under(_map, _c, _r, _w, _h)
{
	for (var _d = 1; _d < 8; _d++)
	{
		var _try = [[_c, _r - _d], [_c, _r + _d], [_c - _d, _r], [_c + _d, _r]];
		for (var _k = 0; _k < 4; _k++)
		{
			var _tc = _try[_k][0], _tr = _try[_k][1];
			if (_tc < 0 or _tr < 0 or _tc >= _w or _tr >= _h) continue;
			var _t = tilemap_get(_map, _tc, _tr);
			var _ti = tile_get_index(_t);
			if (_ti > 0 and !spike_tile(_ti) and floor_tile(_ti)) return _ti;
		}
	}
	return 190;		// sand
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

/// @function floor_tile(index)
/// @desc False for dungeon and cave wall tiles (the same list _tools/dungeon_solids.py uses)
function floor_tile(_index)
{
	return !array_contains([1, 240, 241, 242, 243, 244, 256, 258, 259, 260, 272, 273, 274, 275, 276, 277, 278,
		305, 307, 323, 336, 352, 456], _index);
}
