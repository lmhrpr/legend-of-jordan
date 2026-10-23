/// @description Title screen
timer_ += 1;
title_frame_ += sprite_get_speed(s_title_card) / game_get_speed(gamespeed_fps);

if (instance_exists(o_transition)) exit;

// For testing: press E on the title screen to watch the ending
if (keyboard_check_pressed(ord("E")))
{
	room_transition(trans_type.fade, r_ending, 0.02, 0);
	exit;
}

if (phase_ == 0)
{
	if (timer_ > global.one_second * 3 or o_input.interact_pressed_)
	{
		phase_ = 1;
		timer_ = 0;
		o_input.interact_pressed_ = false;
	}
	exit;
}

// Menu
if (o_input.up_pressed_ or o_input.down_pressed_)
{
	menu_index_ = (menu_index_ + 1) mod array_length(menu_);
	audio_play_sound(a_menu_move, 1, false);
}

if (o_input.interact_pressed_ and timer_ > 20)
{
	audio_play_sound(a_menu_select, 3, false);
	if (menu_[menu_index_] == "Continue" and load_game())
	{
		global.player_start_position = i_post_office_in;
		room_transition(trans_type.fade, r_post_office, 0.02, 0);
	}
	else
	{
		global.player_start_position = i_game_start;
		room_transition(trans_type.fade, r_village, 0.02, 0);
	}
}
