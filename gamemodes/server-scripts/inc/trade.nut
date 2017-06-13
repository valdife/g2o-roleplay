trade <- {};

function trade::init(pid){
  trade[pid] <- {};
  trade[pid].item <- "";
  trade[pid].amount <- 0;
  trade[pid].player <- -1;
  trade[pid].price <- 0;
  trade[pid].mode <- 0;
}

function trade::refresh(pid, item, amount, player, price, mode){
  trade[pid].item = "";
  trade[pid].amount = 0;
  trade[pid].player = -1;
  trade[pid].price = 0;
  trade[pid].mode = 0;
}

function trade::destroy(pid, success){
  if(trade[pid].mode==0 && trade[pid].player!=-1){
    destroy(trade[pid].player);
  }else if(trade[pid].mode==1){
    if(!success){
      if(player[pid].isLogged) sendMessageToPlayer(pid, 194, 178, 128, "Oferta unieważniona.");
      if(player[trade[pid].player].isLogged) sendMessageToPlayer(trade[pid].player, 194, 178, 128, "Oferta unieważniona.");
    }
    trade[trade[pid].player].player = 0;
    refresh(pid, "", 0, -1, 0, 0);
  }
}
