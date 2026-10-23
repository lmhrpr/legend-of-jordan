/// @description Shadow, wind-up shake, damage flash
var _shake = (state_ == boss.windup) ? irandom_range(-1, 1) : 0;
draw_sprite_ext(s_medium_shadow, 0, x, y, scale_, scale_, 0, c_white, 1);
draw_sprite_ext(sprite_index, image_index, x + _shake, y, image_xscale, image_yscale, 0, image_blend, 1);
draw_self_flash(c_white, 12, alarm[0]);

// Dizzy: little stars circling its head
if (state_ == boss.dizzy)
{
	draw_set_colour(make_colour_rgb(255, 230, 90));
	for (var _i = 0; _i < 3; _i++)
	{
		var _a = current_time / 4 + _i * 120;
		draw_rectangle(x + lengthdir_x(10, _a) - 1, y - 36 + lengthdir_y(3, _a) - 1, x + lengthdir_x(10, _a) + 1, y - 36 + lengthdir_y(3, _a) + 1, false);
	}
	draw_set_colour(c_white);
}
