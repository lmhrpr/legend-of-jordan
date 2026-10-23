/// @description Play this area's music

// Let the item fanfare finish first
if (audio_is_playing(a_found_item)) { exit; }

if room == r_title 
{
	if not audio_is_playing(track_)
	{
		audio_play_sound(track_, 10, true); 
	}
}
else if instance_exists(o_camera) and o_camera.map_grid_x_ == grid_x_ and o_camera.map_grid_y_ == grid_y_
{
	if not audio_is_playing(track_)
	{
		audio_stop_all();
		audio_play_sound(track_, 10, true);
	}
} 