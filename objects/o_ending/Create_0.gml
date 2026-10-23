/// @description The ending: years later, in Baku
// The whole cutscene is the list of steps below, played in order. The places are real rooms
// (r_end_airport, r_end_street, r_end_flat): edit their tiles and props in the room editor.
// Named spots in them are o_end_marker instances (their creation code sets mark_), and the
// steps below use those names, so moving a marker in the room moves where people go.
// Each step is a struct; the step types are:
//   { card: "text", time: 3 }              black screen with a line of text (seconds)
//   { scene: r_end_flat }                   go to that room (do this while the screen is black)
//   { fade_in: 1 } / { fade_out: 1 }        (seconds)
//   { caption: "text" }                     a caption at the top ("" to clear)
//   { plane: 7 }                            the plane lands, via markers plane_start, plane_touchdown, plane_stop
//   { place: "liam", at: "liam_start", dir: "right" }   put someone at a marker
//   { hide: "liam" }
//   { walk: "liam", to: "liam_at_door" }    walk to a marker (speed in walk_speed_)
//   { face: "liam", dir: "up" }
//   { say: "Mavi", lines: ["..."] }         a text box (waits until it's closed)
//   { ding: true }                          the doorbell
//   { door: true | false }                  the flat's front door open / shut
//   { tv: "off" | "splash" | "title" | "closeup" | "closeup_title" }   (close-ups fill the screen)
//   { music: a_home_music }                 (or noone to stop)
//   { wait: 1 }                             (seconds)
//   { finish: true }                        back to the title screen
//
// All the dialogue below is a DRAFT for Liam to rewrite.

steps_ = [
	{ card: "Years later...", time: 3 },

	{ scene: r_end_airport },
	{ caption: "Baku, Azerbaijan" },
	{ fade_in: 1 },
	{ plane: 7 },
	{ caption: "" },
	{ fade_out: 1 },

	{ scene: r_end_street },
	{ place: "liam", at: "liam_start", dir: "right" },
	{ fade_in: 1 },
	{ walk: "liam", to: "liam_at_door" },
	{ face: "liam", dir: "up" },
	{ wait: 0.5 },
	{ ding: true },
	{ wait: 1.5 },
	{ fade_out: 1 },

	{ scene: r_end_flat },
	{ music: a_home_music },
	{ place: "jordan", at: "jordan_seat", dir: "up" },
	{ place: "mavi", at: "mavi_seat", dir: "up" },
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
	{ face: "jordan", dir: "right" },
	{ walk: "jordan", to: "jordan_at_door" },
	{ face: "jordan", dir: "right" },
	{ door: true },
	{ place: "liam", at: "liam_at_door", dir: "down" },
	{ wait: 0.5 },
	{ say: "Liam", lines: ["Hiya. Sorry it took me so long.", "I finally finished it."] },
	{ wait: 1.5 },
	{ say: "Jordan", lines: ["No way."] },
	{ walk: "liam", to: "liam_inside" },
	{ door: false },
	{ walk: "jordan", to: "jordan_seat" },
	{ walk: "liam", to: "liam_seat" },
	{ face: "jordan", dir: "up" },
	{ face: "liam", dir: "up" },
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

persistent = true;		// carries on from room to room
step_ = -1;
timer_ = 0;			// steps (frames) into the current step
duration_ = 0;
caption_ = "";
card_ = "";
fade_ = 1;			// 1 = black
fade_from_ = 1;
fade_to_ = 1;
plane_t_ = -1;		// 0..1 while the plane is on screen
tv_ = "off";
tv_timer_ = 0;
walk_speed_ = 0.9;
plane_height_ = 48;	// how high the plane starts
textbox_ = noone;
waiting_for_room_ = false;
name = "";
voice = a_text;

// The people in it (sprites named directly: GameMaker leaves out sprites the code never names)
people_ = {
	liam:   { right: s_end_liam_right, up: s_end_liam_up, down: s_end_liam_down },
	jordan: { right: s_end_jordan_right, up: s_end_jordan_up, down: s_end_jordan_down },
	mavi:   { right: s_end_mavi_right, up: s_end_mavi_up, down: s_end_mavi_down }
};

/// The instance for a person, created on first use in this room
person = function(_who)
{
	with (o_end_person) if (who_ == _who) return id;
	return instance_create_layer(0, 0, "Instances", o_end_person, { sprites_: people_[$ _who], who_: _who });
};

/// Where a named marker is in this room
marker = function(_name)
{
	with (o_end_marker) if (mark_ == _name) return { x: x, y: y };
	show_debug_message("o_ending: no marker called " + _name + " in " + room_get_name(room));
	return { x: 0, y: 0 };
};

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

audio_stop_all();

next_step = function()
{
	step_ += 1;
	timer_ = 0;
	duration_ = 0;
	if (step_ >= array_length(steps_)) { step_ = array_length(steps_) - 1; return; }
	var _s = steps_[step_];

	if (variable_struct_exists(_s, "card"))		{ card_ = _s.card; duration_ = _s.time * global.one_second; fade_ = 1; }
	else if (variable_struct_exists(_s, "scene"))	{ card_ = ""; tv_ = "off"; plane_t_ = -1; waiting_for_room_ = true; room_goto(_s.scene); }
	else if (variable_struct_exists(_s, "fade_in"))	{ fade_from_ = 1; fade_to_ = 0; duration_ = _s.fade_in * global.one_second; }
	else if (variable_struct_exists(_s, "fade_out")){ fade_from_ = fade_; fade_to_ = 1; duration_ = _s.fade_out * global.one_second; }
	else if (variable_struct_exists(_s, "caption"))	{ caption_ = _s.caption; next_step(); }
	else if (variable_struct_exists(_s, "plane"))	{ plane_t_ = 0; duration_ = _s.plane * global.one_second; }
	else if (variable_struct_exists(_s, "place"))
	{
		var _p = person(_s.place), _m = marker(_s.at);
		_p.x = _m.x; _p.y = _m.y; _p.dir_ = _s.dir; _p.moving_ = false; _p.visible = true;
		next_step();
	}
	else if (variable_struct_exists(_s, "hide"))	{ person(_s.hide).visible = false; next_step(); }
	else if (variable_struct_exists(_s, "face"))	{ var _f = person(_s.face); _f.dir_ = _s.dir; _f.moving_ = false; next_step(); }
	else if (variable_struct_exists(_s, "walk"))	{ var _w = person(_s.walk); _w.moving_ = true; _w.visible = true; }
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
	else if (variable_struct_exists(_s, "door"))	{ with (o_end_door) image_index = _s.door; audio_play_sound(a_menu_move, 3, false); next_step(); }
	else if (variable_struct_exists(_s, "tv"))		{ tv_ = _s.tv; tv_timer_ = 0; next_step(); }
	else if (variable_struct_exists(_s, "music"))
	{
		audio_stop_all();
		if (_s.music != noone) audio_play_sound(_s.music, 10, true);
		next_step();
	}
	else if (variable_struct_exists(_s, "wait"))	{ duration_ = _s.wait * global.one_second; }
	else if (variable_struct_exists(_s, "finish"))	{ audio_stop_all(); persistent = false; room_transition(trans_type.fade, r_title, 0.02, 0); }
};
next_step();
