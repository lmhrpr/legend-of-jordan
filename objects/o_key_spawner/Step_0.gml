if (flag_get(flag_)) { instance_destroy(); exit; }
if (!on_player_screen(x, y) or instance_exists(o_transition)) exit;

if (enemies_left_on_screen(x, y) == 0)
{
	instance_create_layer(x, y, "Instances", o_key, { flag_: flag_ });
	play_sfx(a_item, 6);
	instance_destroy();
}
