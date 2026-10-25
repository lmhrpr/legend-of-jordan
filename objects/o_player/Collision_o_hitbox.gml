/// @description Hit logic

if (!visible) exit;		// fainted
if (jump_t_ > 0) exit;		// in the air: jumps over trouble
if (fall_t_ > 0) exit;		// already falling
if (hurtbox_entity_can_be_hit_by(other))
{
	invincible_ = true;
	alarm[0] = global.one_second;
	global.player_health -= other.damage_;
	var _direction = point_direction(other.x, other.y, x, y);
	set_movement(_direction, other.knockback_);
	state_ = player.hit;
	play_sfx(a_hurt, 6);
}