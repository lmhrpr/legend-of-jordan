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
global.flags = {};			// dungeon switches, doors, bosses... (see scr_dungeon)
global.keys = {};			// small keys held, per dungeon
global.dungeon = "";		// which dungeon Jordan is in ("" outside)
global.arrive_at_ = "";		// set when leaving a dungeon: come out at its stairs
global.textbox_on_close = undefined;
global.player_health = global.player_max_health;
global.player_stamina = global.player_max_stamina;
global.active_textbox = noone;
global.loaded_flags = undefined;

// The window is the toolbar plus the world, at 3x. The world is drawn to the
// application surface as normal (960x540), and o_game's Post Draw puts it on the
// screen below the toolbar, so nothing is stretched.
application_surface_draw_enable(false);
window_set_size(VIEW_W * 3, GUI_H * 3);
call_later(1, time_source_units_frames, window_center);
// GUI at 3x from the window's top-left corner. (display_set_gui_size would fit the GUI
// to the world surface's 16:9 shape and push the toolbar down.)
display_set_gui_maximise(3, 3, 0, 0);

global.paused = false;
global.respawned = false;
global.paused_sprite = noone;
global.paused_sprite_scale = 1;

global.item[0] = noone;
global.item[1] = noone;
item_index_ = 0;

inventory_create(global.player_max_inv);
tile_animations_init();
// Jordan finds the Magic Sword in the Southern desert

name = "";
voice = a_text;