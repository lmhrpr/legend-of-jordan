/// @description Beaten already? Otherwise hurt Jordan on contact
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

event_inherited();

// Touching the boss hurts
hit_cooldown_ = max(0, hit_cooldown_ - 1);
if (hit_cooldown_ == 0 and on_player_screen(x, y) and place_meeting(x, y, o_player))
{
	var _hitbox = create_hitbox(s_porcupine_hitbox, x, y - 8, 0, 1, [o_player], 1, 5);
	_hitbox.image_xscale = scale_;
	_hitbox.image_yscale = scale_;
	hit_cooldown_ = 20;
}

// Keep facing the way it's going, at full size
if (abs(lengthdir_x(speed_, direction_)) > 0.05) image_xscale = scale_ * sign(lengthdir_x(speed_, direction_));
