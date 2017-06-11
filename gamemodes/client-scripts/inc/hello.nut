local hello = {
  timer = null
  draw = Draw(0, 0, "Witaj na serwerze!")
  counter = 0
};

hello.draw.font = "FONT_OLD_20_WHITE_HI.TGA";
hello.draw.setColor(194, 178, 128);

local function helloAlpha(){
  if(hello.draw.getAlpha()==100){
    if(hello.counter==25){
      killTimer(hello.timer);
      hello.draw.visible = false;
    }else hello.counter++;
  }else hello.draw.setAlpha(hello.draw.getAlpha()+5);
}

function helloShow(){
  hello.draw.setPositionPx((getResolution().x/2)-(hello.draw.widthPx/2), getResolution().y/2)
  hello.draw.setAlpha(0);
  hello.draw.visible = true;
  hello.timer = setTimer(helloAlpha, 120, 0);
}
