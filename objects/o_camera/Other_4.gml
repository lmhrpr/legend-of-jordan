/// @description Start camera on the screen Jordan arrives at

var _target = noone;
if (instance_exists(global.player_start_position)) _target = global.player_start_position;
else if (instance_exists(target_)) _target = target_;

if (_target != noone)
{
	map_grid_x_ = floor(_target.x / VIEW_W) + 1;
	map_grid_y_ = floor(_target.y / VIEW_H) + 1;
}

x = VIEW_W * (map_grid_x_ - 1);
y = VIEW_H * (map_grid_y_ - 1);
camera_set_view_pos(camera_, x, y);
view_x_ = x;
view_y_ = y;
