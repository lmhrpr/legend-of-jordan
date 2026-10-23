/// @description Drop hidden treasure (or sometimes a random item)
if (hidden_item_ != noone)
{
	repeat (hidden_count_)
	{
		instance_create_layer(x + random_range(-6, 6), y - 6 + random_range(-3, 3), "Instances", hidden_item_);
	}
	play_sfx(a_found_item, 4);
}
else if (chance(0.1))
{
	var _item = choose(o_gem_pickup, o_heart_pickup);
	instance_create_layer(x, y - 6, "Instances", _item);
	play_sfx(a_item, 2);
}
