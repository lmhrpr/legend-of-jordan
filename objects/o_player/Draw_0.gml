if (fall_t_ > 0)
{
	// Falling: shrinking away into the dark
	var _s = 1 - fall_t_ / FALL_TIME;
	draw_sprite_ext(sprite_index, image_index, x, y - 6 + 8 * (1 - _s), image_xscale * _s, image_yscale * _s, 0, image_blend, _s);
	exit;
}
draw_sprite(s_medium_shadow, 0, x, y);
draw_sprite_ext(sprite_index, image_index, x, y + jump_z_, image_xscale, image_yscale, 0, image_blend, image_alpha);
draw_self_flash(c_red, 12, alarm[0]);

// Hold a newly found item above his head
if (state_ == player.found_item and sprite_exists(item_found_sprite_))
{
	draw_sprite(item_found_sprite_, 0, x, y - 50);
}
