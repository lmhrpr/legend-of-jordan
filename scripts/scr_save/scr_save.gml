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
