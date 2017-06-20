function drunk(pid, gold){
	if(gold){
		if(item.hasPlace(pid)) item.give(pid, "ITMI_GOLD", 2);
		else sendMessageToPlayer(i, 192, 192, 192, ">Brak miejsca w ekwipunku.");
	}else item.remove(pid, "ITMI_GOLD", 2);	
  player[pid].isBusy = false;
}
