depth = -y;

if (health_ <= 0)
{
	instance_destroy();
}

// Only move when on the screen Jordan is looking at (like Zelda)
var _on_screen = true;
if (instance_exists(o_camera))
{
	_on_screen = (o_camera.map_grid_x_ - 1 == map_grid_x_) and (o_camera.map_grid_y_ - 1 == map_grid_y_);
}

// Freeze during conversations and room transitions
if (state_ != noone and _on_screen and !instance_exists(o_transition) and !instance_exists(o_textbox))
{
	event_user(state_);
}