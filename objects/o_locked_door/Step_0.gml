if (flag_get(flag_)) { instance_destroy(); exit; }

// Jordan walks up into the door with a key in his pocket
if (keys_get() > 0 and !instance_exists(o_textbox)
	and collision_rectangle(bbox_left + 2, bbox_bottom + 1, bbox_right - 2, bbox_bottom + 4, o_player, false, true))
{
	keys_add(-1);
	flag_set(flag_);
	create_animation_effect(s_hit_effect, x + 8, y + 10, 1, false);
	play_sfx(a_menu_select, 8);
	instance_destroy();
}
