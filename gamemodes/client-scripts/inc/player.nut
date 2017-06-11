player <- {};

function player::registerEnd(){
	dialog.destroy();
	setPlayerPosition(heroId, -871, -571, 409);
	Chat.print(194, 178, 128, "Pomyœlnie zarejestrowano now¹ postaæ. Mi³ej gry.");
	Chat.print(194, 178, 128, " ");
	Chat.print(194, 178, 128, "Pod /help znajdziesz podstawowe komendy.");
}

function player::work(){
  setFreeze(true);
  playAni(heroId, "T_PLUNDER");
}
