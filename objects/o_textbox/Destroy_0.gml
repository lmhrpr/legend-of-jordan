/// @description Hand control back to Jordan

global.active_textbox = noone;

// Story moment waiting for this text to be read?
if (is_callable(on_close_))
{
	var _callback = on_close_;
	on_close_ = undefined;
	_callback();
}

if (instance_exists(o_player))
{
	with (o_player)
	{
		if (global.first_play)
		{
			// The opening: "Wake up, Jordan!"
			global.first_play = false;
			state_ = player.wake;
			image_index = 0;
			image_speed = 1;
		}
		else if (state_ == player.locked or state_ == player.found_item)
		{
			if (visible) state_ = player.move;
		}
	}
}
