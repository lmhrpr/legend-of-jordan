/// @description Blown open by a bomb (only bombs list it as a target)
if (!hurtbox_entity_can_be_hit_by(other)) exit;
flag_set(flag_);
create_animation_effect(s_death_effect, x, y, 0.6, false);
play_sfx(a_collect_item, 6);
instance_destroy();
