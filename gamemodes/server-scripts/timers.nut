local timer60s = setTimer(function(){
	for(local i = 0; i<getMaxSlots(); ++i){
		if(player[i].isLogged){
			player[i].minuter++;
			if(player[i].minuter>=60){
				sendMessageToPlayer(i, 194, 178, 128, "Otrzymano 2 PN za przegranie pe³nej godziny.");
				if(player[i].citizen){
					sendMessageToPlayer(i, 194, 178, 128, "Jako obywatel miasta otrzymujesz 20 szt. z³. od panuj¹cych w Khorinis.");
					if(item.hasPlace(i)) item.give(i, "ITMI_GOLD", 20);
					else sendMessageToPlayer(i, 192, 192, 192, ">Brak miejsca w EQ.");
				}	
				if(player[i].fraction==0){
					sendMessageToPlayer(i, 194, 178, 128, "Jako stra¿nik miejski otrzymujesz ¿o³d w wysokoœci 200 szt. z³.");
					if(item.hasPlace(i)) item.give(i, "ITMI_GOLD", 200);
					else sendMessageToPlayer(i, 192, 192, 192, ">Brak miejsca w EQ.");
				}	
				else if(player[i].fraction==1){
					sendMessageToPlayer(i, 194, 178, 128, "Jako paladyn otrzymujesz ¿o³d w wysokoœci 400 szt. z³.");
					if(item.hasPlace(i)) item.give(i, "ITMI_GOLD", 400);
					else sendMessageToPlayer(i, 192, 192, 192, ">Brak miejsca w EQ.");
				}	
				player[i].minuter=0;
				player[i].online++;
				player[i].pn += 2;;
			}
		}

		if(lottery.time<time()){
			if(lottery.players.len()>0){
				local winner = rand() % (lottery.players.len());
				for(local i = 0; i<getMaxSlots(); ++i){
					if(player[i].isLogged){
						if(lottery.players[winner]==getPlayerName(i)){
							if(item.hasPlace(i)){
								player.narrator(i, "otrzymuje z³oto z wygranej loterii.")
								if(lottery.budget==10){
									sendMessageToPlayer(i, 194, 178, 128, "Otrzymano 13 szt. z³. z wygranej loterii.");
									item.give(i, "ITMI_GOLD", 13);
								}else {
									sendMessageToPlayer(i, 194, 178, 128, format("Otrzymano %d szt. z³. z wygranej loterii.", lottery.budget));
									item.give(i, "ITMI_GOLD", lottery.budget);
								}
							}else sendMessageToPlayer(i, 192, 192, 192, ">Brak miejsca w EQ.");
						}
					}
				}
				lottery.players.clear();
				lottery.budget = 0;
			}
			lottery.time = time()+3600;
		}
	}
}, 60000, 0);

local timer5s = setTimer(function(){
	for(local i = 0; i<getMaxSlots(); ++i){
		if(player[i].isLogged){
			item[i].flood = 0;
			protection[i].flood = 0;
			if(trade[i].mode){
				local pos = getPlayerPosition(i), pos2 = getPlayerPosition(trade[i].player);
				if(getDistance3d(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z)>600) trade.destroy(i, 0);
			}
		}
	}
}, 5000, 0);
