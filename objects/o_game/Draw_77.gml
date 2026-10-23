/// @description Put the world on screen, below the toolbar
// The application surface holds just the world (the 320x180 view at 3x).
// Draw it under the toolbar, at the same 3x scale as the GUI.
draw_clear(c_black);
draw_surface_stretched(application_surface, 0, HUD_H * 3, VIEW_W * 3, VIEW_H * 3);
