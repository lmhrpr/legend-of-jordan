/// @description The ending: years later, in Baku
// The whole cutscene is the list of steps below, played in order. Edit the words and
// timings freely. Each step is a struct; the step types are:
//   { card: "text", time: 3 }             black screen with a line of text (seconds)
//   { scene: "airport" | "street" | "flat" }
//   { fade_in: 1 } / { fade_out: 1 }       (seconds)
//   { caption: "text" }                    a caption at the top ("" to clear)
//   { plane: 6 }                           the plane comes in to land (seconds)
//   { place: "liam", x: 0, y: 0, dir: "right", seated: false }   put someone somewhere
//   { hide: "liam" }
//   { walk: "liam", x: 0, y: 0 }           walk there (speed in walk_speed_)
//   { face: "liam", dir: "up" }
//   { say: "Mavi", lines: ["..."] }        a text box (waits until it's closed)
//   { ding: true }                         the doorbell
//   { door: true | false }                 the flat's front door open / shut
//   { tv: "off" | "splash" | "title" | "closeup" | "closeup_title" }   (close-ups fill the screen)
//   { music: a_home_music }                (or noone to stop)
//   { wait: 1 }                            (seconds)
//   { finish: true }                       back to the title screen
//
// All the dialogue below is a DRAFT for Liam to rewrite.

steps_ = [
	{ card: "Years later...", time: 3 },

	{ scene: "airport" },
	{ caption: "Baku, Azerbaijan" },
	{ fade_in: 1 },
	{ plane: 7 },
	{ caption: "" },
	{ fade_out: 1 },

	{ scene: "street" },
	{ place: "liam", x: -12, y: 110, dir: "right" },
	{ fade_in: 1 },
	{ walk: "liam", x: 168, y: 110 },
	{ face: "liam", dir: "up" },
	{ wait: 0.5 },
	{ ding: true },
	{ wait: 1.5 },
	{ fade_out: 1 },

	{ scene: "flat" },
	{ music: a_home_music },
	{ place: "jordan", x: 144, y: 128, dir: "up", seated: true },
	{ place: "mavi", x: 160, y: 126, dir: "up", seated: true },
	{ fade_in: 1.5 },
	{ say: "Mavi", lines: ["...and then what happened?"] },
	{ say: "Jordan", lines: [
		"Then Uncle Liam gave me a computer game. He'd been making a game for me the whole time!",
		"The Legend of Jordan."
	] },
	{ say: "Mavi", lines: ["Did you ever complete the game?"] },
	{ say: "Jordan", lines: ["Ha! I never got the chance. Liam never quite finished making it..."] },
	{ ding: true },
	{ wait: 1 },
	{ say: "Mavi", lines: ["Who's that?"] },
	{ place: "jordan", x: 144, y: 128, dir: "right", seated: false },
	{ walk: "jordan", x: 246, y: 66 },
	{ face: "jordan", dir: "right" },
	{ door: true },
	{ place: "liam", x: 264, y: 56, dir: "down" },
	{ wait: 0.5 },
	{ say: "Liam", lines: ["Hiya. Sorry it took me so long.", "I finally finished it."] },	
	{ wait: 1.5 },
	{ say: "Jordan", lines: ["No way."] },
	{ walk: "liam", x: 264, y: 76 },
	{ door: false },
	{ walk: "jordan", x: 144, y: 128 },
	{ walk: "liam", x: 176, y: 128 },
	{ place: "jordan", x: 144, y: 128, dir: "up", seated: true },
	{ place: "liam", x: 176, y: 128, dir: "up", seated: true },
	{ music: noone },
	{ wait: 0.5 },
	{ tv: "splash" },
	{ wait: 2 },
	{ tv: "closeup" },
	{ wait: 3 },
	{ tv: "closeup_title" },
	{ music: a_title_music },
	{ wait: 6 },
	{ fade_out: 2 },
	{ card: "THE END", time: 3 },
	{ card: "For Jordan, from Liam", time: 4 },
	{ finish: true }
];

step_ = -1;
timer_ = 0;			// steps (frames) into the current step
duration_ = 0;
scene_ = "";
caption_ = "";
card_ = "";
fade_ = 1;			// 1 = black
fade_from_ = 1;
fade_to_ = 1;
plane_t_ = -1;		// 0..1 while the plane is on screen
door_open_ = false;
tv_ = "off";
tv_timer_ = 0;
walk_speed_ = 0.9;
textbox_ = noone;
name = "";
voice = a_text;

// The people in it (sprites named directly: GameMaker leaves out sprites the code never names)
actors_ = {
	liam:   { sprites: { right: s_end_liam_right, up: s_end_liam_up, down: s_end_liam_down },   x: 0, y: 0, dir: "down", seated: false, visible: false, moving: false, frame: 0 },
	jordan: { sprites: { right: s_end_jordan_right, up: s_end_jordan_up, down: s_end_jordan_down }, x: 0, y: 0, dir: "down", seated: false, visible: false, moving: false, frame: 0 },
	mavi:   { sprites: { right: s_end_mavi_right, up: s_end_mavi_up, down: s_end_mavi_down },   x: 0, y: 0, dir: "down", seated: false, visible: false, moving: false, frame: 0 }
};

audio_stop_all();

/// The title card's animation frame, counted from when the telly showed it
title_frame = function()
{
	return floor(tv_timer_ * sprite_get_speed(s_title_card) / game_get_speed(gamespeed_fps)) mod sprite_get_number(s_title_card);
};

/// Faint scanlines over the telly picture
tv_scanlines = function(_x, _y, _w, _h)
{
	draw_set_alpha(0.15);
	draw_set_colour(c_black);
	for (var _l = _y; _l < _y + _h; _l += 2) draw_line(_x, _l, _x + _w, _l);
	draw_set_alpha(1);
	draw_set_colour(c_white);
};

next_step = function()
{
	step_ += 1;
	timer_ = 0;
	duration_ = 0;
	if (step_ >= array_length(steps_)) { step_ = array_length(steps_) - 1; return; }
	var _s = steps_[step_];

	if (variable_struct_exists(_s, "card"))		{ card_ = _s.card; duration_ = _s.time * global.one_second; fade_ = 1; }
	else if (variable_struct_exists(_s, "scene"))	{ scene_ = _s.scene; card_ = ""; door_open_ = false; tv_ = "off";
													  struct_foreach(actors_, function(_n, _a) { _a.visible = false; }); next_step(); }
	else if (variable_struct_exists(_s, "fade_in"))	{ fade_from_ = 1; fade_to_ = 0; duration_ = _s.fade_in * global.one_second; }
	else if (variable_struct_exists(_s, "fade_out")){ fade_from_ = fade_; fade_to_ = 1; duration_ = _s.fade_out * global.one_second; }
	else if (variable_struct_exists(_s, "caption"))	{ caption_ = _s.caption; next_step(); }
	else if (variable_struct_exists(_s, "plane"))	{ plane_t_ = 0; duration_ = _s.plane * global.one_second; }
	else if (variable_struct_exists(_s, "place"))
	{
		var _a = actors_[$ _s.place];
		_a.x = _s.x; _a.y = _s.y; _a.dir = _s.dir; _a.visible = true; _a.moving = false;
		_a.seated = variable_struct_exists(_s, "seated") ? _s.seated : false;
		next_step();
	}
	else if (variable_struct_exists(_s, "hide"))	{ actors_[$ _s.hide].visible = false; next_step(); }
	else if (variable_struct_exists(_s, "face"))	{ actors_[$ _s.face].dir = _s.dir; actors_[$ _s.face].moving = false; next_step(); }
	else if (variable_struct_exists(_s, "walk"))	{ actors_[$ _s.walk].moving = true; actors_[$ _s.walk].visible = true; actors_[$ _s.walk].seated = false; }
	else if (variable_struct_exists(_s, "say"))
	{
		name = _s.say;
		textbox_ = create_textbox(_s.lines, id, true);
	}
	else if (variable_struct_exists(_s, "ding"))
	{
		audio_play_sound(a_menu_select, 5, false);
		call_later(14, time_source_units_frames, function() { audio_play_sound(a_menu_move, 5, false); });
		next_step();
	}
	else if (variable_struct_exists(_s, "door"))	{ door_open_ = _s.door; audio_play_sound(a_menu_move, 3, false); next_step(); }
	else if (variable_struct_exists(_s, "tv"))		{ tv_ = _s.tv; tv_timer_ = 0; next_step(); }
	else if (variable_struct_exists(_s, "music"))
	{
		audio_stop_all();
		if (_s.music != noone) audio_play_sound(_s.music, 10, true);
		next_step();
	}
	else if (variable_struct_exists(_s, "wait"))	{ duration_ = _s.wait * global.one_second; }
	else if (variable_struct_exists(_s, "finish"))	{ audio_stop_all(); room_transition(trans_type.fade, r_title, 0.02, 0); }
};
next_step();
