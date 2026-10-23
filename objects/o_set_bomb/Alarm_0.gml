/// @description Explode
create_animation_effect(s_explosion_effect, x, y + 8, 1, false);
create_hitbox(s_bomb_hitbox, x, y, 0, 3, [o_enemy, o_grass, o_bush, o_old_tree1, o_player], 2, 6);
play_sfx(a_explosion, 9);
instance_destroy();
