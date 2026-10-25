if (!can_pick_up_) exit;
if (other.jump_t_ > 0 or other.fall_t_ > 0) exit;		// mid-jump: picked up once he lands
event_user(PICKED_UP);