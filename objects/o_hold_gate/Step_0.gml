/// @description Sink or rise with the switch (it won't rise onto anyone)
var _held = false;
with (o_hold_switch) if (link_ == other.link_ and pressed_) _held = true;
var _want_open = invert_ ? !_held : _held;

if (_want_open and !open_)
{
	open_ = true;
	x = xstart - 100000;		// out of the way (it's drawn sunk at its spot)
}
else if (!_want_open and open_)
{
	x = xstart;
	if (place_meeting(x, y, [o_player, o_push_block, o_enemy])) x = xstart - 100000;		// wait till the spot is clear
	else open_ = false;
}
depth = open_ ? 60 : -(ystart + sprite_height);
