depth = -y;

// Walking through a dungeon doorway by himself
if (is_struct(auto_walk_))
{
	var _d = auto_walk_.dir;
	x += lengthdir_x(DOORWAY_WALK_SPEED, _d);
	y += lengthdir_y(DOORWAY_WALK_SPEED, _d);
	if (_d == 90 or _d == 270) x = approach(x, auto_walk_.centre, 1);
	else y = approach(y, auto_walk_.centre, 1);
	facing_direction_ = _d div 90;
	sprite_index = sprite[player.move, facing_direction_];
	image_xscale = (_d == 180) ? -1 : 1;
	image_speed = 0.6;
	speed_ = 0;
	var _done = (_d == 0 and x >= auto_walk_.target) or (_d == 180 and x <= auto_walk_.target)
		or (_d == 90 and y <= auto_walk_.target) or (_d == 270 and y >= auto_walk_.target);
	if (_done) auto_walk_ = undefined;
	exit;
}

// Falling into a pit: shrink away, then lose a heart and come back on safe ground
if (fall_t_ > 0)
{
	fall_t_ += 1;
	speed_ = 0;
	image_speed = 0;
	if (fall_t_ >= FALL_TIME)
	{
		fall_t_ = 0;
		x = safe_x_;
		y = safe_y_;
		state_ = player.move;
		global.player_health -= FALL_DAMAGE;
		invincible_ = true;
		alarm[0] = global.one_second;
		play_sfx(a_hurt, 6);
	}
	else exit;
}

// Update state
event_user(state_);

// Walking off the edge of a pit (holding a direction into it; a tap only turns him)
if (state_ == player.move and jump_t_ == 0 and visible)
{
	var _xi = o_input.right_ - o_input.left_;
	var _yi = o_input.down_ - o_input.up_;
	var _into = false;
	if (_xi != 0 or _yi != 0)
	{
		var _d = point_direction(0, 0, _xi, _yi);
		_into = fall_pit_near(x + lengthdir_x(2, _d), y + lengthdir_y(2, _d), 0);
	}
	edge_t_ = _into ? edge_t_ + 1 : 0;
	if (edge_t_ >= FALL_EDGE_FRAMES)
	{
		x += lengthdir_x(6, _d);
		y += lengthdir_y(6, _d);
		player_start_fall();
	}
	else if (!fall_pit_near(x, y, 12))
	{
		safe_x_ = x;		// solid ground well away from any pit
		safe_y_ = y;
	}
}

// Update the sprite
if global.first_play 
{
	sprite_index = s_jordan_sleep;
}
else
{
	sprite_index = sprite[state_, facing_direction_];
}

// Jordan faints when out of hearts, and wakes up at home
if (global.player_health <= 0 and visible)
{
	create_animation_effect(s_death_effect, x, y - 8, 0.6, false);
	play_sfx(a_hurt, 8);
	visible = false;
	invincible_ = true;
	state_ = player.locked;
	persistent = true;
	o_game.alarm[1] = global.one_second * 2;
}

///@desc Interact with NPCs and signs
if (o_input.interact_pressed_ and state_ == player.move)
{
	if (global.active_textbox == noone)
	{	
		var _interactive_object = collision_rectangle(
			x - interact_radius, 
			y - interact_radius, 
			x + interact_radius, 
			y + interact_radius, 
			o_interactive, 
			false, 
			false);
		
		if (_interactive_object != noone)
		{
			with(_interactive_object)
			{
				// Run o_interactive User Event 0 
				event_user(0);
				global.active_textbox = create_textbox(text, speaker, true);
			}
		}
	} 
	else
	{
		if (!instance_exists(global.active_textbox))
		{
			global.active_textbox = noone;
		}
	}
}