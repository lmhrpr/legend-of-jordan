/// @description A cracked patch of cliff face hiding a cave: bomb it open, then walk in
// Put it over a cave-mouth tile (237) in a cliff face. Set in the instance creation code:
//   room_ = r_canyon_caves;  start_ = i_cave1_in;  flag_ = "canyon_cave1";
room_ = noone;
start_ = noone;
flag_ = "";
initialise_hurtbox_entity();
image_speed = 0;
depth = -y;
