/// @description Cards, the telly close-up, captions and fades (over the room)
var _oy = HUD_H div 2;		// the world is drawn centred in the window in the ending's rooms

if (card_ != "")
{
	// Black card with a line of text, fading in and out
	draw_set_colour(c_black);
	draw_rectangle(0, 0, VIEW_W, GUI_H, false);
	var _t = timer_ / max(1, duration_);
	var _alpha = clamp(min(_t * 4, (1 - _t) * 4), 0, 1);
	draw_set_font(f_12);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_set_colour(c_white);
	draw_set_alpha(_alpha);
	draw_text(VIEW_W div 2, GUI_H div 2, card_);
	draw_set_alpha(1);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	exit;
}

// Close-up of the telly: the game fills the screen inside the CRT's bezel
if (tv_ == "closeup" or tv_ == "closeup_title")
{
	draw_set_colour(c_black);
	draw_rectangle(0, 0, VIEW_W, GUI_H, false);
	draw_set_colour(make_colour_rgb(70, 70, 78));
	draw_roundrect(4, _oy - 2, VIEW_W - 5, _oy + VIEW_H + 1, false);
	draw_set_colour(c_black);
	draw_rectangle(20, _oy + 10, VIEW_W - 21, _oy + VIEW_H - 11, false);
	draw_set_colour(c_white);
	var _cx = 22, _cy = _oy + 12, _cw = VIEW_W - 44, _ch = VIEW_H - 24;
	if (tv_ == "closeup") draw_sprite_stretched(s_splash_screen, 0, _cx, _cy, _cw, _ch);
	else draw_sprite_stretched(s_title_card, title_frame(), _cx, _cy, _cw, _ch);
	tv_scanlines(_cx, _cy, _cw, _ch);
	draw_set_colour(make_colour_rgb(220, 60, 60));
	draw_rectangle(VIEW_W - 14, _oy + VIEW_H - 8, VIEW_W - 11, _oy + VIEW_H - 6, false);
	draw_set_colour(c_white);
}

// Caption
if (caption_ != "")
{
	draw_set_font(f_12);
	draw_set_halign(fa_center);
	draw_set_colour(c_black);
	draw_text(VIEW_W div 2 + 1, _oy + 9, caption_);
	draw_set_colour(c_white);
	draw_text(VIEW_W div 2, _oy + 8, caption_);
	draw_set_halign(fa_left);
}

// Fade (also black while a new room loads)
var _fade = waiting_for_room_ ? 1 : fade_;
if (_fade > 0)
{
	draw_set_alpha(_fade);
	draw_set_colour(c_black);
	draw_rectangle(0, 0, VIEW_W, GUI_H, false);
	draw_set_alpha(1);
	draw_set_colour(c_white);
}
