text = [];

switch (global.main_quest_active)
{
	case true:
		if not o_player.spoken_to_dad
		{
			text[0] = "Liam went to deliver a letter for me, but he never came back."
			text[1] = "He must have gotten lost in the Old Forest!"
			text[2] = "If you're going after him, you'll need a weapon."
			text[3] = "Save your progress here before you get into trouble!"
			o_player.spoken_to_dad = true;
			break;
		} else
		{		
			text[0] = "They say there's a magic sword hidden in the Southern desert."
			text[1] = "Save your progress here before you get into trouble!"
			break;
		}
		
	default:	
		text[0] = "Hello, son. What are you doing out here?";
		text[1] = "Go and tell Mum I'll be home soon for tea!"
}