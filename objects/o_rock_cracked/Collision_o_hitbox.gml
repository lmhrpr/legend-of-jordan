/// @description Blown apart by a bomb (only bombs list it as a target)
if (!hurtbox_entity_can_be_hit_by(other)) exit;
flag_set(key_);
create_animation_effect(s_death_effect, x + 8, y + 8, 0.6, false);
play_sfx(a_collect_item, 6);
instance_destroy();
