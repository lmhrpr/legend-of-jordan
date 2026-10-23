/// @description Initialise

global.one_second = game_get_speed(gamespeed_fps);
instance_create_layer(0, 0, "Instances", o_input);

global.font = f_12;
draw_set_font(global.font);

global.player_max_health = 3;
global.player_max_stamina = 2;
global.player_max_inv = 5;
global.player_gems = 0;
global.player_start_position = i_game_start;
global.quest_status = noone;

global.main_quest_active = false;
global.first_play = true;
global.found_letter = false;
global.met_keeper = false;
global.cut_bushes = {};		// "room:x:y" of every bush Jordan has cut down
global.textbox_on_close = undefined;
global.player_health = global.player_max_health;
global.player_stamina = global.player_max_stamina;
global.active_textbox = noone;
global.loaded_flags = undefined;

display_set_gui_size(VIEW_W, VIEW_H);

global.paused = false;
global.respawned = false;
global.paused_sprite = noone;
global.paused_sprite_scale = VIEW_W / view_wport[0];

global.item[0] = noone;
global.item[1] = noone;
item_index_ = 0;

inventory_create(global.player_max_inv);
tile_animations_init();
// Jordan finds the Magic Sword in the Southern desert

name = "";
voice = a_text;