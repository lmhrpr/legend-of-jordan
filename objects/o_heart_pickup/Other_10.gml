instance_destroy();
global.player_health = min(global.player_health + 1, global.player_max_health);
play_sfx(a_collect_item, 2);