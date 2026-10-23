/// @description player.bomb: throw it about 32px the way Jordan is facing

var _angle = facing_direction_ * 90;
instance_create_layer(x, y - 6, "Instances", o_set_bomb, {
	target_x_: x + lengthdir_x(32, _angle),
	target_y_: y - 6 + lengthdir_y(32, _angle)
});
audio_play_sound(a_set_bomb, 5, false);
state_ = player.move;
