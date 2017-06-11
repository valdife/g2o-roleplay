local lou = {
  timer = null
  texture = null
  vob = null
  txts = ["DLG_CONVERSATION.TGA", "MAP_TEMPLE.TGA", "LETTERS.TGA", "GESUCHT.TGA", "CHAPTER4.TGA", "CHAPTER6.TGA"]
  vobs = ["ONION.3DS", "SKULL.3DS", "ITMI_GOLDCUP.3DS", "ITRU_WATER06.3DS", "ITMI_STONEPLATE_READ_01.3DS", "ITAT_WOLFFUR.3DS", "ITPL_FORESTBERRY.3DS"]
  counter = 0
};

local function louWork(){
  if(lou.counter==100){
    killTimer(lou.timer);
    lou.texture = null;
    lou.vob = null;
    lou.counter = 0;
  }else{
    lou.texture.setAlpha(70 - (rand() % 31));
    lou.texture.file = lou.txts[rand() % lou.txts.len()];
    local pos = getPlayerPosition(heroId);
    lou.vob.setVisual(lou.vobs[rand() % lou.vobs.len()]);
    lou.vob.setPosition(pos.x + rand() % 20, pos.y + 150 + rand() % 50, pos.z + rand() % 20);
    lou.counter++;
  }
}

function lou(){
  if(lou.counter==0){
    lou.texture = Texture(0, 0, 0, 0, "MAP_TEMPLE.TGA");
    lou.texture.setSizePx(getResolution().x, getResolution().y);
    lou.texture.setPositionPx(0, 0);
    lou.texture.visible = true;
    lou.timer = setTimer(louWork, 100, 0);
    lou.vob = Vob("ONION.3DS")
  }else lou.counter++;
}
