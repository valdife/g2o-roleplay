work <- {};
local workProgress, workTimer;

local function workTimerFunction(){
  if(isKeyPressed(KEY_LCONTROL) && workProgress<100) workProgress++;
  else if(workProgress>0 && workProgress<100) workProgress--;
  else{
    if(workProgress>=100) callServerFunc("work", heroId, true);
    else callServerFunc("work", heroId, false);
    killTimer(workTimer);
    gameDraw.destroy();
    setFreeze(false);
  }
  gameDraw.setText(workProgress + "%");
}

function work::start(){
  setFreeze(true);
  workProgress = 50;
  gameDraw.create("50%");
  workTimer = setTimer(workTimerFunction, 200, 0);
}
