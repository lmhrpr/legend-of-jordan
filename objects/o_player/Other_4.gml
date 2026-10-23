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