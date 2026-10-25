/// @description Cave 6's boss: a giant scorpion that burrows under the sand and comes up behind Jordan
event_inherited();
initialise_movement_entity(0.15, 0.4, [o_solid, o_gap, o_ledge]);

enum scorp
{
	locked,		// = enemy.locked
	hit,		// = enemy.hit (knockback)
	intro,		// sizing Jordan up when he arrives
	burrow,		// sinking into the sand
	tunnel,		// a mound in the sand, heading for the spot behind Jordan
	emerge,		// bursting out (hurts if Jordan is standing on it)
	windup,		// tail cocked: the warning
	strike,		// tail lashes forward
	exposed		// tail stuck after the strike: the moment to hit it
}

flag_ = "canyon_boss";		// set when it's beaten (instance creation code can change it)
max_health_ = 6;			// hits to beat it
health_ = max_health_;

starting_state_ = scorp.burrow;		// after a hit it dives back under
state_ = scorp.intro;
intro_time_ = global.one_second * 1.5;
facing_ = -1;			// 1 = right, -1 = left (the sprites face right)
target_x_ = x;
target_y_ = y;
hit_cooldown_ = 0;
burrow_t_ = -1;			// counts down while it sinks into the sand

/// True while it's under the sand (nothing can hurt it)
scorp_underground = function()
{
	return state_ == scorp.burrow or state_ == scorp.tunnel;
}

/// Turn to face Jordan
scorp_face_player = function()
{
	if (instance_exists(o_player) and abs(o_player.x - x) > 2) facing_ = sign(o_player.x - x);
}

sprite_index = s_scorpion_boss_walk;
mask_index = s_scorpion_boss_walk;
image_xscale = facing_;
