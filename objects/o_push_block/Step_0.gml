/// @description Slide when pushed (one tile), if there's room
depth = -(y + sprite_height);

if (moving_ > 0)
{
	x += move_dx_;
	y += move_dy_;
	moving_ -= 1;
	exit;
}

if (!instance_exists(o_player) or instance_exists(o_textbox) or instance_exists(o_transition)) { push_t_ = 0; exit; }

// Which way is Jordan pushing? (straight up, down, left or right only)
var _p = o_player;
var _dir = -1;
if (_p.state_ == player.move)
{
	var _xi = o_input.right_ - o_input.left_;
	var _yi = o_input.down_ - o_input.up_;
	if (_xi != 0 and _yi == 0) _dir = (_xi > 0) ? 0 : 180;
	if (_yi != 0 and _xi == 0) _dir = (_yi > 0) ? 270 : 90;
}

// Up against this block, and roughly lined up with it?
var _pushing = false;
if (_dir != -1)
{
	var _dx = lengthdir_x(2, _dir);
	var _dy = lengthdir_y(2, _dir);
	with (_p) _pushing = place_meeting(x + _dx, y + _dy, other);
	if (_dir == 0 or _dir == 180) _pushing = _pushing and abs((_p.y - 3) - (y + 8)) <= 6;
	else _pushing = _pushing and abs(_p.x - (x + 8)) <= 6;
}
if (!_pushing) { push_t_ = 0; exit; }

push_t_ += 1;
if (!inventory_has_item(o_gloves_item))
{
	if (push_t_ > global.one_second * 0.6 and !told_)
	{
		told_ = true;
		global.active_textbox = create_textbox(["It won't budge. Too heavy to shift with bare hands."], noone, false);
	}
	exit;
}
if (push_t_ < global.one_second * 0.4) exit;

// Room on the other side? (walls, other blocks, pits, enemies, and the edge of the screen)
var _tx = x + lengthdir_x(16, _dir);
var _ty = y + lengthdir_y(16, _dir);
var _sx = floor((x + 8) / VIEW_W) * VIEW_W;
var _sy = floor((y + 8) / VIEW_H) * VIEW_H;
var _clear = _tx >= _sx and _ty >= _sy and _tx + 16 <= _sx + VIEW_W and _ty + 16 <= _sy + VIEW_H
	and !place_meeting(_tx, _ty, [o_solid, o_ledge, o_gap, o_enemy, o_player]);
push_t_ = 0;
if (_clear)
{
	moving_ = 16;
	move_dx_ = lengthdir_x(1, _dir);
	move_dy_ = lengthdir_y(1, _dir);
	play_sfx(a_set_bomb, 6);
}
