var _open = flag_get(flag_);
image_index = _open;
mask_index = _open ? -1 : s_hidden_cave;
if (!_open) exit;

// Walk into the cave
if (instance_exists(o_transition) or !instance_exists(o_player) or o_player.state_ != player.move) exit;
if (point_in_rectangle(o_player.x, o_player.y - 3, x, y, x + 16, y + 16))
{
	global.player_start_position = start_;
	o_player.persistent = true;
	room_transition(trans_type.iris, room_, 0.02, 0);
}
