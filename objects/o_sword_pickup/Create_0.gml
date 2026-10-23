/// @description The Magic Sword, waiting in the desert
if (inventory_has_item(o_sword_item))
{
	instance_destroy();
	exit;
}
depth = -y;
start_y_ = y;
image_speed = 0;
