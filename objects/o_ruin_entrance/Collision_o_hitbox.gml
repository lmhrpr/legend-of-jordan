/// @description A bomb blows the slab off
if (global.met_keeper or !variable_instance_exists(other, "targets_")) exit;
var _bomb = false;
for (var _i = 0; _i < array_length(other.targets_); _i++) if (other.targets_[_i] == o_ruin_entrance) _bomb = true;
if (!_bomb) exit;
global.met_keeper = true;
create_animation_effect(s_death_effect, x + 8, y + 8, 0.6, false);
