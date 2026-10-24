/// @description Blown open by a bomb (only bombs list it as a target)
if (flag_get(flag_) or !hurtbox_entity_can_be_hit_by(other)) exit;
flag_set(flag_);
create_animation_effect(s_death_effect, x + 8, y + 8, 0.6, false);
play_sfx(a_collect_item, 6);
