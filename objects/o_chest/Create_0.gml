/// @description A treasure chest
// Set in the instance creation code:
//   flag_ = "d1_bombs";          remembers that it's been opened
//   item_ = o_bomb_item;         what's inside
//   lines_ = ["You found ..."];  what Jordan reads
//   appear_flag_ = "d1_boss";    (optional) the chest only appears once this flag is set
flag_ = "";
item_ = noone;
lines_ = [];
appear_flag_ = "";
shown_ = true;
name = "";
text[0] = "";
voice = a_text;
speaker = id;
image_speed = 0;
depth = -y;
