/// @description scorp.tunnel: a mound in the sand making for the spot behind Jordan
sprite_index = s_scorpion_boss_mound;
image_speed = 0.15;
var _fast = (health_ <= max_health_ / 2);		// faster when it's hurt

if (instance_exists(o_player))
{
	// Behind Jordan: the opposite way to where he's facing
	var _behind = o_player.facing_direction_ * 90 + 180;
	target_x_ = clamp(o_player.x + lengthdir_x(30, _behind), boundary_left_ + 14, boundary_right_ - 14);
	target_y_ = clamp(o_player.y + lengthdir_y(24, _behind), boundary_top_ + 14, boundary_bottom_ - 4);
}
var _d = point_distance(x, y, target_x_, target_y_);
var _step = min(_d, _fast ? 2.2 : 1.6);
x += lengthdir_x(_step, point_direction(x, y, target_x_, target_y_));
y += lengthdir_y(_step, point_direction(x, y, target_x_, target_y_));
x = clamp(x, boundary_left_ + 14, boundary_right_ - 14);
y = clamp(y, boundary_top_ + 14, boundary_bottom_ - 4);

if (_d < 3 or alarm[1] <= 0)
{
	state_ = scorp.emerge;
	scorp_face_player();
	sprite_index = s_scorpion_boss_emerge;
	create_animation_effect(s_death_effect, x, y - 6, 0.6, false);
	create_hitbox(s_scorpion_boss_burst, x, y, 0, 6, [o_player], 0.5, 4);
	play_sfx(a_porcupine_attack, 7);
	alarm[1] = global.one_second * 0.35;
}
