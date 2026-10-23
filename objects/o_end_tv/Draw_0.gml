/// @description The telly, and the game on its screen when it's on
draw_self();
if (!instance_exists(o_ending)) exit;
var _mode = o_ending.tv_;
if (_mode != "splash" and _mode != "title") exit;

var _x = x - 12, _y = y - 22, _w = 24, _h = 16;		// the screen inside s_end_crt
if (_mode == "splash") draw_sprite_stretched(s_splash_screen, 0, _x, _y, _w, _h);
else draw_sprite_stretched(s_title_card, o_ending.title_frame(), _x, _y, _w, _h);
o_ending.tv_scanlines(_x, _y, _w, _h);
