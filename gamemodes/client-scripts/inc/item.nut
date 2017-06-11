function itemSave(){
  local eq = getEq(), packet = "", i = 0;
  if(eq.len()>0){
    foreach(item in eq){
      if(i<30) packet += format("%d:%d.", Items.id(item.instance.toupper()), item.amount);
      else break;
      ++i;
    }
    packet = packet.slice(0, packet.len()-1);
  }
  callServerFunc("item.receiver", heroId, packet);
}
