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
		room_goto(target_);
	}
}
else
{
	progress_ = max(progress_ - speed_ * 2, 0);
	if (progress_ <= 0)
	{
		instance_destroy();
	}
}
