text = [];
	o_player.spoken_to_mum = true;

switch (global.main_quest_active)
{
	case true:
		text[0] = "Have you found Liam yet?"
		text[1] = "Oh, I hope he didn't go into the Old Forest!"
		break;
		
	default:	
		text[0] = "Oh Jordan, where have you been?  Liam hasn't come home yet!";
		text[1] = "Please will you find him before it gets dark?";
		text[2] = "And stay out of the Old Forest.  It's dangerous!";
		global.main_quest_active = true;
		o_player.spoken_to_granny = false;
}