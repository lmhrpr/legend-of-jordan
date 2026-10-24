/// @description Camera movement

if (!instance_exists(target_)) exit;

left_edge_ = view_x_;
right_edge_ = VIEW_W + (VIEW_W * (map_grid_x_ - 1));

if (target_.x > right_edge_)
{
	map_grid_x_ += 1;
} 
else if (target_.x < left_edge_)
{
	map_grid_x_ -= 1;
}

top_edge_ = view_y_;
bottom_edge_ = VIEW_H + (VIEW_H * (map_grid_y_ - 1));

// (Up and down go by Jordan's middle, not his feet, so the screen changes as he crosses)
var _target_y = target_.y - 8;
if (_target_y > bottom_edge_)
{
	map_grid_y_ += 1;
} 
else if (_target_y < top_edge_)
{
	map_grid_y_ -= 1;
}

x = lerp(x, VIEW_W * (map_grid_x_ - 1), 0.2);
y = lerp(y, VIEW_H * (map_grid_y_ - 1), 0.2);
if (abs(x - VIEW_W * (map_grid_x_ - 1)) < 0.5) x = VIEW_W * (map_grid_x_ - 1);
if (abs(y - VIEW_H * (map_grid_y_ - 1)) < 0.5) y = VIEW_H * (map_grid_y_ - 1);

camera_set_view_pos(camera_, x, y);

view_x_ = camera_get_view_x(camera_);
view_y_ = camera_get_view_y(camera_);

/*
// Move camera to player
x = lerp(x, target_.x, 0.1);
y = lerp(y, target_.y - 8, 0.1);
*/

/*// Clamp camera to room (if following player)
x = clamp(x, view_width_/2, room_width - view_width_/2);
y = clamp(y, view_height_/2, room_height - view_height_/2);


// Round to scale sub-pixel values, to prevent judder
x = round_n(x, 1 / scale_);
y = round_n(y, 1 / scale_);

// Set view to camera position
camera_set_view_pos(view_camera[0], x - (view_width_ / 2), y - (view_height_ / 2))
*/