GET_INPUT = 0;
event_user(GET_INPUT);

// WASD as well as the arrow keys
keyboard_set_map(ord("W"), vk_up);
keyboard_set_map(ord("A"), vk_left);
keyboard_set_map(ord("S"), vk_down);
keyboard_set_map(ord("D"), vk_right);

// P pauses / opens the inventory (as well as Escape)
keyboard_set_map(ord("P"), vk_escape);
