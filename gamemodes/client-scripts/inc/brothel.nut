local brothel = {
  timer = null
  texture = null
  counter = 0
};

local function brothelAlpha(){
  if(brothel.texture.getAlpha()==100){
    if(brothel.counter==100){
      killTimer(brothel.timer);
      brothel.texture = null;
    }else brothel.counter++;
  }else brothel.texture.setAlpha(brothel.texture.getAlpha()+5);
}

function brothelShow(){
  itemSave();
  brothel.texture = Texture(0, 0, 0, 0, "MAP_PINUP.TGA");
  brothel.texture.setSizePx(688, 512);
  brothel.texture.setPositionPx((getResolution().x/2)-344, (getResolution().y/2)-256);
  brothel.texture.setAlpha(0);
  brothel.texture.visible = true;
  brothel.timer = setTimer(brothelAlpha, 200, 0);
}
