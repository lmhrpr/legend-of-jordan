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
			// Seen from above: it glides in (its shadow catching up underneath), touches down
			// on the runway, then rolls along it slowing down
			var _ground = 112;
			var _px, _alt;
			if (plane_t_ < 0.55) { var _k = plane_t_ / 0.55; _px = lerp(-30, 120, _k); _alt = 48 * (1 - _k); }
			else { var _k2 = (plane_t_ - 0.55) / 0.45; _px = 120 + 130 * (1 - (1 - _k2) * (1 - _k2)); _alt = 0; }
			draw_sprite_ext(s_end_plane, 0, _px + _alt * 0.4, _oy + _ground, 1, 1, 0, c_black, 0.3);
			draw_sprite(s_end_plane, 0, _px, _oy + _ground - _alt);
		}
		break;

	case "street":
		draw_sprite(s_end_street, 0, 0, _oy);
		break;

	case "flat":
		draw_sprite(s_end_flat, 0, 0, _oy);
		if (door_open_) draw_sprite(s_end_flat_door_open, 0, 0, _oy);
		// The telly (its screen, in s_end_flat)
		var _tx = 148, _ty = 31 + _oy, _tw = 24, _th = 16;
		if (tv_ == "splash") draw_sprite_stretched(s_splash_screen, 0, _tx, _ty, _tw, _th);
		if (tv_ == "title") draw_sprite_stretched(s_title_card, title_frame(), _tx, _ty, _tw, _th);
		if (tv_ == "splash" or tv_ == "title") tv_scanlines(_tx, _ty, _tw, _th);
		break;
}

// Close-up of the telly: the game fills the screen inside the CRT's bezel
if (tv_ == "closeup" or tv_ == "closeup_title")
{
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
else
{
// People, back to front (the sofa counts as being at y 142)
var _list = [];
struct_foreach(actors_, method({ list: _list }, function(_n, _a) { if (_a.visible) array_push(list, _a); }));
if (scene_ == "flat") array_push(_list, { sofa: true, y: 142 });
array_sort(_list, function(_a, _b) { return _a.y - _b.y; });
for (var _i = 0; _i < array_length(_list); _i++)
{
	var _a = _list[_i];
	if (variable_struct_exists(_a, "sofa")) { draw_sprite(s_end_sofa, 0, 160, 120 + _oy); continue; }
	var _dir = (_a.dir == "left") ? "right" : _a.dir;
	var _spr = _a.sprites[$ _dir];
	var _frame = _a.moving ? floor(_a.frame) mod sprite_get_number(_spr) : 0;
	draw_sprite_ext(_spr, _frame, _a.x, _a.y + _oy, (_a.dir == "left") ? -1 : 1, 1, 0, c_white, 1);
}
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
