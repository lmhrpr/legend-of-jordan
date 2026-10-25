/// @description Can't be hurt under the sand; above it, takes the hit and dives back under
if (scorp_underground()) exit;
event_inherited();
speed_ = min(speed_, 1);		// too heavy to knock far
starting_state_ = scorp.burrow;
