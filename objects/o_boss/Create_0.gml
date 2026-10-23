/// @description Stand-in boss for the Old Forest ruins: a giant porcupine that charges
// (Swap the sprites for the real boss later.)
event_inherited();
initialise_movement_entity(0.15, 0.4, o_solid);

enum boss
{
	locked,		// = enemy.locked
	hit,		// = enemy.hit (knockback)
	chase,
	windup,
	charge,
	intro,		// sizing Jordan up when he arrives
	dizzy		// worn out after a charge: the moment to hit it
}

flag_ = "d1_boss";		// set when it's beaten (instance creation code can change it)
max_health_ = 6;		// hits to beat it
health_ = max_health_;
scale_ = 2;

starting_state_ = boss.chase;
state_ = boss.intro;
intro_time_ = global.one_second * 2;		// how long it waits once Jordan is in the arena

sprite_index = s_porcupine_run;
mask_index = s_porcupine_run;
image_xscale = scale_;
image_yscale = scale_;
hit_cooldown_ = 0;


