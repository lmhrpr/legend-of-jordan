/// @description Draw the transition
draw_set_colour(c_black);

switch (type_)
{
	case trans_type.slide:
		if (closing_)
		{
			draw_rectangle(0, HUD_H, VIEW_W * progress_, GUI_H, false);
		}
		else
		{
			draw_rectangle(VIEW_W * (1 - progress_), HUD_H, VIEW_W, GUI_H, false);
		}
		break;

	case trans_type.iris:
		// Centre the circle on Jordan (view coordinates; the surface is drawn below the toolbar)
		var _cx = VIEW_W / 2;
		var _cy = VIEW_H / 2;
		if (instance_exists(o_player))
		{
			_cx = o_player.x - camera_get_view_x(view_camera[0]);
			_cy = o_player.y - 12 - camera_get_view_y(view_camera[0]);
		}
		var _max_radius = max(point_distance(_cx, _cy, 0, 0), point_distance(_cx, _cy, VIEW_W, 0),
							  point_distance(_cx, _cy, 0, VIEW_H), point_distance(_cx, _cy, VIEW_W, VIEW_H));
		// Ease so the circle slows down as it closes in on him
		var _t = 1 - progress_;
		var _radius = _max_radius * _t * _t;

		if (!surface_exists(surface_)) surface_ = surface_create(VIEW_W, VIEW_H);
		surface_set_target(surface_);
		draw_clear_alpha(c_black, 1);
		if (_radius >= 1)
		{
			gpu_set_blendmode(bm_subtract);
			draw_set_circle_precision(64);
			draw_set_colour(c_white);
			draw_circle(_cx, _cy, _radius, false);
			gpu_set_blendmode(bm_normal);
		}
		surface_reset_target();
		draw_surface(surface_, 0, HUD_H);
		break;

	default:
		draw_set_alpha(progress_);
		draw_rectangle(0, (room == r_title) ? 0 : HUD_H, VIEW_W, GUI_H, false);
		draw_set_alpha(1);
		break;
}
draw_set_colour(c_white);
