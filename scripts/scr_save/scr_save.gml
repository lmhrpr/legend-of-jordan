/// Saving and loading (Dad's post box at the Post Office)

/// @function save_exists()
function save_exists()
{
	return file_exists(SAVE_FILE);
}

/// @function save_game()
function save_game()
{
	ini_open(SAVE_FILE);
	ini_write_real("player", "max_health", global.player_max_health);
	ini_write_real("player", "max_stamina", global.player_max_stamina);
	ini_write_real("player", "gems", global.player_gems);
	ini_write_real("quest", "main_quest_active", global.main_quest_active);
	ini_write_real("quest", "found_letter", global.found_letter);
	ini_write_real("quest", "met_keeper", global.met_keeper);
	var _cut = variable_struct_get_names(global.cut_bushes);
	var _cut_list = "";
	for (var _c = 0; _c < array_length(_cut); _c++) _cut_list += (_c > 0 ? "|" : "") + _cut[_c];
	ini_write_string("world", "cut_bushes", _cut_list);
	var _flags = variable_struct_get_names(global.flags);
	var _flag_list = "";
	for (var _f = 0; _f < array_length(_flags); _f++) _flag_list += (_f > 0 ? "|" : "") + _flags[_f];
	ini_write_string("world", "flags", _flag_list);
	var _dungeons = variable_struct_get_names(global.keys);
	for (var _d = 0; _d < array_length(_dungeons); _d++) ini_write_real("keys", _dungeons[_d], global.keys[$ _dungeons[_d]]);

	if (instance_exists(o_player))
	{
		ini_write_real("quest", "spoken_to_mum", o_player.spoken_to_mum);
		ini_write_real("quest", "spoken_to_dad", o_player.spoken_to_dad);
		ini_write_real("quest", "spoken_to_granny", o_player.spoken_to_granny);
		ini_write_real("quest", "spoken_to_granda", o_player.spoken_to_granda);
	}

	// Inventory, by object name, plus which slots are equipped
	var _size = array_length(global.inventory);
	for (var _i = 0; _i < _size; _i++)
	{
		var _item = global.inventory[_i];
		var _name = instance_exists(_item) ? object_get_name(_item.object_index) : "";
		ini_write_string("inventory", "slot" + string(_i), _name);
		var _equip = "";
		if (instance_exists(_item) and _item == global.item[0]) _equip = "A";
		if (instance_exists(_item) and _item == global.item[1]) _equip = "B";
		ini_write_string("inventory", "equip" + string(_i), _equip);
	}
	ini_close();
}

/// @function load_game()
/// @desc Restores the save and returns true if one was loaded
function load_game()
{
	if (!save_exists()) return false;

	ini_open(SAVE_FILE);
	global.player_max_health = ini_read_real("player", "max_health", 3);
	global.player_max_stamina = ini_read_real("player", "max_stamina", 2);
	global.player_gems = ini_read_real("player", "gems", 0);
	global.player_health = global.player_max_health;
	global.player_stamina = global.player_max_stamina;
	global.main_quest_active = ini_read_real("quest", "main_quest_active", false);
	global.found_letter = ini_read_real("quest", "found_letter", false);
	global.met_keeper = ini_read_real("quest", "met_keeper", false);
	global.cut_bushes = {};
	var _cut = string_split(ini_read_string("world", "cut_bushes", ""), "|", true);
	for (var _c = 0; _c < array_length(_cut); _c++) global.cut_bushes[$ _cut[_c]] = true;
	global.flags = {};
	var _flags = string_split(ini_read_string("world", "flags", ""), "|", true);
	for (var _f = 0; _f < array_length(_flags); _f++) global.flags[$ _flags[_f]] = true;
	global.keys = {};
	var _dungeons = ["d1"];
	for (var _d = 0; _d < array_length(_dungeons); _d++)
	{
		if (ini_key_exists("keys", _dungeons[_d])) global.keys[$ _dungeons[_d]] = ini_read_real("keys", _dungeons[_d], 0);
	}
	global.first_play = false;

	// Read by o_player's Create event
	global.loaded_flags = {
		spoken_to_mum: ini_read_real("quest", "spoken_to_mum", false),
		spoken_to_dad: ini_read_real("quest", "spoken_to_dad", false),
		spoken_to_granny: ini_read_real("quest", "spoken_to_granny", false),
		spoken_to_granda: ini_read_real("quest", "spoken_to_granda", false)
	};

	inventory_clear();
	var _size = array_length(global.inventory);
	for (var _i = 0; _i < _size; _i++)
	{
		var _name = ini_read_string("inventory", "slot" + string(_i), "");
		if (_name != "")
		{
			var _object = asset_get_index(_name);
			if (object_exists(_object))
			{
				var _item = instance_create_depth(0, 0, 0, _object);
				global.inventory[_i] = _item;
				var _equip = ini_read_string("inventory", "equip" + string(_i), "");
				if (_equip == "A") global.item[0] = _item;
				if (_equip == "B") global.item[1] = _item;
			}
		}
	}
	ini_close();
	return true;
}
