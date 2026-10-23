/// @description Shadow, damage flash

draw_sprite(s_medium_shadow, 0, x, y);
draw_self();
draw_self_flash(c_white, 12, alarm[0]);

// Draw screen boundary box
//draw_rectangle_color(boundary_left_ + 5, boundary_top_ + 5, boundary_right_ - 5, boundary_bottom_ - 5, c_red, c_red, c_red, c_red, true);