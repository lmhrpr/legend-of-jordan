var _spr = sprites_[$ (dir_ == "left") ? "right" : dir_];
draw_sprite_ext(_spr, floor(frame_) mod sprite_get_number(_spr), x, y, (dir_ == "left") ? -1 : 1, 1, 0, c_white, 1);
