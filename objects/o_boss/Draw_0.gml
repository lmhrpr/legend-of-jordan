/// @description Shadow, wind-up shake, damage flash
var _shake = (state_ == boss.windup) ? irandom_range(-1, 1) : 0;
draw_sprite_ext(s_medium_shadow, 0, x, y, scale_, scale_, 0, c_white, 1);
draw_sprite_ext(sprite_index, image_index, x + _shake, y, image_xscale, image_yscale, 0, image_blend, 1);
draw_self_flash(c_white, 12, alarm[0]);
