/// @description Jordan fainted: wake up at home

global.player_health = global.player_max_health;
global.player_stamina = global.player_max_stamina;
global.player_start_position = i_home_in;
global.respawned = true;
room_transition(trans_type.fade, r_home, 0.03, 0);
