/// Enemy helper functions

/// @function porcupine_attack()
/// @desc Porcupines curl up and attack when Jordan gets close
function porcupine_attack()
{
	if (!instance_exists(o_player)) exit;
	if (!o_player.visible) exit;

	if (point_distance(x, y, o_player.x, o_player.y) <= range_)
	{
		state_ = porcupine.attack;
		sprite_index = s_porcupine_attack;
		image_index = 0;
	}
}
