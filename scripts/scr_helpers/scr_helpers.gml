/// General helper functions

/// @function chance(probability)
/// @desc Returns true with the given probability (0-1)
function chance(_probability)
{
	return random(1) < _probability;
}

/// @function approach(value, target, amount)
function approach(_value, _target, _amount)
{
	if (_value < _target) return min(_value + _amount, _target);
	return max(_value - _amount, _target);
}

/// @function round_n(value, increment)
function round_n(_value, _increment)
{
	return round(_value / _increment) * _increment;
}

/// @function animation_hit_frame(frame)
/// @desc True on the step the animation reaches the given frame
function animation_hit_frame(_frame)
{
	var _speed = sprite_get_speed(sprite_index);
	if (sprite_get_speed_type(sprite_index) == spritespeed_framespersecond)
	{
		_speed = _speed / game_get_speed(gamespeed_fps);
	}
	var _frame_range = image_speed * _speed;
	return (image_index >= _frame) and (image_index < _frame + _frame_range);
}

/// @function get_facing_direction(direction)
/// @desc Sets facing_direction_ (dir enum) from an angle
function get_facing_direction(_direction)
{
	facing_direction_ = round(_direction / 90) mod 4;
}

/// @function set_sprite_facing()
/// @desc Flips the sprite to face the direction of horizontal movement
function set_sprite_facing()
{
	var _horizontal = lengthdir_x(speed_, direction_);
	if (abs(_horizontal) > 0.01)
	{
		image_xscale = sign(_horizontal);
	}
}

/// @function draw_self_flash(colour, frequency, timer)
/// @desc Draws the instance as a solid colour, flashing while timer > 0
function draw_self_flash(_colour, _frequency, _timer)
{
	if (_timer <= 0) exit;
	var _half = max(1, _frequency div 2);
	if ((_timer div _half) mod 2 == 0)
	{
		gpu_set_fog(true, _colour, 0, 1);
		draw_self();
		gpu_set_fog(false, c_white, 0, 0);
	}
}

/// @function lock_entities(lock)
/// @desc Locks (freezes) or unlocks the calling enemy
function lock_entities(_lock)
{
	if (_lock)
	{
		state_ = enemy.locked;
	}
	else if (state_ == enemy.locked)
	{
		state_ = starting_state_;
	}
}

/// @function create_animation_effect(sprite, x, y, speed, random_rotation)
/// @desc Plays a one-shot animation that destroys itself when finished
function create_animation_effect(_sprite, _x, _y, _speed, _random_rotation)
{
	var _effect = instance_create_depth(_x, _y, -10000, o_animation_effect);
	_effect.sprite_index = _sprite;
	_effect.image_speed = _speed;
	if (_random_rotation)
	{
		_effect.image_angle = choose(0, 90, 180, 270);
	}
	return _effect;
}

/// @function play_sfx(sound, priority)
/// @desc Plays a sound effect with slight random pitch
function play_sfx(_sound, _priority)
{
	var _s = audio_play_sound(_sound, _priority, false);
	audio_sound_pitch(_s, random_range(0.95, 1.05));
	return _s;
}
