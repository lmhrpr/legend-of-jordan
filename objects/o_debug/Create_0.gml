/// @description Testing menu: press F1 to jump to any screen of any room
// (Turn it off for the finished game by setting DEBUG_MENU to false in scr_macros.)
open_ = false;
rooms_ = [
	{ name: "Village", room: r_village },
	{ name: "Old Forest", room: r_old_forest },
	{ name: "Southern Desert", room: r_desert },
	{ name: "Canyon", room: r_canyon },
	{ name: "Canyon caves", room: r_canyon_caves },
	{ name: "Dungeon 1: Old Forest ruins", room: r_dungeon1 },
	{ name: "Dungeon 2: desert pyramid", room: r_dungeon2 },
	{ name: "Home", room: r_home },
	{ name: "Granny & Granda's", room: r_granny },
	{ name: "Post Office", room: r_post_office },
	{ name: "The ending", room: r_ending }
];
extras_ = ["Give sword, bombs and boots", "+1 key (in a dungeon)", "Full hearts", "Close"];
index_ = 0;
screen_ = 0;
