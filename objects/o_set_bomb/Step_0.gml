/// @description In the air: an arc to the target
if (flight_ < flight_time_)
{
	flight_ += 1;
	var _t = flight_ / flight_time_;
	var _nx = lerp(start_x_, target_x_, _t);
	var _ny = lerp(start_y_, target_y_, _t);
	if (stop_at_walls_ and place_meeting(_nx, _ny, o_solid))
	{
		flight_ = flight_time_;		// hit a wall: drop right there
		z_ = 0;
		exit;
	}
	x = _nx;
	y = _ny;
	z_ = -sin(_t * pi) * min(16, 6 + flight_time_ * 0.4);
	depth = -y;
}
