/// @description Draw End: darken this screen, after everything else is drawn
draw_primitive_begin(pr_trianglestrip);
draw_vertex_colour(x, y, colour_, alpha_top_);
draw_vertex_colour(x + VIEW_W, y, colour_, alpha_top_);
draw_vertex_colour(x, y + VIEW_H, colour_, alpha_bottom_);
draw_vertex_colour(x + VIEW_W, y + VIEW_H, colour_, alpha_bottom_);
draw_primitive_end();
