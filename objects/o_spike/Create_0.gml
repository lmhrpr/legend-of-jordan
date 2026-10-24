/// @description Spikes that pop up and down (made from spike tiles by spikes_make)
if (!variable_instance_exists(id, "start_up_")) start_up_ = true;
image_speed = 0;
up_ = start_up_;
depth = 60;			// on the floor, under everyone
