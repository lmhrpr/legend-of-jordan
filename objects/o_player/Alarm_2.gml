/// @description Wake up alarm

var _speaker = instance_create_layer(x, y, "Instances", o_npc);

with (_speaker)
{
	name = "";
}

global.active_textbox = create_textbox(["...","Wake up, Jordan!"], _speaker, false);

instance_destroy(_speaker);