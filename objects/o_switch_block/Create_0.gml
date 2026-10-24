/// @description A block that rumbles away when its floor switch is pressed (and stays gone)
// Set in the instance creation code:  flag_ = "canyon_tunnel";
event_inherited();
flag_ = "";
quiet_ = true;		// already open when the room starts: just not there
