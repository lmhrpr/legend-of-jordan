var _open = flag_get(flag_);
mask_index = _open ? -1 : s_dungeon_entrance;		// solid only while sealed
if (!_open) exit;

// Walk onto the steps to go down
if (instance_exists(o_transition) or instance_exists(o_textbox) or !instance_exists(o_player)) exit;
if (o_player.state_ != player.move) exit;
if (point_in_rectangle(o_player.x, o_player.y - 3, x - 6, y - 6, x + 6, y + 6))
{
	global.player_start_position = start_;
	o_player.persistent = true;
	room_transition(trans_type.iris, room_, 0.02, 0);
}
