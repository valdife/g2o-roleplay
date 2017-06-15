function work(pid, gold){
  if(gold){
    sendMessageToPlayer(pid, 194, 178, 128, "Uda³o siê zarobiæ 1 szt. z³.");
    item.give(pid, "ITMI_GOLD", 1);
  }else sendMessageToPlayer(pid, 194, 178, 128, "Nie uda³o siê nic zarobiæ.");
  player[pid].isBusy = false;
}
