/// @description Give control back to Jordan
if (instance_exists(o_player))
{
	with (o_player)
	{
		if (state_ == player.locked and visible and !instance_exists(o_textbox))
		{
			state_ = player.move;
		}
	}
}
