text = [];

switch (global.main_quest_active)
{
	case true:
		if not o_player.spoken_to_dad
		{
			if not o_player.spoken_to_granny
			{
				text[0] = "Hullo, Jordan!  Looking for your brother again?";
				text[1] = "You could ask Granny if she's seen him.";
			} else
			{
				text[0] = "Maybe he's playing in the Old Forest."
				text[1] = "Better be careful around there!"
			}
			
		} else
		{
			text[0] = "If you're going into the Old Forest, you'll need a weapon.";
			text[1] = "They say there's a magic sword hidden in the Southern desert.";
		}
		break;
		
	default:	
		if not o_player.spoken_to_granny
		{
			text[0] = "Hullo, Jordan! Come to help with the garden?";
			text[1] = "Don't forget to visit Granny before you go.";
		} else
		{
			text[0] = "Mind the flowers!";
		}
}

met_before = true;
o_player.spoken_to_granda = true;