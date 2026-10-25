/// @description Every SPIKE_PERIOD seconds, all spikes flip (in step with each other); up ones hurt
var _phase = (current_time div round(SPIKE_PERIOD * 1000)) mod 2;
var _up = (_phase == 0) ? start_up_ : !start_up_;
if (_up != up_)
{
	up_ = _up;
	if (up_ and on_player_screen(x, y)) play_sfx(a_swipe, 2);
}

// Animate: shoot up quickly, sink a little slower
frame_ = up_ ? min(3, frame_ + 0.5) : max(0, frame_ - 0.25);
image_index = floor(frame_);

// Only hurt once they're (nearly) all the way up, and not while Jordan is in the air
if (frame_ >= 2 and !instance_exists(o_transition) and instance_exists(o_player)
	and o_player.jump_t_ <= 0 and place_meeting(x, y, o_player))
{
	create_hitbox(sprite_index, x, y, 0, 1, [o_player], 0.5, 3);
}
