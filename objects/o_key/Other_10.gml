/// @description Picked up
keys_add(1);
flag_set(flag_);
instance_destroy();
player_found_item(s_key, [
	"You found a small key!",
	"It must open a door somewhere in these ruins."
]);
