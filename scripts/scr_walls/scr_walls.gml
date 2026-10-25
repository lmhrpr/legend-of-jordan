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
	var _top_rims = [110, 111, 126, 127, 141, 142, 143, 157, 158, 159, 173, 174, 175, 481, 482];	// (481, 482: tiles 140 and 156 turned round)
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

// ---- Jumping with the Winged Boots ----
// Rims (white parapets) along the top edge of raised ground, and the cliff below it (bottom rims,
// faces, and the stairs and cave mouths cut into them).
#macro PLATEAU_TOP_RIMS [110, 111, 126, 127, 141, 142, 143, 154, 155, 157, 158, 159, 173, 174, 175, 481, 482]
#macro PLATEAU_CLIFF [205, 206, 207, 90, 91, 140, 156, 172, 221, 222, 223, 238, 239, 253, 254, 255, 2, 3, 4, 5, 294, 237]	// (172: an open bottom edge)
#macro JUMP_REACH 72		// furthest a jump can go (px): 4.5 tiles

/// @function plateau_height_at(x, y)
/// @desc How high the ground is at a spot: 0 on the canyon floor, otherwise the rows of cliff
///       (rim and faces) below the plateau it's on. A plateau whose cliff comes down behind
///       another one stands on the floor behind it, so only its own cliff counts.
function plateau_height_at(_x, _y)
{
	var _layer = layer_get_id("Tiles_Ground");
	if (_layer == -1) return 0;
	var _map = layer_tilemap_get_id(_layer);
	var _c = floor(_x / 16), _r = floor((_y - 3) / 16);
	var _h = tilemap_get_height(_map);
	if (_c < 0 or _c >= tilemap_get_width(_map) or _r < 0) return 0;
	var _top = PLATEAU_TOP_RIMS, _cliff = PLATEAU_CLIFF;
	// Down across the top to its edge... (an open notch in a rim further down is the top edge of
	// something lower; the notch he's standing in is part of his own plateau)
	var _r0 = _r;
	while (_r < _h)
	{
		var _t = tile_get_index(tilemap_get(_map, _c, _r));
		if (array_contains(_cliff, _t) or array_contains(_top, _t)) break;
		if (_t == 480 and _r > _r0) break;
		_r++;
	}
	// ...then count the cliff (none if the edge is the top rim of something lower: he's on the floor)
	var _n = 0;
	while (_r < _h and array_contains(_cliff, tile_get_index(tilemap_get(_map, _c, _r))))
	{
		_n++;
		_r++;
	}
	return _n;
}

/// @function jump_open_edge(x, y)
/// @desc The direction he can jump from here (an edge with no parapet), or -1
function jump_open_edge(_x, _y)
{
	var _layer = layer_get_id("Tiles_Ground");
	if (_layer == -1) return -1;
	var _t = tile_get_index(tilemap_get(layer_tilemap_get_id(_layer), floor(_x / 16), floor((_y - 3) / 16)));
	switch (_t)
	{
		case 479: return 0;		// right edge
		case 480: return 90;		// top edge
		case 478: return 180;		// left edge
		case 172: return 270;		// bottom edge
	}
	return -1;
}

/// @function jump_landing(direction)
/// @desc Called by Jordan. Where a jump that way would land: {x, y}, or undefined if he can't jump.
///       Two kinds of jump:
///       - over a pit (o_gap) right in front of him: to the nearest clear spot past it (nudged a few
///         pixels sideways if need be), not over walls;
///       - off an open plateau edge (facing out of it): inside the rim of the highest spot within
///         reach that's no higher than where he took off, never over anything higher.
function jump_landing(_dir)
{
	var _dx = lengthdir_x(1, _dir), _dy = lengthdir_y(1, _dir);
	var _h0 = plateau_height_at(x, y);

	// Over a pit
	var _gap = instance_place(x + _dx * 12, y + _dy * 12, o_gap);
	if (_gap != noone)
	{
		// A pit can set how far a jump over it may go (creation code: reach_ = 32;  for 2 tiles)
		var _reach = variable_instance_exists(_gap, "reach_") ? _gap.reach_ : JUMP_REACH;
		for (var _d = 8; _d <= _reach; _d += 2)
		{
			var _lx = x + _dx * _d, _ly = y + _dy * _d;
			if (place_meeting(_lx, _ly, [o_solid, o_ledge])) return undefined;	// a wall in the way
			// Land here, or a few pixels to the side if that's clear (so a stepping stone one tile
			// wide doesn't need lining up to the pixel)
			var _nudges = [0, -3, 3, -6, 6];
			for (var _n = 0; _n < array_length(_nudges); _n++)
			{
				var _nx = _lx + _dy * _nudges[_n], _ny = _ly + _dx * _nudges[_n];
				if (!place_meeting(_nx, _ny, [o_solid, o_ledge, o_gap])) return { x: _nx, y: _ny };
			}
		}
		return undefined;
	}

	// Off an open edge
	if (jump_open_edge(x, y) != _dir) return undefined;
	var _best = undefined, _best_h = -1;
	for (var _d = 8; _d <= JUMP_REACH; _d += 2)
	{
		var _cx = x + _dx * _d, _cy = y + _dy * _d;
		if (!place_meeting(_cx, _cy, o_ledge) and plateau_height_at(_cx, _cy) > _h0) break;	// higher ground in the way
		// Land here, or a few pixels to either side if that fits inside the rim
		var _nudges = [0, -4, 4, -8, 8];
		for (var _n = 0; _n < array_length(_nudges); _n++)
		{
			var _lx = _cx + _dy * _nudges[_n], _ly = _cy + _dx * _nudges[_n];
			if (place_meeting(_lx, _ly, [o_solid, o_ledge, o_gap])) continue;
			if (jump_open_edge(_lx, _ly) == _dir) continue;		// still on the edge he's leaving
			var _h = plateau_height_at(_lx, _ly);
			if (_h > _h0) continue;
			if (_h > _best_h)
			{
				_best_h = _h;
				_best = { x: _lx, y: _ly };
			}
			break;
		}
	}
	return _best;
}
