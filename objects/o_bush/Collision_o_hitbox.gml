/// @description Destroy the bush

if (health_ <= 0) { exit; }

if (hurtbox_entity_can_be_hit_by(other))
{
	invincible_ = true;
	alarm[0] = global.one_second * 0.5;
	health_ -= other.damage_;
	
	create_animation_effect(s_grass_effect, x, y, random_range(0.35, 0.85), true);
	
	if health_ <= 0
	{
		instance_destroy();
	}
}