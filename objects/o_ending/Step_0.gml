/// @description Play the current step
if (waiting_for_room_) exit;
timer_ += 1;
tv_timer_ += 1;
var _s = steps_[step_];
var _done = false;

if (variable_struct_exists(_s, "card"))
{
	_done = timer_ >= duration_;
}
else if (variable_struct_exists(_s, "fade_in") or variable_struct_exists(_s, "fade_out"))
{
	fade_ = lerp(fade_from_, fade_to_, min(1, timer_ / max(1, duration_)));
	_done = timer_ >= duration_;
}
else if (variable_struct_exists(_s, "plane"))
{
	plane_t_ = min(1, timer_ / max(1, duration_));
	_done = timer_ >= duration_;
}
else if (variable_struct_exists(_s, "walk"))
{
	var _p = person(_s.walk), _m = marker(_s.to);
	var _d = point_distance(_p.x, _p.y, _m.x, _m.y);
	if (_d <= walk_speed_)
	{
		_p.x = _m.x; _p.y = _m.y; _p.moving_ = false;
		_done = true;
	}
	else
	{
		var _dir = point_direction(_p.x, _p.y, _m.x, _m.y);
		_p.x += lengthdir_x(walk_speed_, _dir);
		_p.y += lengthdir_y(walk_speed_, _dir);
		if (abs(lengthdir_x(1, _dir)) >= abs(lengthdir_y(1, _dir))) _p.dir_ = (lengthdir_x(1, _dir) > 0) ? "right" : "left";
		else _p.dir_ = (lengthdir_y(1, _dir) < 0) ? "up" : "down";
	}
}
else if (variable_struct_exists(_s, "say"))
{
	_done = !instance_exists(textbox_);
}
else if (variable_struct_exists(_s, "wait"))
{
	_done = timer_ >= duration_;
}

if (_done) next_step();
