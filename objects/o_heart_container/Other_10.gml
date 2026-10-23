/// @description Picked up
global.player_max_health += 1;
global.player_health = global.player_max_health;
flag_set(flag_);
instance_destroy();
player_found_item(s_heart_container, [
	"You got a Heart Container!",
	"Jordan can take one more heart of damage."
]);
