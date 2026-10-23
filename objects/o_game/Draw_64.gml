// Don't draw GUI on title screen
if (room == r_title or room == r_init) { exit; }

// If paused, show snapshot of screen
if sprite_exists(global.paused_sprite)
{
	draw_sprite_ext(global.paused_sprite, 0, 0, 0, global.paused_sprite_scale, global.paused_sprite_scale, 0, c_white, 1);
	draw_set_alpha(0.6);
	draw_rectangle_color(0, 0, VIEW_W, VIEW_H, c_black, c_black, c_black, c_black, false);
	draw_set_alpha(1);
}

// Draw gems box
draw_sprite(s_gems_box, 0, 0, 0);

// Draw gems
var _gem_string = string(global.player_gems);
var _text_width = string_width(_gem_string) + 4;
var _text_height = string_height(_gem_string) + 2;
draw_sprite(s_gem, 0, sprite_get_width(s_gems_box) / 2, (sprite_get_height(s_gems_box) / 2) + 6);
draw_text(sprite_get_width(s_gems_box) - _text_width, sprite_get_height(s_gems_box) - _text_height, _gem_string);

// Draw empty equipped boxes
draw_sprite(s_inv_box_equipped, 0, VIEW_W - sprite_get_width(s_inv_box), 0);
draw_sprite(s_inv_box_equipped, 0, VIEW_W - (sprite_get_width(s_inv_box) * 2), 0);

// Button labels under the equipped boxes
draw_set_font(f_12);
draw_set_halign(fa_center);
draw_set_colour(make_colour_rgb(255, 214, 120));
draw_text(VIEW_W - (sprite_get_width(s_inv_box) * 1.5), sprite_get_height(s_inv_box) - 2, "Z");
draw_text(VIEW_W - (sprite_get_width(s_inv_box) * 0.5), sprite_get_height(s_inv_box) - 2, "X");
draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_font(global.font);

// Draw equipped items 
if instance_exists(global.item[0])
{
	draw_sprite(global.item[0].sprite_, 0, VIEW_W - (sprite_get_width(s_inv_box) * 2) + (sprite_get_width(s_inv_box) / 2), 0);
}

if instance_exists(global.item[1])
{
	draw_sprite(global.item[1].sprite_, 0, VIEW_W - sprite_get_width(s_inv_box) + (sprite_get_width(s_inv_box) / 2), 0);
}

// Draw box around health bar
var _stats_right_edge = max((global.player_max_health * 15), (global.player_max_stamina * 15)) + 5;
var _stats_left_edge = sprite_get_width(s_inv_box) + 4;
// Dynamic box
draw_sprite_ext(s_stat_box, 0, sprite_get_width(s_inv_box) + 3, sprite_get_height(s_stat_box), _stats_right_edge - 1, 1, 0, c_white, 1);
// Right edge
draw_sprite(s_stat_box_edge, 0, sprite_get_width(s_inv_box) + _stats_right_edge, sprite_get_height(s_stat_box));
// Left edge
draw_sprite_ext(s_stat_box_edge, 0, _stats_left_edge, sprite_get_height(s_stat_box), -1, 1, 0, c_white, 1);

// Draw hearts
for (var _i = 0; _i < global.player_max_health; _i++)
{
	var _hx = _stats_left_edge + (_i * 15) + 1;
	var _hy = sprite_get_height(s_stat_box) - 25;
	if (global.player_health >= _i + 1)
	{
		draw_sprite(s_heart_ui, 1, _hx, _hy);					// full
	}
	else
	{
		draw_sprite(s_heart_ui, 0, _hx, _hy);					// empty...
		if (global.player_health >= _i + 0.5)					// ...with its left half filled
		{
			draw_sprite_part(s_heart_ui, 1, 0, 0, sprite_get_width(s_heart_ui) div 2, sprite_get_height(s_heart_ui), _hx, _hy);
		}
	}
}

// Draw stamina
for (var _i = 0; _i < global.player_max_stamina; _i++)
{
	var _filled = _i < global.player_stamina;
	draw_sprite(s_stamina, _filled, _stats_left_edge + (_i * 15) + 1, sprite_get_height(s_stat_box) - 14);
}

// Draw inventory
inventory_draw(sprite_get_width(s_inv_box) / 2, sprite_get_height(s_inv_box));