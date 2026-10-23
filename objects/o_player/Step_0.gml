depth = -y;

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