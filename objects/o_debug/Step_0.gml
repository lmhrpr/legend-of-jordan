/// @description F1 opens/closes; up/down choose, left/right choose the screen, Enter goes
if (!DEBUG_MENU) exit;
if (keyboard_check_pressed(vk_f1) and room != r_title and room != r_init)
{
	open_ = !open_;
	if (instance_exists(o_player)) o_player.state_ = open_ ? player.locked : player.move;
	exit;
}
if (!open_) exit;

var _count = array_length(rooms_) + array_length(extras_);
if (keyboard_check_pressed(vk_down)) { index_ = (index_ + 1) mod _count; screen_ = 0; }
if (keyboard_check_pressed(vk_up)) { index_ = (index_ - 1 + _count) mod _count; screen_ = 0; }

if (index_ < array_length(rooms_))
{
	var _r = rooms_[index_].room;
	var _cols = rooms_[index_].cols;
	var _screens = _cols * rooms_[index_].rows;
	if (keyboard_check_pressed(vk_right)) screen_ = (screen_ + 1) mod _screens;
	if (keyboard_check_pressed(vk_left)) screen_ = (screen_ - 1 + _screens) mod _screens;
	if (keyboard_check_pressed(vk_enter))
	{
		open_ = false;
		global.debug_target = {
			x: (screen_ mod _cols) * VIEW_W + VIEW_W div 2,
			y: ((screen_ div _cols) + (variable_struct_exists(rooms_[index_], "first_row") ? rooms_[index_].first_row : 0)) * VIEW_H + VIEW_H div 2
		};
		global.player_start_position = noone;
		var _keep = (_r != r_ending);		// (no Jordan in the ending)
		if (!_keep) global.debug_target = undefined;
		if (instance_exists(o_player)) { o_player.persistent = _keep; o_player.state_ = player.move; }
		room_transition(trans_type.fade, _r, 0.04, 0);
	}
}
else if (keyboard_check_pressed(vk_enter))
{
	switch (index_ - array_length(rooms_))
	{
		case 0:
			if (!inventory_has_item(o_sword_item)) global.item[0] = inventory_add_item(o_sword_item);
			if (!inventory_has_item(o_bomb_item)) inventory_add_item(o_bomb_item);
			if (!inventory_has_item(o_boots_item)) inventory_add_item(o_boots_item);
			global.found_letter = true;
			global.main_quest_active = true;
			break;
		case 1: keys_add(1); break;
		case 2: global.player_health = global.player_max_health; break;
	}
	open_ = false;
	if (instance_exists(o_player)) o_player.state_ = player.move;
}
