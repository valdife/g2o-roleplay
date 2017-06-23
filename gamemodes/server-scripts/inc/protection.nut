protection <- {};

function protection::init(pid){
  protection[pid] <- {};
  protection[pid].flood <- 0;
	protection[pid].itemInstance <- [];
	protection[pid].itemAmount <- [];
}

function protection::destroy(pid){
  protection[pid].flood = 0;
	protection[pid].itemInstance.clear();
	protection[pid].itemAmount.clear();
}

function protection::giveItem(pid, instance, amount){
	local find = protection[pid].itemInstance.find(instance);
	if(find==null){
		protection[pid].itemInstance.push(instance);
		protection[pid].itemAmount.push(amount);
	}	
	else protection[pid].itemAmount[find] += amount;
}

function protection::removeItem(pid, instance, amount){
	local find = protection[pid].itemInstance.find(instance);
	if(protection[pid].itemAmount[find]-amount<1){
		protection[pid].itemInstance.remove(find);
		protection[pid].itemAmount.remove(find);
	}	
	else protection[pid].itemAmount[find] -= amount;
}

function protection::harmonyItem(pid, instance, amount){
	local find = protection[pid].itemInstance.find(instance);
	if(find!=null){
		if(protection[pid].itemAmount[find]!=amount && protection[pid].itemAmount[find]<amount) return 0;
		else protection[pid].itemAmount[find] = amount;
	}else return 0;
	return 1;
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
