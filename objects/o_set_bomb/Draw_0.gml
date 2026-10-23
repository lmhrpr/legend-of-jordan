draw_sprite(s_small_shadow, 0, x, y + 8);
draw_sprite(sprite_index, image_index, x, y + z_);
// Flash faster as the fuse burns down
if (alarm[0] > 0 and (alarm[0] div max(2, max(4, alarm[0] div 6) div 2)) mod 2 == 0)
{
	gpu_set_fog(true, c_white, 0, 1);
	draw_sprite(sprite_index, image_index, x, y + z_);
	gpu_set_fog(false, c_white, 0, 0);
}
