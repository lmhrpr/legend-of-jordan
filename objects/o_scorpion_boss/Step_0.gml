/// @description Beaten already? Otherwise hurt Jordan on contact (above the sand)
if (flag_get(flag_))
{
	// Left before picking up the heart? It's waiting where the boss started
	if (!flag_get(flag_ + "_heart") and !instance_exists(o_heart_container))
	{
		instance_create_layer(xstart, ystart - 8, "Instances", o_heart_container, { flag_: flag_ + "_heart" });
	}
	instance_destroy(id, false);
	exit;
}

// Under the sand nothing can touch it
if (scorp_underground()) invincible_ = true;
else if (alarm[0] <= 0) invincible_ = false;

event_inherited();

// Its claws and body hurt to touch when it's above the sand
hit_cooldown_ = max(0, hit_cooldown_ - 1);
if (!scorp_underground() and state_ != scorp.intro and hit_cooldown_ == 0 and on_player_screen(x, y)
	and !instance_exists(o_transition) and instance_exists(o_player) and o_player.visible
	and place_meeting(x, y, o_player))
{
	create_hitbox(s_scorpion_boss_burst, x, y, 0, 1, [o_player], 0.5, 4);
	hit_cooldown_ = 45;
}
image_xscale = facing_;
