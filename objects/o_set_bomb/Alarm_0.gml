/// @description Explode
create_animation_effect(s_explosion_effect, x, y + 8, 1, false);
var _targets = [o_enemy, o_grass, o_bush, o_old_tree1, o_cracked_wall, o_rock_cracked, o_dungeon_entrance, o_ruin_entrance];
if (hurts_player_) array_push(_targets, o_player);
create_hitbox(s_bomb_hitbox, x, y, 0, 3, _targets, 2, 6);
play_sfx(a_explosion, 9);
instance_destroy();
