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
      item.give(pid, false, buffer[0], buffer[1].tointeger());
    }
    if(armor!="null") item.remove(pid, false, armor, 1); item.eqpArmor(pid, false, armor);
    if(melee!="null") item.remove(pid, false, melee, 1); item.eqpMeleeWeapon(pid, false, melee);
    if(ranged!="null") item.remove(pid, false, ranged, 1); item.eqpRangedWeapon(pid, false, ranged);
		callClientFunc(pid, "itemSave");
  }
}

function item::give(pid, save, ...){
  if(isEven(vargv.len()) && item.hasPlace(pid)){
    for(local i = 0; i<vargv.len(); i = i+2){
			local instance = vargv[i].toupper();
			giveItem(pid, Items.id(instance), vargv[i+1]);
			protection.giveItem(pid, instance, vargv[i+1]);
    }
    if(save) callClientFunc(pid, "itemSave");
  }
}

function item::remove(pid, save, ...){
  for(local i = 0; i<vargv.len(); i = i+2){
		local instance = vargv[i].toupper();
    removeItem(pid, Items.id(instance), vargv[i+1]);
		protection.removeItem(pid, instance, vargv[i+1]);
  }
  if(save) callClientFunc(pid, "itemSave");
}

function item::eqpArmor(pid, save, instance){
	equipArmor(pid, Items.id(instance));
	protection.giveItem(pid, instance, 1);
	if(save) callClientFunc(pid, "itemSave");
}

function item::eqpMeleeWeapon(pid, save, instance){
	equipMeleeWeapon(pid, Items.id(instance));
	protection.giveItem(pid, instance, 1);
	if(save) callClientFunc(pid, "itemSave");
}

function item::eqpRangedWeapon(pid, save, instance){
	equipRangedWeapon(pid, Items.id(instance));
	protection.giveItem(pid, instance, 1);
	if(save) callClientFunc(pid, "itemSave");
}

function item::receiver(pid, eq){
  item[pid].flood++;
  itemClear(pid);
  if(eq){
    eq = split(eq, ".");
    for(local i = 0; i<eq.len() && i<15; ++i){
      local packet = split(eq[i], ":");
			if(!protection.harmonyItem(pid, Items.name(packet[0].tointeger()), packet[1].tointeger())){
				kick(pid, "cheat");
				return 0;
			}
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
      item.remove(pid, false, Items.id("ITMI_GOLD"), price);
      item.give(pid, true, Items.id(instance), amount);
    }else sendMessageToPlayer(pid, 192, 192, 192, ">Brak z³ota.");
  }else sendMessageToPlayer(pid, 192, 192, 192, ">Brak miejsca w EQ.");
}
