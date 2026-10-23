/// @description Drop hidden treasure (or sometimes a random item)
if (hidden_item_ != noone)
{
	repeat (hidden_count_)
	{
		instance_create_layer(x + 8 + random_range(-5, 5), y + 8 + random_range(-3, 3), "Instances", hidden_item_);
	}
	play_sfx(a_item, 4);
}
else if (chance(0.1))
{
	var _item = choose(o_gem_pickup, o_heart_pickup);
	instance_create_layer(x + 8, y + 8, "Instances", _item);
	play_sfx(a_item, 2);
}
