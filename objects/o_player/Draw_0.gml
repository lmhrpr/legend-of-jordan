draw_sprite(s_medium_shadow, 0, x, y);
draw_self();
draw_self_flash(c_red, 12, alarm[0]);

// Hold a newly found item above his head
if (state_ == player.found_item and sprite_exists(item_found_sprite_))
{
	draw_sprite(item_found_sprite_, 0, x, y - 50);
}
