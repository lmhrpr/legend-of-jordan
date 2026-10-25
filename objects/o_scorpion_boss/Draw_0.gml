/// @description Shadow (not under the sand), wind-up shake, damage flash
var _shake = (state_ == scorp.windup) ? irandom_range(-1, 1) : 0;
if (state_ != scorp.tunnel) draw_sprite_ext(s_medium_shadow, 0, x, y, 2.5, 2, 0, c_white, 1);
draw_sprite_ext(sprite_index, image_index, x + _shake, y, image_xscale, 1, 0, image_blend, 1);
draw_self_flash(c_white, 12, alarm[0]);
