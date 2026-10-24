if (!instance_exists(o_player) or instance_exists(o_transition)) exit;
with (o_player)
{
	if (state_ != player.move or is_struct(auto_walk_)) exit;
	if (!point_in_rectangle(x, y, other.zone_[0], other.zone_[1], other.zone_[2], other.zone_[3])) exit;
	// Only when he's heading that way
	var _toward = (other.dir_ == 0 and o_input.right_) or (other.dir_ == 180 and o_input.left_)
		or (other.dir_ == 90 and o_input.up_) or (other.dir_ == 270 and o_input.down_);
	// (centre: the middle of the doorway, to line him up with the opening)
	if (_toward) auto_walk_ = { dir: other.dir_, target: other.target_,
		centre: (other.dir_ == 90 or other.dir_ == 270) ? (other.zone_[0] + other.zone_[2]) / 2 : (other.zone_[1] + other.zone_[3]) / 2 + 2 };
}
