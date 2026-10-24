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

// Update state
event_user(state_);

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