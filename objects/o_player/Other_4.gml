// Never arrive mid-jump (a jump that ended in a doorway carries on otherwise)
if (state_ == player.evade or jump_t_ > 0)
{
	jump_t_ = 0;
	jump_z_ = 0;
	speed_ = 0;
	state_ = player.move;
}

// Coming back out of a dungeon: start just below its entrance
var _off_stairs = false;
if (global.arrive_at_ != "")
{
	with (o_dungeon_entrance) if (dungeon_ == global.arrive_at_) { global.player_start_position = id; _off_stairs = true; }
	global.arrive_at_ = "";
}

if instance_exists(global.player_start_position)
{
	if instance_exists(o_player)
	{
		o_player.persistent = false;
		o_player.x = global.player_start_position.x;
		o_player.y = global.player_start_position.y + (_off_stairs ? 30 : 0);	// step off the entrance
		o_player.layer = layer_get_id("Instances");
		o_player.visible = true;
		o_player.invincible_ = false;
		
		if (global.respawned)
		{
			global.respawned = false;
			alarm[3] = global.one_second * 0.75;
		}
		
		if global.first_play
		{
			alarm[2] = global.one_second * 5;
		}
	}
	else
	{
		var _start_x  = global.player_start_position.x;
		var _start_y  = global.player_start_position.y;
		instance_create_layer(_start_x, _start_y, "Instances", o_player);
	}
	
	global.player_start_position = noone;
}

// Arriving from the F1 test menu: the middle of the chosen screen, or the nearest clear spot
if (is_struct(global.debug_target))
{
	var _tx = global.debug_target.x, _ty = global.debug_target.y;
	global.debug_target = undefined;
	with (o_player)
	{
		persistent = false;
		layer = layer_get_id("Instances");
		visible = true;
		var _found = false;
		for (var _d = 0; _d < 80 and !_found; _d += 4)
		{
			for (var _a = 0; _a < 360 and !_found; _a += 15)
			{
				var _x = _tx + lengthdir_x(_d, _a), _y = _ty + lengthdir_y(_d, _a);
				if (!place_meeting(_x, _y, [o_solid, o_gap])) { x = _x; y = _y; _found = true; }
			}
		}
		if (!_found) { x = _tx; y = _ty; }
	}
	if (instance_exists(o_camera)) camera_snap();
}
