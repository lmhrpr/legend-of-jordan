text = [];

switch (global.main_quest_active)
{
	case true:
		if not o_player.spoken_to_dad
		{
			text[0] = "Hiya, Jordon! I'm sorry but I haven't seen Liam today.";
			text[1] = "Maybe he went to the Post Office to visit your Dad."
			text[2] = "Remember to come back and take a sweetie from the tin any time.";
			break;
		} else
		{
			text[0] = "Liam is lost in the Old Forest?"
			text[1] = "I've heard there are monsters in there!"
			text[2] = "Take a sweetie from the tin to recover your health.";
			break;
		}
		
	default:	
		text[0] = "Hiya, Jordon! How nice to see you!"
		text[1] = "Have a sweetie from the tin before you go.";
		o_player.spoken_to_granny = true;
}

met_before = true;