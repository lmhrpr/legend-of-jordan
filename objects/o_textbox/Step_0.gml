/// @description Type out text and turn pages

var _page_text = pages_[page_];
var _length = string_length(_page_text);

if (chars_ < _length)
{
	chars_ = min(chars_ + text_speed_, _length);
	if (floor(chars_) - last_blip_ >= 2)
	{
		last_blip_ = floor(chars_);
		if (string_char_at(_page_text, last_blip_) != " ")
		{
			var _s = audio_play_sound(voice_, 1, false);
			audio_sound_pitch(_s, random_range(0.9, 1.1));
		}
	}
}

if (ready_ and o_input.interact_pressed_)
{
	if (chars_ < _length)
	{
		// Show the whole page at once
		chars_ = _length;
	}
	else if (page_ < array_length(pages_) - 1)
	{
		page_ += 1;
		chars_ = 0;
		last_blip_ = 0;
	}
	else
	{
		instance_destroy();
	}
	o_input.interact_pressed_ = false;
}

ready_ = true;
