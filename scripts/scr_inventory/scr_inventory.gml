/// Inventory functions

/// @function inventory_create(size)
function inventory_create(_size)
{
	global.inventory = array_create(_size, noone);
}

/// @function inventory_add_item(object)
/// @desc Adds an item to the first free slot and returns the item instance
function inventory_add_item(_object)
{
	var _size = array_length(global.inventory);
	for (var _i = 0; _i < _size; _i++)
	{
		if (!instance_exists(global.inventory[_i]))
		{
			var _item = instance_create_depth(0, 0, 0, _object);
			global.inventory[_i] = _item;
			return _item;
		}
	}
	return noone;
}

/// @function inventory_has_item(object)
function inventory_has_item(_object)
{
	var _size = array_length(global.inventory);
	for (var _i = 0; _i < _size; _i++)
	{
		var _item = global.inventory[_i];
		if (instance_exists(_item) and _item.object_index == _object) return true;
	}
	return false;
}

/// @function inventory_clear()
function inventory_clear()
{
	var _size = array_length(global.inventory);
	for (var _i = 0; _i < _size; _i++)
	{
		if (instance_exists(global.inventory[_i])) instance_destroy(global.inventory[_i]);
		global.inventory[_i] = noone;
	}
	global.item[0] = noone;
	global.item[1] = noone;
}

/// @function inventory_use_item(pressed, item)
/// @desc Called by Jordan: uses the equipped item if he has the stamina
function inventory_use_item(_pressed, _item)
{
	if (!_pressed) exit;
	if (!instance_exists(_item)) exit;
	if (state_ != player.move) exit;
	// The Winged Boots only work from an open edge, with somewhere to land
	if (_item.action_ == player.evade and is_undefined(jump_landing(facing_direction_ * 90))) exit;

	if (global.player_stamina >= _item.cost_)
	{
		global.player_stamina -= _item.cost_;
		if (_item.cost_ > 0) alarm[1] = global.one_second;
		state_ = _item.action_;
		image_index = 0;
	}
}

/// @function inventory_draw(x, y)
/// @desc Draws the inventory screen while the game is paused
function inventory_draw(_x, _y)
{
	if (!global.paused) exit;

	var _size = array_length(global.inventory);
	var _box_w = sprite_get_width(s_inv_box);
	var _total_w = _size * (_box_w + 4) - 4;
	var _start_x = (VIEW_W - _total_w) div 2;
	var _box_y = HUD_H + (VIEW_H div 2) - 24;

	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	draw_set_colour(c_white);
	draw_text(VIEW_W div 2, _box_y - 22, "INVENTORY");

	for (var _i = 0; _i < _size; _i++)
	{
		var _bx = _start_x + _i * (_box_w + 4);
		var _item = global.inventory[_i];
		var _equipped = instance_exists(_item) and (_item == global.item[0] or _item == global.item[1]);
		draw_sprite(_equipped ? s_inv_box_equipped : s_inv_box, 0, _bx, _box_y);
		if (instance_exists(_item))
		{
			draw_sprite(_item.sprite_, 0, _bx + _box_w / 2, _box_y);
			if (_item == global.item[0]) draw_sprite(s_button_badge, 0, _bx + 22, _box_y + 22);
			if (_item == global.item[1]) draw_sprite(s_button_badge, 1, _bx + 22, _box_y + 22);
		}
		if (_i == item_index_)
		{
			draw_sprite(s_pause_cursor, (current_time div 300) mod 2, _bx, _box_y);
		}
	}

	// Description of the selected item
	var _selected = global.inventory[item_index_];
	if (instance_exists(_selected))
	{
		draw_text_ext(VIEW_W div 2, _box_y + _box_w + 8, _selected.description_, 12, VIEW_W - 40);
	}
	draw_set_colour(c_ltgray);
	draw_text(VIEW_W div 2, GUI_H - 22, "Z / X: equip to that button    P: back");
	draw_set_colour(c_white);
	draw_set_halign(fa_left);
}
