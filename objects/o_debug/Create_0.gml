/// @description Testing menu: press F1 to jump to any screen of any room
// (Turn it off for the finished game by setting DEBUG_MENU to false in scr_macros.)
open_ = false;
// cols/rows: how many screens across and down
rooms_ = [
	{ name: "Village", room: r_village , cols: 3, rows: 3 },
	{ name: "Old Forest", room: r_old_forest , cols: 3, rows: 3 },
	{ name: "Southern Desert", room: r_desert , cols: 3, rows: 3 },
	{ name: "Canyon", room: r_canyon , cols: 3, rows: 3 },
	{ name: "Canyon caves", room: r_canyon_caves , cols: 3, rows: 1, first_row: 2 },	// (the caves are the bottom row)
	{ name: "Dungeon 1: Old Forest ruins", room: r_dungeon1 , cols: 4, rows: 3 },
	{ name: "Dungeon 2: desert pyramid", room: r_dungeon2 , cols: 4, rows: 3 },
	{ name: "Home", room: r_home , cols: 1, rows: 1 },
	{ name: "Granny & Granda's", room: r_granny , cols: 1, rows: 1 },
	{ name: "Post Office", room: r_post_office , cols: 1, rows: 1 },
	{ name: "The ending", room: r_ending , cols: 1, rows: 1 }
];
extras_ = ["Give sword, bombs and boots", "+1 key (in a dungeon)", "Full hearts", "Close"];
index_ = 0;
screen_ = 0;
