/// @description bat.hover: keep station in front of Jordan

if (!instance_exists(o_player) or !o_player.visible or distance_to_object(o_player) > give_up_range_)
{
	state_ = bat.wander;
	exit;
}

image_speed = 0.3;

// Hover point: a little way from Jordan, on the side the bat is already on
var _away = point_direction(o_player.x, o_player.y, x, y);
var _target_x = o_player.x + lengthdir_x(hover_distance_, _away);
var _target_y = o_player.y + lengthdir_y(hover_distance_, _away);
var _distance = point_distance(x, y, _target_x, _target_y);

if (_distance > 2)
{
	add_movement_maxspeed(point_direction(x, y, _target_x, _target_y), 0.05, min(hover_speed_, _distance / 20));
}
else
{
	speed_ = approach(speed_, 0, 0.05);
}
move_movement_entity(true);

// Face Jordan
image_xscale = (o_player.x < x) ? -1 : 1;

state_timer_ -= 1;
if (state_timer_ <= 0)
{
	state_ = bat.windup;
	state_timer_ = round(global.one_second * 0.45);
	speed_ = 0;
}
