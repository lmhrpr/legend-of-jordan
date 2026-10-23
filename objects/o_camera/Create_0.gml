/// @description Initialise

target_ = o_player;
camera_ = view_camera[0];
view_x_ = camera_get_view_x(camera_);
view_y_ = camera_get_view_y(camera_);

// Map grid is 1-based: screen 1 covers 0 to VIEW_W
map_grid_x_ = 1;
map_grid_y_ = 1;
if (instance_exists(global.player_start_position))
{
	map_grid_x_ = floor(global.player_start_position.x / VIEW_W) + 1;
	map_grid_y_ = floor(global.player_start_position.y / VIEW_H) + 1;
}
left_edge_ = 0;
right_edge_ = VIEW_W;
top_edge_ = 0;
bottom_edge_ = VIEW_H;

// Amount by which the game is scaled up to fit the view port (window)
scale_ = view_wport[0] / VIEW_W;