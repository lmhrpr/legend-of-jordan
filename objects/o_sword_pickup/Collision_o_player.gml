/// @description Jordan finds the Magic Sword!
if (other.state_ != player.move) exit;

var _sword = inventory_add_item(o_sword_item);
if (global.item[0] == noone or !instance_exists(global.item[0]))
{
	global.item[0] = _sword;
}

with (other)
{
	state_ = player.found_item;
	facing_direction_ = dir.down;
	item_found_sprite_ = s_sword_item;
}

audio_stop_all();
play_sfx(a_found_item, 10);
global.active_textbox = create_textbox([
	"You found the Magic Sword!",
	"Press Z to swing it.",
	"Press P to open your inventory. Equip items to Z or X."
], noone, false);

instance_destroy();
