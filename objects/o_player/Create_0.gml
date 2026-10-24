/// @description Initialise player object

initialise_movement_entity(0.5, 1, [o_solid, o_gap]);	// gaps only stop him on foot (he can jump them)
initialise_hurtbox_entity();

global.player_health = global.player_max_health;
global.player_stamina = global.player_max_stamina;

// Collide using Jordan's feet, whatever animation is playing
mask_index = s_jordan_run_down_basic;
item_found_sprite_ = noone;

image_speed = 0;
acceleration_ = 0.5;
max_speed_ = 1.5;
facing_direction_ = dir.right;
roll_direction_ = 0;
roll_speed_ = 2;
// Jumping (the Winged Boots): about 40px in 22 steps, up to 12px off the ground
jump_time_ = 22;
jump_distance_ = 40;
jump_height_ = 12;
jump_t_ = 0;
auto_walk_ = undefined;		// walking himself through a dungeon doorway (see o_doorway)
jump_z_ = 0;
jump_from_x_ = x;
jump_from_y_ = y;

// Text boxes
name = "Jordan";
voice = a_text;
interact_radius = 28;
global.active_textbox = noone;

// People Jordan has spoken to
spoken_to_mum = false;
spoken_to_dad = false;
spoken_to_granny = false;
spoken_to_granda = false;

// Restore from a saved game
if (is_struct(global.loaded_flags))
{
	spoken_to_mum = global.loaded_flags.spoken_to_mum;
	spoken_to_dad = global.loaded_flags.spoken_to_dad;
	spoken_to_granny = global.loaded_flags.spoken_to_granny;
	spoken_to_granda = global.loaded_flags.spoken_to_granda;
	global.loaded_flags = undefined;
}

enum player 
{ 
	move,
	sword,
	evade,
	bomb,
	bow,
	found_item,
	hit,
	locked,
	sleep,
	wake
};

enum dir 
{ 
	right, 
	up, 
	left, 
	down 
};

if (global.first_play)
{
	starting_state_ = player.sleep;
	alarm[2] = global.one_second * 5;
} else
{
	starting_state_ = player.move;
}
state_ = starting_state_;

// Sprite lookup table
sprite[player.move, dir.right] = s_jordan_run_right_basic;
sprite[player.move, dir.up] = s_jordan_run_up_basic;
sprite[player.move, dir.left] = s_jordan_run_right_basic;
sprite[player.move, dir.down] = s_jordan_run_down_basic;

sprite[player.sword, dir.right] = s_jordan_sword_right_basic;
sprite[player.sword, dir.up] = s_jordan_sword_up_basic;
sprite[player.sword, dir.left] = s_jordan_sword_right_basic;
sprite[player.sword, dir.down] = s_jordan_sword_down_basic;

sprite[player.evade, dir.right] = s_jordan_run_right_basic;
sprite[player.evade, dir.up] = s_jordan_run_up_basic;
sprite[player.evade, dir.left] = s_jordan_run_right_basic;
sprite[player.evade, dir.down] = s_jordan_run_down_basic;

sprite[player.bomb, dir.right] = s_jordan_run_right_basic;
sprite[player.bomb, dir.up] = s_jordan_run_up_basic;
sprite[player.bomb, dir.left] = s_jordan_run_right_basic;
sprite[player.bomb, dir.down] = s_jordan_run_down_basic;

sprite[player.bow, dir.right] = s_jordan_run_right_basic;
sprite[player.bow, dir.up] = s_jordan_run_up_basic;
sprite[player.bow, dir.left] = s_jordan_run_right_basic;
sprite[player.bow, dir.down] = s_jordan_run_down_basic;

sprite[player.found_item, dir.right] = s_jordan_run_down_basic;
sprite[player.found_item, dir.up] = s_jordan_run_down_basic;
sprite[player.found_item, dir.left] = s_jordan_run_down_basic;
sprite[player.found_item, dir.down] = s_jordan_run_down_basic;

sprite[player.hit, dir.right] = s_jordan_run_right_basic;
sprite[player.hit, dir.up] = s_jordan_run_up_basic;
sprite[player.hit, dir.left] = s_jordan_run_right_basic;
sprite[player.hit, dir.down] = s_jordan_run_down_basic;

sprite[player.locked, dir.right] = s_jordan_run_right_basic;
sprite[player.locked, dir.up] = s_jordan_run_up_basic;
sprite[player.locked, dir.left] = s_jordan_run_right_basic;
sprite[player.locked, dir.down] = s_jordan_run_down_basic;

sprite[player.sleep, dir.right] = s_jordan_sleep;
sprite[player.sleep, dir.up] = s_jordan_sleep;
sprite[player.sleep, dir.left] = s_jordan_sleep;
sprite[player.sleep, dir.down] = s_jordan_sleep;

sprite[player.wake, dir.right] = s_jordan_wake;
sprite[player.wake, dir.up] = s_jordan_wake;
sprite[player.wake, dir.left] = s_jordan_wake;
sprite[player.wake, dir.down] = s_jordan_wake;