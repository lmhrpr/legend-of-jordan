/// @description Put the world on screen, below the toolbar
// The application surface holds just the world (the 320x180 view at 3x). Draw it
// under the toolbar, using the same scale as the GUI so the two line up exactly.
draw_clear(c_black);
var _ww = window_get_width();
var _wh = window_get_height();
draw_surface_stretched(application_surface, 0, _wh * HUD_H / GUI_H, _ww, _wh * VIEW_H / GUI_H);
