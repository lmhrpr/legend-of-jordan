/// @description Draw the transition
draw_set_colour(c_black);

switch (type_)
{
	case trans_type.slide:
		if (closing_)
		{
			draw_rectangle(0, 0, VIEW_W * progress_, VIEW_H, false);
		}
		else
		{
			draw_rectangle(VIEW_W * (1 - progress_), 0, VIEW_W, VIEW_H, false);
		}
		break;

	default:
		draw_set_alpha(progress_);
		draw_rectangle(0, 0, VIEW_W, VIEW_H, false);
		draw_set_alpha(1);
		break;
}
draw_set_colour(c_white);
