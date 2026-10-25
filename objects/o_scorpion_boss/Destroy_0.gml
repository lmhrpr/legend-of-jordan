/// @description Beaten: the heart container drops and the way out opens
for (var _i = 0; _i < 5; _i++)
{
	create_animation_effect(s_death_effect, x + random_range(-20, 20), y - 10 + random_range(-12, 8), 0.6, true);
}
play_sfx(a_explosion, 9);
flag_set(flag_);
instance_create_layer(x, y - 8, "Instances", o_heart_container, { flag_: flag_ + "_heart" });
