draw_sprite(s_small_shadow, 0, x, y + 8);
draw_self();
// Flash faster as the fuse burns down
draw_self_flash(c_white, max(4, alarm[0] div 6), alarm[0]);
