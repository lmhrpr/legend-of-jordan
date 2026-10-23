/// @description Splash screen, then title
timer_ = 0;
phase_ = 0;				// 0 = LiamFilm Games splash, 1 = title
menu_index_ = 0;
has_save_ = save_exists();
menu_ = has_save_ ? ["Continue", "New Game"] : ["New Game"];
image_speed = 0;
title_frame_ = 0;
