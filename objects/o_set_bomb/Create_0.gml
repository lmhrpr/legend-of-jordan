/// @description Light the fuse, and fly to where it was thrown
// Whoever throws it can set (in the creation struct): target_x_, target_y_, and hurts_player_ = false
if (!variable_instance_exists(id, "target_x_")) target_x_ = x;
if (!variable_instance_exists(id, "target_y_")) target_y_ = y;
if (!variable_instance_exists(id, "hurts_player_")) hurts_player_ = true;
if (!variable_instance_exists(id, "stop_at_walls_")) stop_at_walls_ = true;	// lands against a wall instead of sailing over it
start_x_ = x;
start_y_ = y;
// Flight time grows with the distance (about 18 steps for Jordan's 32px throw)
flight_time_ = max(1, round(point_distance(x, y, target_x_, target_y_) * 0.55));
flight_ = 0;
z_ = 0;
depth = -y;
alarm[0] = global.one_second * 1.5;
image_speed = 0;
