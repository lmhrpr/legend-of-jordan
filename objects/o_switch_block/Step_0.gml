/// @description Gone once the switch is pressed (and when coming back later)
if (flag_ != "" and flag_get(flag_))
{
	if (!quiet_) create_animation_effect(s_death_effect, x + 8, y + 8, 0.6, false);
	instance_destroy();
}
quiet_ = false;
