work <- {};
local workDraw = Draw(0, 0, "0%"), workProgress = 50, workTimer;
workDraw.font = "FONT_OLD_20_WHITE_HI.TGA";

local function workTimerFunction(){
  if(isKeyPressed(KEY_LCONTROL) && workProgress<100) workProgress++;
  else if(workProgress>0 && workProgress<100) workProgress--;
  else{
    if(workProgress>=100) callServerFunc("work.end", heroId, true);
    else callServerFunc("work.end", heroId, false);
    killTimer(workTimer);
    workProgress = 50;
    workDraw.visible = false;
    setFreeze(false);
  }
  workDraw.text = workProgress + "%";
}

function work::start(){
  setFreeze(true);
  workDraw.setPositionPx((getResolution().x/2)-(workDraw.widthPx/2), getResolution().y/2);
  workDraw.visible = true;
  workTimer = setTimer(workTimerFunction, 200, 0);
}
