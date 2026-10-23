/// Hitbox and hurtbox functions

/// @function create_hitbox(sprite, x, y, angle, life, targets, damage, knockback)
function create_hitbox(_sprite, _x, _y, _angle, _life, _targets, _damage, _knockback)
{
	var _hitbox = instance_create_layer(_x, _y, "Instances", o_hitbox);
	_hitbox.sprite_index = _sprite;
	_hitbox.mask_index = _sprite;
	_hitbox.image_angle = _angle;
	_hitbox.alarm[0] = _life;
	_hitbox.targets_ = _targets;
	_hitbox.damage_ = _damage;
	_hitbox.knockback_ = _knockback;
	_hitbox.hit_list_ = [];
	_hitbox.owner_ = id;
	return _hitbox;
}

/// @function initialise_hurtbox_entity()
function initialise_hurtbox_entity()
{
	invincible_ = false;
}

/// @function hurtbox_entity_can_be_hit_by(hitbox)
/// @desc True if this instance is one of the hitbox's targets and can take the hit
function hurtbox_entity_can_be_hit_by(_hitbox)
{
	if (invincible_) return false;
	if (_hitbox.owner_ == id) return false;

	var _targets = _hitbox.targets_;
	var _is_target = false;
	for (var _i = 0; _i < array_length(_targets); _i++)
	{
		var _target = _targets[_i];
		if (object_index == _target or object_is_ancestor(object_index, _target))
		{
			_is_target = true;
			break;
		}
	}
	if (!_is_target) return false;

	// Each hitbox only hits each instance once
	for (var _j = 0; _j < array_length(_hitbox.hit_list_); _j++)
	{
		if (_hitbox.hit_list_[_j] == id) return false;
	}
	array_push(_hitbox.hit_list_, id);
	return true;
}
