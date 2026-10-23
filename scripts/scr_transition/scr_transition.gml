/// Room transitions

/// @function room_transition(type, room, speed, delay)
/// @desc Covers the screen, changes room, then uncovers it
function room_transition(_type, _room, _speed, _delay = 0)
{
	if (instance_exists(o_transition)) exit;

	var _transition = instance_create_depth(0, 0, -15900, o_transition);	// GameMaker only draws depths -16000 to 16000
	_transition.type_ = _type;
	_transition.target_ = _room;
	_transition.speed_ = max(_speed, 0.01);
	_transition.delay_ = _delay;
}

/// @function screen_transition(type, speed, on_cover)
/// @desc Covers the screen, calls on_cover (e.g. to move Jordan to another part of the room), uncovers
function screen_transition(_type, _speed, _on_cover)
{
	if (instance_exists(o_transition)) exit;

	var _transition = instance_create_depth(0, 0, -15900, o_transition);
	_transition.type_ = _type;
	_transition.target_ = room;
	_transition.speed_ = max(_speed, 0.01);
	_transition.on_cover_ = _on_cover;
}
