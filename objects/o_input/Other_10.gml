/// @description Get input
//
// Keyboard:  Z = primary item/attack   X = secondary item/attack
//            Enter = talk / read / next   P or Esc = pause & inventory
// Gamepad:   B = primary   X = secondary   A = talk   Start = pause

right_ = keyboard_check(vk_right) or gamepad_button_check(0,gp_padr);
left_ = keyboard_check(vk_left) or gamepad_button_check(0,gp_padl);
up_ = keyboard_check(vk_up) or gamepad_button_check(0,gp_padu);
down_ = keyboard_check(vk_down) or gamepad_button_check(0,gp_padd);

right_pressed_ = keyboard_check_pressed(vk_right) or gamepad_button_check_pressed(0,gp_padr);
left_pressed_ = keyboard_check_pressed(vk_left) or gamepad_button_check_pressed(0,gp_padl);
up_pressed_ = keyboard_check_pressed(vk_up) or gamepad_button_check_pressed(0,gp_padu);
down_pressed_ = keyboard_check_pressed(vk_down) or gamepad_button_check_pressed(0,gp_padd);

// Attack / use equipped items
action_one_pressed_ = keyboard_check_pressed(ord("Z")) or gamepad_button_check_pressed(0,gp_face2);
action_two_pressed_ = keyboard_check_pressed(ord("X")) or gamepad_button_check_pressed(0,gp_face3);

// Talk, read signs, turn pages, choose menu options
interact_pressed_ = keyboard_check_pressed(vk_enter) or gamepad_button_check_pressed(0,gp_face1);

pause_pressed_ = keyboard_check_pressed(vk_escape) or gamepad_button_check_pressed(0,gp_start) or gamepad_button_check_pressed(0,gp_face4);
