/// @description Play the current step
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
	var _a = actors_[$ _s.walk];
	var _d = point_distance(_a.x, _a.y, _s.x, _s.y);
	if (_d <= walk_speed_)
	{
		_a.x = _s.x; _a.y = _s.y; _a.moving = false;
		_done = true;
	}
	else
	{
		var _dir = point_direction(_a.x, _a.y, _s.x, _s.y);
		_a.x += lengthdir_x(walk_speed_, _dir);
		_a.y += lengthdir_y(walk_speed_, _dir);
		if (abs(lengthdir_x(1, _dir)) >= abs(lengthdir_y(1, _dir))) _a.dir = (lengthdir_x(1, _dir) > 0) ? "right" : "left";
		else _a.dir = (lengthdir_y(1, _dir) < 0) ? "up" : "down";
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

// Walking animation
struct_foreach(actors_, function(_n, _a) {
	if (_a.moving) _a.frame += 0.2; else _a.frame = 0;
});

if (_done) next_step();
