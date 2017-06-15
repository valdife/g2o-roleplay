gameDraw <- {};
local draw = Draw(0, 0, "");

function gameDraw::create(text){
  draw.text = text;
  draw.font = "FONT_OLD_20_WHITE_HI.TGA";
  draw.setPositionPx((getResolution().x/2)-(draw.widthPx/2), getResolution().y/2);
  draw.visible = true;
}

function gameDraw::setText(text){
  draw.text = text;
  draw.setPositionPx((getResolution().x/2)-(draw.widthPx/2), getResolution().y/2);
}

function gameDraw::destroy(){
  draw.visible = false;
}
