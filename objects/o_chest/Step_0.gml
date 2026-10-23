var _show = (appear_flag_ == "" or flag_get(appear_flag_));
if (_show and !shown_)
{
	create_animation_effect(s_death_effect, x, y - 8, 0.6, false);
	play_sfx(a_item, 8);
}
shown_ = _show;
visible = shown_;
mask_index = shown_ ? s_chest : -1;
sprite_index = shown_ ? s_chest : -1;
image_index = flag_get(flag_);
