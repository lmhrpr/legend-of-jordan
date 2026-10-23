/// @description Bars across a doorway
// Set in the instance creation code:
//   flag_ = "d1_switch";   the bars lift when this flag is set
//   shut_in_ = true;       (optional) the bars only drop once Jordan is inside the room above,
//                          and stay down until flag_ is set (for boss rooms)
//   flip_ = true;          (optional) the doorway is in a bottom wall
flag_ = "";
shut_in_ = false;
flip_ = false;
closed_ = true;
first_step_ = true;		// no clank when the room loads
sprite_index = -1;
mask_index = s_door_bars;
depth = -y;
