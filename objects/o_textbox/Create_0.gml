/// @description Initialise text box
pages_ = ["..."];
page_ = 0;
chars_ = 0;
text_speed_ = 0.6;
name_ = "";
voice_ = a_text;
ready_ = false;		// Ignore the key press that opened the box
last_blip_ = 0;

// Freeze Jordan while talking (unless he's still asleep)
if (instance_exists(o_player))
{
	if (o_player.state_ == player.move or o_player.state_ == player.hit)
	{
		o_player.state_ = player.locked;
		o_player.image_speed = 0;
		o_player.image_index = 0;
	}
}
