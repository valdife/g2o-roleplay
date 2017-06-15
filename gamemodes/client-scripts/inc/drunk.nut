drunk <- {
  active = null,
  letter = null,
  count = null
};
local drunkTimer, drunkCount, drunkLetters = [];

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
    drunkLetters.clear();
    gameDraw.destroy();
    setFreeze(false);
  }
}

local function drunkSort(){
  local letters = ["a", "b", "c", "q", "w", "e", "j", "k", "l", "x", "y", "z"];
  for(local i = 0; i<6; ++i){
    local random = rand() % letters.len();
    drunkLetters.push(letters[random]);
    letters.remove(random);
  }
}

function drunk::start(){
  setFreeze(true);
  drunkSort();
  drunkCount = 0;
  drunk.count = 0;
  drunk.active = false;
  Chat.print(194, 178, 128, "Powodzenia.");
  gameDraw.create("Klikaj pojawiaj¹ce siê na ekranie litery, by wygraæ");
  drunkTimer = setTimer(drunkTimerFunction, 1000, 2000);
}
