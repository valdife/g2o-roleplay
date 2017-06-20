item <- {};

local function itemClear(pid){
  item[pid].instance.clear();
  item[pid].amount.clear();
}

function item::init(pid){
  item[pid] <- {};
  item[pid].instance <- [];
  item[pid].amount <- [];
  item[pid].flood <- 0;
}

function item::destroy(pid){
  local file = io.file("database/accounts/items/" + getPlayerName(pid), "w");
  if(file.isOpen){
    local packet = "";

    if(Items.name(getPlayerArmor(pid))) packet += Items.name(getPlayerArmor(pid)) + "\n";
    else packet += "null\n";

    if(Items.name(getPlayerMeleeWeapon(pid))) packet += Items.name(getPlayerMeleeWeapon(pid)) + "\n";
    else packet += "null\n";

    if(Items.name(getPlayerRangedWeapon(pid))) packet += Items.name(getPlayerRangedWeapon(pid)) + "\n";
    else packet += "null\n";

    for(local i = 0; i<item[pid].instance.len(); ++i){
      packet += format("%s:%d\n", item[pid].instance[i], item[pid].amount[i]);
    }
    packet = packet.slice(0, packet.len()-1);
    file.write(packet);
  }
  itemClear(pid);
  item[pid].flood = 0;
}

function item::login(pid){
  local file = io.file("database/accounts/items/" + getPlayerName(pid), "r");
  if(file.isOpen){
    local buffer, armor = file.read(io_type.LINE), melee = file.read(io_type.LINE), ranged = file.read(io_type.LINE);
    while(buffer = file.read(io_type.LINE)){
      buffer = split(buffer, ":");
      giveItem(pid, Items.id(buffer[0]), buffer[1].tointeger());
    }
    if(armor!="null") removeItem(pid, Items.id(armor), 1); equipArmor(pid, Items.id(armor));
    if(melee!="null") removeItem(pid, Items.id(melee), 1); equipMeleeWeapon(pid, Items.id(melee));
    if(ranged!="null") removeItem(pid, Items.id(ranged), 1); equipRangedWeapon(pid, Items.id(ranged));
    callClientFunc(pid, "itemSave");
  }
}

function item::give(pid, ...){
  if(isEven(vargv.len()) && item.hasPlace(pid)){
    for(local i = 0; i<vargv.len(); i = i+2){
      giveItem(pid, Items.id(vargv[i].toupper()), vargv[i+1]);
    }
    callClientFunc(pid, "itemSave");
  }
}

function item::remove(pid, ...){
  for(local i = 0; i<vargv.len(); i = i+2){
    removeItem(pid, Items.id(vargv[i].toupper()), vargv[i+1]);
  }
  callClientFunc(pid, "itemSave");
}

function item::receiver(pid, eq){
  item[pid].flood++;
  itemClear(pid);
  if(eq){
    eq = split(eq, ".");
    for(local i = 0; i<eq.len() && i<15; ++i){
      local packet = split(eq[i], ":");
      item[pid].instance.push(Items.name(packet[0].tointeger()));
      item[pid].amount.push(packet[1].tointeger());
    }
  }
  if(item[pid].flood>50) kick(pid, "flood");
}

function item::has(pid, instance){
  local find = item[pid].instance.find(instance);
  if(find!=null) return item[pid].amount[find];
  else return 0;
}

function item::hasPlace(pid){
  if(item[pid].instance.len()<15) return true;
	else return false;
}

function item::buy(pid, price, instance, amount){
  if(item.hasPlace(pid)){
    if(item.has(pid, "ITMI_GOLD")>=price){
      sendMessageToPlayer(pid, 194, 178, 128, "Zakupiono przedmiot.");
      removeItem(pid, Items.id("ITMI_GOLD"), price);
      giveItem(pid, Items.id(instance), amount);
      callClientFunc(pid, "itemSave");
    }else sendMessageToPlayer(pid, 192, 192, 192, ">Brak z³ota.");
  }else sendMessageToPlayer(pid, 192, 192, 192, ">Brak miejsca w EQ.");
}
