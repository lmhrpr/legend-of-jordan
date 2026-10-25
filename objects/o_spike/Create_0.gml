/// @description Spikes that pop up and down (made from spike tiles by spikes_make)
if (!variable_instance_exists(id, "start_up_")) start_up_ = true;
if (!variable_instance_exists(id, "sand_")) sand_ = false;
if (sand_) sprite_index = s_spikes_sand;		// sandstone, on sandy floors
image_speed = 0;
up_ = start_up_;
frame_ = up_ ? 3 : 0;		// 0 = holes, 1 = tips showing, 2 = half up, 3 = up
image_index = frame_;
depth = 60;			// on the floor, under everyone
