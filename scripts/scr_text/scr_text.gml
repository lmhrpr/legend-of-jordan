/// Text box functions

/// @function create_textbox(text_array, speaker, show_name)
/// @desc Opens a dialogue box. The speaker's name and voice are copied,
///       so the speaker can be destroyed straight afterwards.
function create_textbox(_text, _speaker, _show_name)
{
	var _textbox = instance_create_depth(0, 0, -15000, o_textbox);

	// Copy the text so the speaker can change theirs safely
	var _pages = [];
	if (is_array(_text))
	{
		for (var _i = 0; _i < array_length(_text); _i++)
		{
			if (is_string(_text[_i]) and _text[_i] != "")
			{
				array_push(_pages, _text[_i]);
			}
		}
	}
	else
	{
		array_push(_pages, string(_text));
	}
	if (array_length(_pages) == 0) array_push(_pages, "...");

	_textbox.pages_ = textbox_paginate(_pages, TEXTBOX_WIDTH, TEXTBOX_LINES);
	_textbox.name_ = "";
	_textbox.voice_ = a_text;

	if (instance_exists(_speaker))
	{
		if (_show_name and variable_instance_exists(_speaker, "name")) _textbox.name_ = _speaker.name;
		if (variable_instance_exists(_speaker, "voice")) _textbox.voice_ = _speaker.voice;

		// Family members turn to face Jordan when he talks to them
		if (object_is_ancestor(_speaker.object_index, o_npc) and _speaker.image_speed == 0
			and sprite_get_number(_speaker.sprite_index) == 4 and instance_exists(o_player))
		{
			with (_speaker)
			{
				var _cx = (bbox_left + bbox_right) / 2;
				var _cy = (bbox_top + bbox_bottom) / 2;
				var _dir = point_direction(_cx, _cy, o_player.x, o_player.y - 8);
				if (_dir >= 45 and _dir < 135) image_index = 1;			// Jordan is above: face up
				else if (_dir >= 135 and _dir < 225) image_index = 2;	// left
				else if (_dir >= 225 and _dir < 315) image_index = 0;	// down
				else image_index = 3;									// right
			}
		}
	}

	return _textbox;
}


#macro TEXTBOX_FONT f_12
#macro TEXTBOX_WIDTH 184
#macro TEXTBOX_LINES 2
#macro TEXTBOX_LINE_HEIGHT 11

/// @function textbox_paginate(pages, width, max_lines)
/// @desc Word-wraps each page and splits any that won't fit in the box
function textbox_paginate(_pages, _width, _max_lines)
{
	var _old_font = draw_get_font();
	draw_set_font(TEXTBOX_FONT);
	var _result = [];

	for (var _p = 0; _p < array_length(_pages); _p++)
	{
		var _words = string_split(_pages[_p], " ", true);
		var _lines = [];
		var _line = "";
		for (var _w = 0; _w < array_length(_words); _w++)
		{
			var _try = (_line == "") ? _words[_w] : _line + " " + _words[_w];
			if (string_width(_try) > _width and _line != "")
			{
				array_push(_lines, _line);
				_line = _words[_w];
			}
			else
			{
				_line = _try;
			}
		}
		if (_line != "") array_push(_lines, _line);

		// Group the lines into pages of _max_lines
		for (var _l = 0; _l < array_length(_lines); _l += _max_lines)
		{
			var _page = _lines[_l];
			for (var _k = 1; _k < _max_lines and _l + _k < array_length(_lines); _k++)
			{
				_page += "\n" + _lines[_l + _k];
			}
			array_push(_result, _page);
		}
	}

	draw_set_font(_old_font);
	if (array_length(_result) == 0) array_push(_result, "...");
	return _result;
}
