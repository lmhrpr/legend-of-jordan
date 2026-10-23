/// @description player.move

image_speed = 0;
var _animation_speed = 0.6;
var _x_input = (o_input.right_ - o_input.left_);						// -1, 0, 1
var _y_input = (o_input.down_ - o_input.up_);							// -1, 0, 1
var _input_direction = point_direction(0, 0, _x_input, _y_input);		// 45, 90, 135, 180, 225, 270, 315, 360
roll_direction_ = facing_direction_ * 90;

if (_x_input == 0 && _y_input == 0)
{
	// Not moving
	image_index = 0;
	image_speed = 0;
	apply_friction_to_movement_entity();
}
else
{
	// Moving
	image_speed = _animation_speed;
	if (_x_input != 0) image_xscale = _x_input;
	get_facing_direction(_input_direction);
	add_movement_maxspeed(_input_direction, acceleration_, max_speed_);
	roll_direction_ = facing_direction_ * 90;
}

// Z uses the first equipped item, X the second
inventory_use_item(o_input.action_one_pressed_, global.item[0]);
inventory_use_item(o_input.action_two_pressed_, global.item[1]);

move_movement_entity(false);