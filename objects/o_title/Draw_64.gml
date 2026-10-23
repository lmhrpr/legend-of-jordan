/// @description Draw splash / title

if (phase_ == 0)
{
	// Fade the splash in and out
	var _alpha = min(1, timer_ / 40, (global.one_second * 3 - timer_) / 40);
	draw_sprite_ext(s_splash_screen, 0, 0, 0, 1, 1, 0, c_white, clamp(_alpha, 0, 1));
	exit;
}

draw_sprite(s_title_card, floor(title_frame_) mod sprite_get_number(s_title_card), 0, 0);

draw_set_font(f_12);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
var _y = 128;
for (var _i = 0; _i < array_length(menu_); _i++)
{
	var _text = menu_[_i];
	var _selected = (_i == menu_index_);
	if (_selected and (current_time div 400) mod 2 == 0) _text = "> " + _text + " <";
	draw_set_colour(c_black);
	draw_text(VIEW_W div 2 + 1, _y + _i * 13 + 1, _text);
	draw_set_colour(_selected ? make_colour_rgb(255, 214, 120) : c_white);
	draw_text(VIEW_W div 2, _y + _i * 13, _text);
}
draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_font(global.font);
