drunk <- {
  active = null,
  letter = null,
  count = null
};
local drunkTimer, drunkCount, drunkLetters = ["r", "e", "q", "u", "i", "e", "m"];

local function drunkTimerFunction(){
  if(drunkCount<drunkLetters.len()){
    gameDraw.setText(drunkLetters[drunkCount]);
    drunk.letter = drunkLetters[drunkCount];
    drunk.active = true;
    drunkCount++;
  }else{
    killTimer(drunkTimer);
    if(drunk.count==drunkLetters.len()){
      Chat.print(194, 178, 128, "Uda³o siê wygraæ z pijakiem 2 szt. z³.");
      callServerFunc("drunk", heroId, true);
    }
    else{
      Chat.print(194, 178, 128, "Nie uda³o siê wygraæ. Tracisz 2 szt. z³.");
      callServerFunc("drunk", heroId, false);
    }
    gameDraw.destroy();
    setFreeze(false);
  }
}

function drunk::start(){
  setFreeze(true);
  Chat.print(194, 178, 128, "Powodzenia.");
  gameDraw.create("Klikaj pojawiaj¹ce siê na ekranie litery, by wygraæ");
  drunkCount = 0;
  drunk.count = 0;
  drunk.active = false;
  drunkTimer = setTimer(drunkTimerFunction, 1000, 2000);
}
