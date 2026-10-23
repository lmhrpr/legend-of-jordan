/// @description Cover the screen, change room, uncover

if (delay_ > 0)
{
	delay_ -= 1;
	exit;
}

if (closing_)
{
	progress_ = min(progress_ + speed_ * 2, 1);
	if (progress_ >= 1)
	{
		closing_ = false;
		// The iris pauses on black for a moment before opening
		hold_ = (type_ == trans_type.iris) ? round(global.one_second * 0.15) : 0;
		room_goto(target_);
	}
}
else if (hold_ > 0)
{
	hold_ -= 1;
}
else
{
	progress_ = max(progress_ - speed_ * 2, 0);
	if (progress_ <= 0)
	{
		instance_destroy();
	}
}
