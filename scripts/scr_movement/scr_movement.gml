/// Movement entity functions (used by Jordan and the enemies)

/// @function initialise_movement_entity(friction, bounce_amount, collision_object)
function initialise_movement_entity(_friction, _bounce_amount, _collision_object)
{
	speed_ = 0;
	direction_ = 0;
	friction_ = _friction;
	bounce_amount_ = _bounce_amount;
	collision_object_ = _collision_object;
}

/// @function set_movement(direction, speed)
function set_movement(_direction, _speed)
{
	direction_ = _direction;
	speed_ = _speed;
}

/// @function add_movement_maxspeed(direction, acceleration, max_speed)
function add_movement_maxspeed(_direction, _acceleration, _max_speed)
{
	var _x_speed = lengthdir_x(speed_, direction_) + lengthdir_x(_acceleration, _direction);
	var _y_speed = lengthdir_y(speed_, direction_) + lengthdir_y(_acceleration, _direction);
	speed_ = min(point_distance(0, 0, _x_speed, _y_speed), _max_speed);
	if (speed_ > 0)
	{
		direction_ = point_direction(0, 0, _x_speed, _y_speed);
	}
}

/// @function apply_friction_to_movement_entity()
function apply_friction_to_movement_entity()
{
	speed_ = approach(speed_, 0, friction_);
}

/// @function move_movement_entity(bounce)
/// @desc Moves by speed_/direction_, stopping (or bouncing) at collision_object_
function move_movement_entity(_bounce)
{
	var _x_speed = lengthdir_x(speed_, direction_);
	var _y_speed = lengthdir_y(speed_, direction_);

	// Horizontal
	if (place_meeting(x + _x_speed, y, collision_object_))
	{
		var _step = sign(_x_speed);
		var _moved = 0;
		while (_moved < abs(_x_speed) and !place_meeting(x + _step, y, collision_object_))
		{
			x += _step;
			_moved += 1;
		}
		_x_speed = _bounce ? -_x_speed * bounce_amount_ : 0;
	}
	else
	{
		x += _x_speed;
	}

	// Vertical
	if (place_meeting(x, y + _y_speed, collision_object_))
	{
		var _step = sign(_y_speed);
		var _moved = 0;
		while (_moved < abs(_y_speed) and !place_meeting(x, y + _step, collision_object_))
		{
			y += _step;
			_moved += 1;
		}
		_y_speed = _bounce ? -_y_speed * bounce_amount_ : 0;
	}
	else
	{
		y += _y_speed;
	}

	speed_ = point_distance(0, 0, _x_speed, _y_speed);
	if (speed_ > 0)
	{
		direction_ = point_direction(0, 0, _x_speed, _y_speed);
	}

	// Enemies stay on their own screen
	if (variable_instance_exists(id, "boundary_left_"))
	{
		x = clamp(x, boundary_left_, boundary_right_);
		y = clamp(y, boundary_top_, boundary_bottom_);
	}
}
