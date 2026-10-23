/// @description Save the game
save_game();
global.player_health = global.player_max_health;
play_sfx(a_save, 6);
text = ["You post a letter to yourself...", "Progress saved! Hearts restored."];
