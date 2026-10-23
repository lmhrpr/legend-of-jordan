/// @description Draw the scene (in the GUI layer, centred in the window like the title screen)
var _oy = HUD_H div 2;
draw_set_colour(c_black);
draw_rectangle(0, 0, VIEW_W, GUI_H, false);
draw_set_colour(c_white);

if (card_ != "")
{
	// Black card with a line of text, fading in and out
	var _t = timer_ / max(1, duration_);
	var _alpha = clamp(min(_t * 4, (1 - _t) * 4), 0, 1);
	draw_set_font(f_12);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_set_alpha(_alpha);
	draw_text(VIEW_W div 2, GUI_H div 2, card_);
	draw_set_alpha(1);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	exit;
}

switch (scene_)
{
	case "airport":
		draw_sprite(s_end_airport, 0, 0, _oy);
		if (plane_t_ >= 0)
		{
			// Glide down to the runway, then roll along it slowing down
			var _px, _py;
			if (plane_t_ < 0.6) { var _k = plane_t_ / 0.6; _px = lerp(-24, 170, _k); _py = lerp(30, 146, _k); }
			else { var _k2 = (plane_t_ - 0.6) / 0.4; _px = 170 + 120 * (1 - (1 - _k2) * (1 - _k2)); _py = 146; }
			var _angle = (plane_t_ < 0.6) ? -16 : 0;
			draw_sprite_ext(s_end_plane, 0, _px, _oy + _py, 1, 1, _angle, c_white, 1);
		}
		break;

	case "street":
		draw_sprite(s_end_street, 0, 0, _oy);
		break;

	case "flat":
		draw_sprite(s_end_flat, 0, 0, _oy);
		if (door_open_) draw_sprite(s_end_flat_door_open, 0, 0, _oy);
		// The telly
		var _tx = 131, _ty = 64 + _oy, _tw = 59, _th = 43;
		if (tv_ == "splash") draw_sprite_stretched(s_splash_screen, 0, _tx, _ty, _tw, _th);
		if (tv_ == "title")
		{
			var _f = floor(tv_timer_ * sprite_get_speed(s_title_card) / game_get_speed(gamespeed_fps)) mod sprite_get_number(s_title_card);
			draw_sprite_stretched(s_title_card, _f, _tx, _ty, _tw, _th);
		}
		if (tv_ != "off")
		{
			// Scanlines and a bit of glow
			draw_set_alpha(0.15);
			draw_set_colour(c_black);
			for (var _l = _ty; _l < _ty + _th; _l += 2) draw_line(_tx, _l, _tx + _tw, _l);
			draw_set_alpha(1);
			draw_set_colour(c_white);
		}
		break;
}

// People, back to front (the sofa counts as being at y 175)
var _list = [];
struct_foreach(actors_, method({ list: _list }, function(_n, _a) { if (_a.visible) array_push(list, _a); }));
if (scene_ == "flat") array_push(_list, { sofa: true, y: 175 });
array_sort(_list, function(_a, _b) { return _a.y - _b.y; });
for (var _i = 0; _i < array_length(_list); _i++)
{
	var _a = _list[_i];
	if (variable_struct_exists(_a, "sofa")) { draw_sprite(s_end_sofa, 0, 160, 150 + _oy); continue; }
	var _dir = (_a.dir == "left") ? "right" : _a.dir;
	var _spr = _a.sprites[$ _dir];
	var _frame = _a.moving ? floor(_a.frame) mod sprite_get_number(_spr) : 0;
	draw_sprite_ext(_spr, _frame, _a.x, _a.y + _oy, (_a.dir == "left") ? -1 : 1, 1, 0, c_white, 1);
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

// Fade
if (fade_ > 0)
{
	draw_set_alpha(fade_);
	draw_set_colour(c_black);
	draw_rectangle(0, 0, VIEW_W, GUI_H, false);
	draw_set_alpha(1);
	draw_set_colour(c_white);
}
