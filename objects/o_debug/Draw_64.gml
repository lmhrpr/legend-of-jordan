if (!open_) exit;
draw_set_alpha(0.85);
draw_set_colour(c_black);
draw_rectangle(8, 8, VIEW_W - 8, GUI_H - 8, false);
draw_set_alpha(1);
draw_set_font(f_12);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_colour(make_colour_rgb(255, 214, 120));
draw_text(16, 12, "TEST MENU  (F1 to close)");
var _y = 26;
for (var _i = 0; _i < array_length(rooms_) + array_length(extras_); _i++)
{
	var _sel = (_i == index_);
	var _text;
	if (_i < array_length(rooms_))
	{
		_text = rooms_[_i].name;
		var _n = debug_screen_count(rooms_[_i].room);
		if (_sel and _n > 1) _text += "   < screen " + string(screen_ + 1) + " of " + string(_n) + " >";
	}
	else _text = extras_[_i - array_length(rooms_)];
	draw_set_colour(_sel ? c_white : c_gray);
	draw_text(16, _y, (_sel ? "> " : "  ") + _text);
	_y += 12;
}
draw_set_colour(c_white);
draw_set_font(global.font);
