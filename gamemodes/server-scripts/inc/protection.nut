protection <- {};

function protection::init(pid){
  protection[pid] <- {};
  protection[pid].flood <- 0;
}

function protection::destroy(pid){
  protection[pid].flood = 0;
}

function protection::flood(pid){
  protection[pid].flood++;
  if(protection[pid].flood>5){
    sendMessageToPlayer(pid, 192, 192, 192, ">Odczekaj chwilê nim wykonasz kolejn¹ operacjê.");
    return 1;
  }
}

function protection::join(pid){
  local ip = 0;
  for(local i = 0; i<getMaxSlots(); ++i){
    if(isPlayerConnected(i)){
      if(getPlayerSerial(i)==getPlayerSerial(pid) && i!=pid){
        kick(pid, "double window");
        return 0;
      }else if(getPlayerIP(i)==getPlayerIP(pid)) ++ip;
    }
  }
  if(ip>9) kick(pid, "max ip");
}
