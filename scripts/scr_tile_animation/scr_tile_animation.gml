/// Tile animation
/// The tileset's animated tiles are cycled in code. Any of these tiles
/// painted in the room editor animate automatically.

/// @function tile_animations_init()
function tile_animations_init()
{
	// frames: tile indices in s_top_down;  ticks: game steps per frame
	global.tile_anims = [
		{ frames: [160, 161], ticks: 30 },				// Granda's flowers (bobbing)
		{ frames: [64, 65, 66, 67], ticks: 12 },		// water
		{ frames: [80, 81, 82, 83], ticks: 12 },		// shallow water
		{ frames: [96, 97, 98, 99], ticks: 12 },		// deep water
		{ frames: [112, 113, 114, 115], ticks: 8 },		// waterfall
		{ frames: [128, 129, 130, 131], ticks: 12 },	// waves
		{ frames: [144, 145, 146, 147], ticks: 12 },	// shoreline
		{ frames: [176, 177, 178, 179], ticks: 6 },		// torches
		{ frames: [192, 193, 194, 195], ticks: 6 },
		{ frames: [208, 209, 210, 211], ticks: 6 },
		{ frames: [224, 225, 226, 227], ticks: 6 },
		{ frames: [304, 305, 306, 307], ticks: 6 },
		{ frames: [320, 321, 322, 323], ticks: 6 },
		{ frames: [336, 337, 338, 339], ticks: 6 },
		{ frames: [352, 353, 354, 355], ticks: 6 }
	];

	// Look-up: tile index -> [animation, position in animation]
	global.tile_anim_lookup = array_create(512, undefined);
	for (var _a = 0; _a < array_length(global.tile_anims); _a++)
	{
		var _frames = global.tile_anims[_a].frames;
		for (var _f = 0; _f < array_length(_frames); _f++)
		{
			global.tile_anim_lookup[_frames[_f]] = [_a, _f];
		}
	}
	global.tile_anim_cells = [];
	global.tile_anim_timer = 0;
}

/// @function tile_animations_scan()
/// @desc Finds every animated tile in the current room (call at Room Start)
function tile_animations_scan()
{
	global.tile_anim_cells = [];
	var _layers = layer_get_all();
	for (var _l = 0; _l < array_length(_layers); _l++)
	{
		var _map = layer_tilemap_get_id(_layers[_l]);
		if (_map == -1) continue;
		var _w = tilemap_get_width(_map);
		var _h = tilemap_get_height(_map);
		for (var _y = 0; _y < _h; _y++)
		{
			for (var _x = 0; _x < _w; _x++)
			{
				var _data = tilemap_get(_map, _x, _y);
				if (_data == -1) continue;
				var _index = tile_get_index(_data);
				if (_index <= 0 or _index >= array_length(global.tile_anim_lookup)) continue;
				var _info = global.tile_anim_lookup[_index];
				if (is_array(_info))
				{
					// Remember the tile's starting offset so neighbours stay out of step
					array_push(global.tile_anim_cells, [_map, _x, _y, _info[0], _info[1], _data]);
				}
			}
		}
	}
}

/// @function tile_animations_step()
function tile_animations_step()
{
	global.tile_anim_timer += 1;
	var _t = global.tile_anim_timer;
	var _cells = global.tile_anim_cells;
	for (var _i = 0; _i < array_length(_cells); _i++)
	{
		var _c = _cells[_i];
		var _anim = global.tile_anims[_c[3]];
		if (_t mod _anim.ticks != 0) continue;
		var _count = array_length(_anim.frames);
		var _frame = ((_t div _anim.ticks) + _c[4]) mod _count;
		tilemap_set(_c[0], tile_set_index(_c[5], _anim.frames[_frame]), _c[1], _c[2]);
	}
}
