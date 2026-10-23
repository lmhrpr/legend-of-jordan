/// Room transitions

/// @function room_transition(type, room, speed, delay)
/// @desc Covers the screen, changes room, then uncovers it
function room_transition(_type, _room, _speed, _delay = 0)
{
	if (instance_exists(o_transition)) exit;

	var _transition = instance_create_depth(0, 0, -20000, o_transition);
	_transition.type_ = _type;
	_transition.target_ = _room;
	_transition.speed_ = max(_speed, 0.01);
	_transition.delay_ = _delay;
}
