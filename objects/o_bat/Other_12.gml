/// @description bat.hover: hang in the air in front of Jordan

if (!instance_exists(o_player) or !o_player.visible or distance_to_object(o_player) > give_up_range_)
{
	state_ = bat.wander;
	exit;
}

image_speed = 0.3;

// Its spot: a little way from Jordan, on the side the bat is already on.
// It only drifts over when it's well off the spot, so it doesn't shadow every step.
var _away = point_direction(o_player.x, o_player.y, x, y);
var _spot_x = o_player.x + lengthdir_x(hover_distance_, _away);
var _spot_y = o_player.y + lengthdir_y(hover_distance_, _away);
var _distance = point_distance(x, y, _spot_x, _spot_y);

if (_distance > hover_slack_)
{
	add_movement_maxspeed(point_direction(x, y, _spot_x, _spot_y), 0.02, hover_speed_);
}
else
{
	speed_ = approach(speed_, 0, 0.02);
}
move_movement_entity(true);

// Face Jordan
image_xscale = (o_player.x < x) ? -1 : 1;

state_timer_ -= 1;
if (state_timer_ <= 0)
{
	if (point_distance(x, y, o_player.x, o_player.y) <= notice_range_)
	{
		// Lock on to exactly where Jordan is standing NOW. He has the wind-up to get out of the way.
		target_x_ = o_player.x;
		target_y_ = o_player.y;
		return_x_ = x;
		return_y_ = y;
		state_ = bat.windup;
		state_timer_ = round(global.one_second * windup_time_);
		speed_ = 0;
	}
	else
	{
		// Jordan's out of range: keep hovering and try again shortly
		state_timer_ = round(global.one_second * 0.5);
	}
}
