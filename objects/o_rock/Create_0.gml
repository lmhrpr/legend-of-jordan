/// @description A solid rock: place it on the 16px grid like a tile
// Origin is the top-left corner, so it snaps to the grid in the room editor.
// Sort by its bottom edge so Jordan walks in front of it from below, behind it from above.
depth = -(y + sprite_height);
