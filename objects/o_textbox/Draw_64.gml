/// @description Draw the text box

// Nearly the full width: the box sprite is drawn in three parts, with the middle stretched
var _box_w = VIEW_W - 8;
var _box_h = sprite_get_height(s_text_box);
var _x = (VIEW_W - _box_w) div 2;
var _y = GUI_H - _box_h - 4;
var _edge = 8;
var _spr_w = sprite_get_width(s_text_box);
draw_sprite_part(s_text_box, 0, 0, 0, _edge, _box_h, _x, _y);
draw_sprite_part_ext(s_text_box, 0, _edge, 0, _spr_w - _edge * 2, _box_h, _x + _edge, _y, (_box_w - _edge * 2) / (_spr_w - _edge * 2), 1, c_white, 1);
draw_sprite_part(s_text_box, 0, _spr_w - _edge, 0, _edge, _box_h, _x + _box_w - _edge, _y);

// Speaker's name
if (name_ != "")
{
	draw_sprite(s_name_box, 0, _x + 4, _y - sprite_get_height(s_name_box) + 2);
	draw_set_font(TEXTBOX_FONT);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_set_colour(make_colour_rgb(255, 214, 120));
	draw_text(_x + 4 + sprite_get_width(s_name_box) / 2, _y - sprite_get_height(s_name_box) / 2 + 2, name_);
}

// Text (already word-wrapped into lines by textbox_paginate)
draw_set_font(TEXTBOX_FONT);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_colour(c_white);
var _shown = string_copy(pages_[page_], 1, floor(chars_));
draw_text_ext(_x + 8, _y + 4, _shown, TEXTBOX_LINE_HEIGHT, 1000);

// "Next" arrow when the page is finished
if (chars_ >= string_length(pages_[page_]))
{
	draw_sprite(s_next_page, (current_time div 400) mod 2, _x + _box_w - 14, _y + _box_h - 10);
}

draw_set_font(global.font);
