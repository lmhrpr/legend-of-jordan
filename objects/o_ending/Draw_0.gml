/// @description The plane (seen from above: its shadow on the ground, the plane up in the air)
if (plane_t_ < 0 or room != r_end_airport) exit;
var _a = marker("plane_start"), _b = marker("plane_touchdown"), _c = marker("plane_stop");
var _px, _py, _alt;
if (plane_t_ < 0.55)
{
	var _k = plane_t_ / 0.55;
	_px = lerp(_a.x, _b.x, _k); _py = lerp(_a.y, _b.y, _k); _alt = plane_height_ * (1 - _k);
}
else
{
	var _k2 = (plane_t_ - 0.55) / 0.45;
	var _e = 1 - (1 - _k2) * (1 - _k2);		// slowing down
	_px = lerp(_b.x, _c.x, _e); _py = lerp(_b.y, _c.y, _e); _alt = 0;
}
draw_sprite_ext(s_end_plane, 0, _px + _alt * 0.4, _py, 1, 1, 0, c_black, 0.3);
draw_sprite(s_end_plane, 0, _px, _py - _alt);
