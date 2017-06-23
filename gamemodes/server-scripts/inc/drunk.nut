function drunk(pid, gold){
	if(gold){
		if(item.hasPlace(pid)) item.give(pid, true, "ITMI_GOLD", 2);
		else sendMessageToPlayer(i, 192, 192, 192, ">Brak miejsca w EQ.");
	}else item.remove(pid, true, "ITMI_GOLD", 2);	
  player[pid].isBusy = false;
}
