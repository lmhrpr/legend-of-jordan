/// Dungeon helpers: world flags (switches pressed, doors opened, bosses beaten...),
/// small keys (each dungeon keeps its own count) and the "found an item" moment.

/// @function flag_get(name)
function flag_get(_name)
{
	return _name != "" and variable_struct_exists(global.flags, _name) and global.flags[$ _name];
}

/// @function flag_set(name)
function flag_set(_name)
{
	if (_name != "") global.flags[$ _name] = true;
}

/// @function keys_get()
/// @desc Keys Jordan holds for the dungeon he's in (0 outside dungeons)
function keys_get()
{
	if (global.dungeon == "" or !variable_struct_exists(global.keys, global.dungeon)) return 0;
	return global.keys[$ global.dungeon];
}

/// @function keys_add(amount)
function keys_add(_amount)
{
	if (global.dungeon == "") return;
	global.keys[$ global.dungeon] = keys_get() + _amount;
}

/// @function dungeon_for_room(room)
/// @desc The key/flag prefix for a dungeon room, or "" for anywhere else
function dungeon_for_room(_room)
{
	if (_room == r_dungeon1) return "d1";
	if (_room == r_dungeon2) return "d2";
	return "";
}

/// @function on_player_screen(x, y)
/// @desc True when the point is on the screen the camera is showing
function on_player_screen(_x, _y)
{
	if (!instance_exists(o_camera)) return true;
	return floor(_x / VIEW_W) == o_camera.map_grid_x_ - 1 and floor(_y / VIEW_H) == o_camera.map_grid_y_ - 1;
}

/// @function enemies_left_on_screen(x, y)
/// @desc How many enemies are still alive on the screen containing x, y
function enemies_left_on_screen(_x, _y)
{
	var _sx = floor(_x / VIEW_W), _sy = floor(_y / VIEW_H), _count = 0;
	with (o_enemy)
	{
		if (floor(x / VIEW_W) == _sx and floor(y / VIEW_H) == _sy) _count++;
	}
	return _count;
}

/// @function player_found_item(sprite, text)
/// @desc Jordan holds the item up over his head while the text box is open
function player_found_item(_sprite, _text)
{
	with (o_player)
	{
		// Mid-jump? Land first, or he'd hang in the air while holding the item up
		if (jump_t_ > 0)
		{
			x = jump_to_x_;
			y = jump_to_y_;
			jump_t_ = 0;
			jump_z_ = 0;
		}
		state_ = player.found_item;
		facing_direction_ = dir.down;
		item_found_sprite_ = _sprite;
	}
	play_sfx(a_found_item, 10);
	global.active_textbox = create_textbox(_text, noone, false);
}

/// @function camera_snap()
/// @desc Puts the camera straight onto Jordan's screen (no scrolling)
function camera_snap()
{
	if (!instance_exists(o_camera) or !instance_exists(o_player)) return;
	with (o_camera)
	{
		map_grid_x_ = floor(o_player.x / VIEW_W) + 1;
		map_grid_y_ = floor(o_player.y / VIEW_H) + 1;
		x = VIEW_W * (map_grid_x_ - 1);
		y = VIEW_H * (map_grid_y_ - 1);
		camera_set_view_pos(camera_, x, y);
		view_x_ = x;
		view_y_ = y;
	}
}

