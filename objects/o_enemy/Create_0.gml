/// @description Initialise enemy

initialise_movement_entity(1, 0.5, o_solid);
initialise_hurtbox_entity();

image_speed = 0;

starting_state_ = noone;
state_ = starting_state_;

enum enemy
{
	locked,
	hit
};

// Screen boundary box so enemies don't cross to another room
map_grid_x_ = floor(x / VIEW_W);
map_grid_y_ = floor(y / VIEW_H);

boundary_left_ = (map_grid_x_ * VIEW_W) + 12;
boundary_right_ = (map_grid_x_ * VIEW_W) + VIEW_W - 12;
boundary_top_ = (map_grid_y_ * VIEW_H) + 20;
boundary_bottom_ = (map_grid_y_ * VIEW_H) + VIEW_H - 6;

image_speed = 0;