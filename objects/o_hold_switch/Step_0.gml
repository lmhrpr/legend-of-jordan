/// @description Down while Jordan (on foot) or a block is on it
var _was = pressed_;
pressed_ = place_meeting(x, y, o_push_block)
	or (instance_exists(o_player) and o_player.jump_t_ <= 0 and place_meeting(x, y, o_player));
image_index = pressed_;
if (pressed_ != _was) play_sfx(a_menu_select, 8);
