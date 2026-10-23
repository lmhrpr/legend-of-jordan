///@description bat.attack
if not instance_exists(o_player) { state_ = bat.move; exit; }

if distance_to_object(o_player) > range_ 
{
	state_ = bat.move;
}

// Face direction of movement
set_sprite_facing();

var _direction = point_direction(x, y, o_player.x, o_player.y);
add_movement_maxspeed(_direction, 0.123, 0.75);
move_movement_entity(true);

var _life = 1;
var _damage = 1;
var _knockback = 5;

var _player = instance_place(x, y, o_player);
if _player
{
	create_hitbox(s_porcupine_hitbox, x, y, 0, _life, [o_player], _damage, _knockback);
}
