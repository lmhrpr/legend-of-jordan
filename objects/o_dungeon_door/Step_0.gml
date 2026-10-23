/// @description Jordan walks into the doorway
if (instance_exists(o_transition) or !instance_exists(o_player)) exit;
if (o_player.state_ != player.move) exit;

if (point_in_rectangle(o_player.x, o_player.y - 3, x - 8, y - 8, x + 8, y + 8))
{
	var _move = method({ dx: dest_x_, dy: dest_y_ }, function() {
		o_player.x = dx;
		o_player.y = dy;
		camera_snap();
	});
	screen_transition(trans_type.fade, 0.045, _move);
}
