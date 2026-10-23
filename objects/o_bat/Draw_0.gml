/// @description Shadow, gentle bob while hovering, red flash before a swoop

draw_sprite(s_medium_shadow, 0, x, y);

var _bob = (state_ == bat.hover) ? sin(current_time / 160) * 1.5 : 0;
var _shake = (state_ == bat.windup) ? irandom_range(-1, 1) : 0;
draw_sprite_ext(sprite_index, image_index, x + _shake, y + _bob, image_xscale, image_yscale, 0, c_white, 1);

// Warning flash during the wind-up
if (state_ == bat.windup and (state_timer_ div 4) mod 2 == 0)
{
	gpu_set_fog(true, c_red, 0, 1);
	draw_sprite_ext(sprite_index, image_index, x + _shake, y + _bob, image_xscale, image_yscale, 0, c_white, 0.7);
	gpu_set_fog(false, c_white, 0, 0);
}

// Damage flash
draw_self_flash(c_white, 12, alarm[0]);
