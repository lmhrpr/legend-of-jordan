/// @description The toolbar, and the pause screen
// The world is drawn below the toolbar (see Post Draw),
// so the toolbar never covers the map.

// Don't draw GUI on title screen
if (room == r_title or room == r_init) { exit; }

// If paused, show a snapshot of the world, dimmed
if (sprite_exists(global.paused_sprite))
{
	draw_sprite_ext(global.paused_sprite, 0, 0, HUD_H, global.paused_sprite_scale, global.paused_sprite_scale, 0, c_white, 1);
	draw_set_alpha(0.6);
	draw_set_colour(c_black);
	draw_rectangle(0, HUD_H, VIEW_W, GUI_H, false);
	draw_set_alpha(1);
}

// --- Bar background: dark grey with a gold edge, like the text box ---
draw_set_colour(make_colour_rgb(54, 54, 54));
draw_rectangle(0, 0, VIEW_W, HUD_H - 1, false);
draw_set_colour(make_colour_rgb(251, 175, 93));
draw_rectangle(0, HUD_H - 1, VIEW_W, HUD_H - 1, false);	// gold edge along the bottom
draw_set_colour(c_white);

// --- Gems (centred vertically in the bar) ---
draw_sprite(s_gem, 0, 11, 18);
draw_set_font(f_12);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
var _gems = string(global.player_gems);
while (string_length(_gems) < 3) _gems = "0" + _gems;
draw_text(21, 4, "x" + _gems);

// --- Hearts: two rows of six ---
for (var _i = 0; _i < global.player_max_health; _i++)
{
	var _hx = 58 + (_i mod 6) * 14;
	var _hy = 2 + (_i div 6) * 11;
	if (global.player_health >= _i + 1)
	{
		draw_sprite(s_heart_ui, 1, _hx, _hy);				// full
	}
	else
	{
		draw_sprite(s_heart_ui, 0, _hx, _hy);				// empty...
		if (global.player_health >= _i + 0.5)				// ...with its left half filled
		{
			draw_sprite_part(s_heart_ui, 1, 0, 0, sprite_get_width(s_heart_ui) div 2, sprite_get_height(s_heart_ui), _hx, _hy);
		}
	}
}

// --- Stamina: rows of four ---
for (var _i = 0; _i < global.player_max_stamina; _i++)
{
	draw_sprite(s_stamina, _i < global.player_stamina, 150 + (_i mod 4) * 14, 2 + (_i div 4) * 11);
}

// --- Small keys (only in dungeons) ---
if (global.dungeon != "")
{
	draw_sprite(s_key, 0, 222, 20);
	draw_text(230, 4, "x" + string(keys_get()));
}

// --- Equipped items: Z and X ---
for (var _k = 0; _k < 2; _k++)
{
	var _sx = 266 + _k * 27;
	draw_sprite(s_item_slot, 0, _sx, 0);
	var _item = global.item[_k];
	if (instance_exists(_item))
	{
		// Draw just the picture (trimmed to its edges), centred in the slot
		var _spr = _item.sprite_;
		var _l = sprite_get_bbox_left(_spr), _t = sprite_get_bbox_top(_spr);
		var _w = sprite_get_bbox_right(_spr) - _l + 1, _h = sprite_get_bbox_bottom(_spr) - _t + 1;
		draw_sprite_part(_spr, 0, _l, _t, _w, _h, _sx + (24 - _w) div 2, (24 - _h) div 2);
	}
	draw_sprite(s_button_badge, _k, _sx + 15, 15);
}

draw_set_font(global.font);

// Inventory screen (only while paused)
inventory_draw(0, 0);
