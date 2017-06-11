bank <- {};

function bank::init(pid){
  bank[pid] <- {};
  bank[pid].instance <- [];
  bank[pid].amount <- [];
}

function bank::destroy(pid){
  local file = io.file("database/accounts/bank/" + getPlayerName(pid), "w");
  if(file.isOpen){
    local packet = "";
    for(local i = 0; i<bank[pid].instance.len(); ++i){
      packet += format("%s:%d\n", bank[pid].instance[i], bank[pid].amount[i]);
    }
    if(bank[pid].instance.len()>0) packet = packet.slice(0, packet.len()-1);
    file.write(packet);
  }
  bank[pid].instance.clear();
  bank[pid].amount.clear();
}

function bank::login(pid){
  local file = io.file("database/accounts/bank/" + getPlayerName(pid), "r");
  if(file.isOpen){
    local buffer;
    while(buffer = file.read(io_type.LINE)){
      buffer = split(buffer, ":");
      bank[pid].instance.push(buffer[0]);
      bank[pid].amount.push(buffer[1].tointeger());
    }
  }
}

function bank::depositPacket(pid){
  if(bank[pid].instance.len()>0){
    local packet = "";
    for(local i = 0; i<bank[pid].instance.len(); ++i){
      packet += format("%d:%d.", Items.id(bank[pid].instance[i]), bank[pid].amount[i]);
    }
    packet = packet.slice(0, packet.len()-1);
    return packet;
  }
}

function bank::depositPacketSend(pid){
  local packet = depositPacket(pid);
  if(packet) callClientFunc(pid, "bankRefresh", 1, packet);
  else{
    sendMessageToPlayer(pid, 192, 192, 192, ">Nie posiadasz wiêcej depozytu w banku.");
    callClientFunc(pid, "itemSave");
    callClientFunc(pid, "dialog.destroy");
  }
}
