player <- {};

function player::init(pid){
  player[pid] <- {};
  
  /*
    To save start
  */  
    
  player[pid].isLogged <- false;
  player[pid].password <- null;
  player[pid].active <- 1;
  player[pid].sex <- 0;
  player[pid].race <- 0;
  player[pid].visual <- ["empty", 0, "empty", 0];
  player[pid].description <- "delete";
  player[pid].minuter <- 0;
  player[pid].online <- 0;
  player[pid].pn <- 0;
  player[pid].health <- 40;
  player[pid].maxHealth <- 40;
  player[pid].strength <- 10;
  player[pid].dexterity <- 10;
  player[pid].skillWeapon <- [10, 10, 10, 10];
  player[pid].citizen <- 0;
  player[pid].fraction <- 0;
  player[pid].admin <- 0;
  player[pid].adminPassword <- "empty";

  /*
    To save end
  */  

  player[pid].isBusy <- false;
  player[pid].adminIsLogged <- false;
  player[pid].adminListen <- false;
  player[pid].flood <- 0;
}

function player::destroy(pid){
  local file = io.file("database/accounts/" + getPlayerName(pid), "w");
  if(file.isOpen){
    local pos = getPlayerPosition(pid), visual = getPlayerVisual(pid);
    file.write(format("%s\n%d\n%d\n%d\n%d:%d:%d\n%s:%d:%s:%d\n%s\n%d\n%d\n%d\n%d\n%d\n%d\n%d\n%d:%d:%d:%d\n%d\n%d\n%d\n%s", player[pid].password, player[pid].active, player[pid].sex,
    player[pid].race, pos.x, pos.y, pos.z, player[pid].visual[0], player[pid].visual[1], player[pid].visual[2], player[pid].visual[3], player[pid].description, player[pid].minuter,
    player[pid].online, player[pid].pn, player[pid].health, player[pid].maxHealth, player[pid].strength, player[pid].dexterity, player[pid].skillWeapon[0],
    player[pid].skillWeapon[1], player[pid].skillWeapon[2], player[pid].skillWeapon[3], player[pid].citizen, player[pid].fraction, player[pid].admin, player[pid].adminPassword));
  }

  /*
    To save start
  */  
  
  player[pid].isLogged = false;
  player[pid].password = null;
  player[pid].active = 1;
  player[pid].sex = 0;
  player[pid].race = 0;
  player[pid].visual = ["empty", 0, "empty", 0];
  player[pid].description = "delete";
  player[pid].minuter = 0;
  player[pid].online = 0;
  player[pid].pn = 0;
  player[pid].health = 40;
  player[pid].maxHealth = 40;
  player[pid].strength  = 10;
  player[pid].dexterity = 10;
  player[pid].skillWeapon = [10, 10, 10, 10];
  player[pid].citizen = 0;
  player[pid].fraction = 0;
  player[pid].admin = 0;
  player[pid].adminPassword = "empty";
  
  /*
    To save end
  */  
  
  player[pid].isBusy = false;
  player[pid].adminIsLogged = false;
  player[pid].adminListen = false;
  player[pid].flood = 0;
}

function player::register(pid, nickname, password){
  if(nickname.len()<3 && nickname.len()>20 && strip(nickname)!="null") return 0;
  else if(password.len()<5 && password.len()>15) return 1;
  local file = io.file("database/accounts/" + nickname, "r");
  if(file.isOpen) return 2;
  nickname = pickUpFirstChar(nickname);
  player[pid].password = sha512(password);
  file.close();
  file = io.file("database/accounts/" + nickname, "w");
  file.write(format("%s\n1\n0", player[pid].password));
  setPlayerName(pid, nickname);
}

function player::registerEnd(pid){
  if(player[pid].sex==1){
	switch(player[pid].race){
		case 1: setPlayerVisual(pid, "hum_body_Naked0", 0, "Hum_Head_Psionic", 57); break;
		case 2: setPlayerVisual(pid, "hum_body_Naked0", 1, "Hum_Head_Psionic", 0); break;
		case 3: setPlayerVisual(pid, "hum_body_Naked0", 2, "Hum_Head_Psionic", 8); break;
		case 4: setPlayerVisual(pid, "hum_body_Naked0", 3, "Hum_Head_Psionic", 136); break;
	}
    equipArmor(pid, Items.id("ITAR_FAKE_RANGER"));
  }
  else if(player[pid].sex==2){
	switch(player[pid].race){
		case 1: setPlayerVisual(pid, "Hum_Body_Babe0", 4, "Hum_Head_Babe", 156); break;
		case 2: setPlayerVisual(pid, "Hum_Body_Babe0", 5, "Hum_Head_Babe", 144); break;
		case 3: setPlayerVisual(pid, "Hum_Body_Babe0", 6, "Hum_Head_Babe", 141); break;
		case 4: setPlayerVisual(pid, "Hum_Body_Babe0", 7, "Hum_Head_Babe", 142); break;
	}
    equipArmor(pid, Items.id("ITAR_VLKBABE_H"));
  }
  callClientFunc(pid, "player.registerEnd");
  player[pid].isLogged = true;
  spawnPlayer(pid);
}

function player::login(pid, nickname, password){
  if(nickname.len()<3 && nickname.len()>20) return 0;
  else if(password.len()<5 && password.len()>15) return 1;
  nickname = pickUpFirstChar(nickname);
  local file = io.file("database/accounts/" + nickname, "r");
  if(!file.isOpen) return 2;
  local truePassword = file.read(io_type.LINE);
  if(truePassword!=sha512(password)) return 3;
  if(file.read(io_type.LINE).tointeger()==0) return 4;
  player[pid].password = truePassword;
  setPlayerName(pid, nickname);
  player[pid].sex = file.read(io_type.LINE).tointeger();
  if(player[pid].sex==0) return 5;
  player[pid].race = file.read(io_type.LINE).tointeger();
  local pos = split(file.read(io_type.LINE), ":"), visual = split(file.read(io_type.LINE), ":");
  player[pid].description = file.read(io_type.LINE);
  if(player[pid].description!="delete") setPlayerColor(pid, 238, 138, 238);
  player[pid].minuter = file.read(io_type.LINE).tointeger();
  player[pid].online = file.read(io_type.LINE).tointeger();
  player[pid].pn = file.read(io_type.LINE).tointeger();
  player[pid].health = file.read(io_type.LINE).tointeger();
  player[pid].maxHealth = file.read(io_type.LINE).tointeger();
  player[pid].strength = file.read(io_type.LINE).tointeger();
  player[pid].dexterity = file.read(io_type.LINE).tointeger();
  local skillWeapon = split(file.read(io_type.LINE), ":");
  player[pid].citizen = file.read(io_type.LINE).tointeger();
  player[pid].fraction = file.read(io_type.LINE).tointeger();
  player[pid].admin = file.read(io_type.LINE).tointeger();
  player[pid].adminPassword = file.read(io_type.LINE);
  setPlayerMaxHealth(pid, player[pid].maxHealth);
  setPlayerHealth(pid, player[pid].health);
  setPlayerStrength(pid, player[pid].strength);
  setPlayerDexterity(pid, player[pid].dexterity);
  for(local i = 0; i<skillWeapon.len(); ++i){
    setPlayerSkillWeapon(pid, i, skillWeapon[i].tointeger());
  }
  setPlayerVisual(pid, visual[0], visual[1].tointeger(), visual[2], visual[3].tointeger());
  setPlayerPosition(pid, pos[0].tointeger(), pos[1].tointeger(), pos[2].tointeger());
  callClientFunc(pid, "setFreeze", false);
  player[pid].isLogged = true;
}

function player::showStats(pid){
  if(player[pid].isLogged){
    local lvl = player[pid].online + player[pid].maxHealth + player[pid].strength + player[pid].dexterity + player[pid].fraction;
    for(local i = 0 ; i<player[pid].skillWeapon.len(); ++i){
      lvl += player[pid].skillWeapon[i];
    }
    sendMessageToPlayer(pid, 213, 173, 66, " ");
    sendMessageToPlayer(pid, 213, 173, 66, format("(Minuter: %d) (Level: %d) (PN: %d) (Maksymalne punkty trafieñ: %d) (Si³a: %d) (Zrêcznoœæ: %d)",
    60-player[pid].minuter, lvl*0.01, player[pid].pn, player[pid].maxHealth, player[pid].strength, player[pid].dexterity));
    sendMessageToPlayer(pid, 213, 173, 66, format("(Broñ jednorêczna: %d) (Broñ dwurêczna: %d) (Kusze: %d), (£ucznictwo: %d)",
    player[pid].skillWeapon[0], player[pid].skillWeapon[1], player[pid].skillWeapon[2], player[pid].skillWeapon[3]));
    sendMessageToPlayer(pid, 213, 173, 66, " ");
  }
}

function player::description(pid){
  local focus = getPlayerFocus(pid);
  if(focus!=-1 && player[focus].description!="delete"){
    sendMessageToPlayer(pid, 184, 129, 238, player[focus].description);
  }
}

function player::narrator(pid, string){
  local pos = getPlayerPosition(pid), string = format("#%s %s", getPlayerName(pid), string);
  for(local i = 0; i<getMaxSlots(); ++i){
    if(player[i].isLogged){
      local pos2 = getPlayerPosition(i);
      if(getDistance3d(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z)<800) sendMessageToPlayer(i, 238, 130, 238, string);
    }
  }
}
