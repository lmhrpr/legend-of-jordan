/// Game-wide constants

#macro VIEW_W 320
#macro VIEW_H 180

// The toolbar along the top. The world view sits underneath it, so nothing is covered.
#macro DEBUG_MENU true		// F1 test menu (set false for the finished game)
#macro HUD_H 26
#macro GUI_H (VIEW_H + HUD_H)

#macro SAVE_FILE "legend_of_jordan.sav"

// Room transition styles
enum trans_type
{
	slide,
	fade,
	iris		// circle closes on Jordan, then opens on him in the new room
}
