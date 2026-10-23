/// @description Open the chest
if (flag_get(flag_))
{
	text = ["The chest is empty."];
	exit;
}
flag_set(flag_);
image_index = 1;

var _item = inventory_add_item(item_);
if (!instance_exists(global.item[1])) global.item[1] = _item;

// Jordan holds the item up while he reads (Jordan's interact code opens the text box)
text = lines_;
with (o_player)
{
	state_ = player.found_item;
	facing_direction_ = dir.down;
	item_found_sprite_ = object_get_sprite(other.item_);
}
play_sfx(a_found_item, 10);
