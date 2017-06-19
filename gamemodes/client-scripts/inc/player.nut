player <- {};

function player::registerEnd(){
	itemSave();
	dialog.destroy();
	setPlayerPosition(heroId, -871, -571, 409);
	Chat.print(194, 178, 128, " ");
	Chat.print(194, 178, 128, "Pomyœlnie zarejestrowano now¹ postaæ. Mi³ej gry.");
	Chat.print(194, 178, 128, "Udaj siê do garnizonu stra¿y, by uzyskaæ obywatelstwo miejskie.");
}

function player::work(){
  setFreeze(true);
  playAni(heroId, "T_PLUNDER");
}
