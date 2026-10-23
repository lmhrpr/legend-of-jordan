/// @description Animated tiles, pause screen

if (!global.paused) tile_animations_step();

/// @description Pause screen

// (Enemies only move on Jordan's current screen: see o_enemy's Step event)

if global.paused
{
	var _array_size = array_length(global.inventory);
	
	// Navigate the inventory screen
	if o_input.right_pressed_
	{
		item_index_ = min(item_index_ + 1, _array_size - 1);
		audio_play_sound(a_menu_move, 1, false);
	}
	
	if o_input.left_pressed_
	{
		item_index_ = max(item_index_ - 1, 0);
		audio_play_sound(a_menu_move, 1, false);
	}
	
	// Equip inventory items
	if o_input.action_one_pressed_
	{
		global.item[0] = global.inventory[item_index_];
		audio_play_sound(a_menu_select, 3, false);
	}	
	
	if o_input.action_two_pressed_
	{
		global.item[1] = global.inventory[item_index_];
		audio_play_sound(a_menu_select, 3, false);
	}
}

if o_input.pause_pressed_
{
	// Don't pause on the title screen
	if (!room_has_toolbar()) { exit; }
	
	// If already paused, unpause
	if (global.paused)
	{
		global.paused = false;
		if sprite_exists(global.paused_sprite)
		{
			sprite_delete(global.paused_sprite);
		}
		instance_activate_all();
		audio_play_sound(a_unpause, 5, false);
	}
	else
	{
		// Don't pause during transitions, conversations, or while Jordan is fainted
		if (instance_exists(o_transition)) { exit; }
		if (instance_exists(o_textbox)) { exit; }
		if (!instance_exists(o_player) or !o_player.visible) { exit; }
		
		// Pause the game
		global.paused = true;
		
		// Create snapshot of current view
		var _sw = surface_get_width(application_surface);
		var _sh = surface_get_height(application_surface);
		global.paused_sprite = sprite_create_from_surface(application_surface, 0, 0, _sw, _sh, false, false, 0, 0);
		global.paused_sprite_scale = VIEW_W / _sw;	// the snapshot is the world only
			
		// Deactivate all instances
		instance_deactivate_all(true);
		
		// Reactivate inventory objects
		var _array_size = array_length(global.inventory);
		for (var _i = 0; _i < _array_size; _i++)
		{
			instance_activate_object(global.inventory[_i]);
		}
		
		// Reactivate input
		instance_activate_object(o_input);
		audio_play_sound(a_pause, 5, false);
	}
}