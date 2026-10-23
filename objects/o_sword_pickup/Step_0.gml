y = start_y_ + sin(current_time / 350) * 2;
if (chance(0.05))
{
	create_animation_effect(s_gem_shine_effect, x + random_range(-8, 8), y + random_range(4, 26), 1, false);
}
