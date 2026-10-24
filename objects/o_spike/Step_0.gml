/// @description Every SPIKE_PERIOD seconds, all spikes flip (in step with each other); up ones hurt
var _phase = (current_time div round(SPIKE_PERIOD * 1000)) mod 2;
var _up = (_phase == 0) ? start_up_ : !start_up_;
if (_up != up_)
{
	up_ = _up;
	if (up_ and on_player_screen(x, y)) play_sfx(a_swipe, 2);
}
image_index = up_;

if (up_ and !instance_exists(o_transition) and place_meeting(x, y, o_player))
{
	create_hitbox(s_spikes, x, y, 0, 1, [o_player], 0.5, 3);
}
