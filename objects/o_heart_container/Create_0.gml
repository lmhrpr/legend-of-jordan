/// @description +1 heart (dropped by a boss, which sets flag_)
event_inherited();
if (!variable_instance_exists(id, "flag_")) flag_ = "";
