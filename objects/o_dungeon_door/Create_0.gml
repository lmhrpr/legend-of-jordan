/// @description A doorway between two dungeon rooms
// Walk into it and the screen fades while Jordan steps through to the next room.
// Set in the instance creation code:
//   dir_ = 90;                 the way Jordan goes through it (0 right, 90 up, 180 left, 270 down)
//   dest_x_ = ...; dest_y_ = ...;   where Jordan comes out, just inside the next room
dir_ = 90;
dest_x_ = x;
dest_y_ = y;
image_speed = 0;
depth = -(y - 8) + 1;	// just under any bars or locked door in the same doorway
