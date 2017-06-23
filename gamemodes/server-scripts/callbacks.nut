addEventHandler("onInit", function(){
	pmLog <- Log("pm");
	bLog <- Log("b");
	lLog <- Log("l");
	sLog <- Log("s");
	wLog <- Log("w");
	earLog <- Log("ear");
	meLog <- Log("me");
	doLog <- Log("do");
	tryLog <- Log("try");
	descriptionLog <- Log("description");
	reportLog <- Log("report");
		
	fractions <- [];
	fractions.push(Fraction("Stra¿ Miejska", 150, 6395, 917, 7391));
	fractions.push(Fraction("Zakon Paladynów", 300, 14420, 1202, -203));
		
	for(local i = 0; i<getMaxSlots(); ++i){
		player.init(i);
		item.init(i);
		protection.init(i);
		trade.init(i);
		bank.init(i);
	}
	position.init();

	local date = date();
	setTime(date.hour, date.min);
});

addEventHandler("onPlayerJoin", function(pid){
	protection.join(pid);
	setPlayerName(pid, format("New %d", pid));
});

addEventHandler("onPlayerDisconnect", function(pid, reason){
	if(player[pid].isLogged){
		player.destroy(pid);
		item.destroy(pid);
		bank.destroy(pid);
		protection.destroy(pid);
		trade.destroy(pid, 0);
	}
});

addEventHandler("onPlayerMessage", function(pid, message){
	if(player[pid].isLogged){
		if(protection.flood(pid)) return 0;
		else if(message.find("@")==0) animations(pid, message);
		else{
			local pos = getPlayerPosition(pid);
			for(local i = 0; i<getMaxSlots(); ++i){
				if(player[i].isLogged){
					local pos2 = getPlayerPosition(i);
					if(getDistance3d(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z)<800) breakSendMessageToPlayer(i, 250, 250, 250, format("%s mówi: %s", getPlayerName(pid),
					convertMessageToIC(message)));
				}
			}
			lLog.enter(format("%s: %s", getPlayerName(pid), message));
		}
	}
});

addEventHandler("onPlayerCommand", function(pid, cmd, params){
	if(!player[pid].isLogged){
		switch(cmd){
			case "register":
				local args = sscanf("ss", params);
				if(args){
					local register = player.register(pid, args[0], args[1]);
					if(register==0) sendMessageToPlayer(pid, 192, 192, 192, ">Nieprawid³owa d³ugoœæ nicku.");
					else if(register==1) sendMessageToPlayer(pid, 192, 192, 192, ">Nieprawid³owa d³ugoœæ has³a.");
					else if(register==2) sendMessageToPlayer(pid, 192, 192, 192, ">Proponowany nick jest zajêty.");
					else callClientFunc(pid, "dialog.show", 0);
				}else sendMessageToPlayer(pid, 192, 192, 192, ">Tip: /register (nick) (password)");
			break;

			case "login":
				local args = sscanf("ss", params);
				if(args){
					local login = player.login(pid, args[0], args[1]);
					if(login>=0 && login<4) sendMessageToPlayer(pid, 192, 192, 192, ">Nazwa postaci b¹dŸ has³o s¹ nieprawid³owe.");
					else if(login==4) sendMessageToPlayer(pid, 192, 192, 192, ">Konto jest nieaktywne.");
					else if(login==5) {
						sendMessageToPlayer(pid, 192, 192, 192, ">Tworzenie postaci nie zosta³o zakoñczone.");
						callClientFunc(pid, "dialog.show", 0);
					}else{
						sendMessageToPlayer(pid, 194, 178, 128, " ");
						sendMessageToPlayer(pid, 194, 178, 128, "Pomyœlnie zalogowano. Mi³ej gry.");
						item.login(pid);
						bank.login(pid);
						spawnPlayer(pid);
					}
				}else sendMessageToPlayer(pid, 192, 192, 192, ">Tip: /login (nick) (password)");
			break;
		}
	}
	else{
		if(protection.flood(pid)) return 0;
		switch(cmd){

			/*
				Chat commands start
			*/

			case "pm":
			case "privatemessage":
				local args = sscanf("ds", params);
				if(args){
					if(player[args[0]].isLogged && args[0]!=pid){
						if(args[1].len()<161){
							breakSendMessageToPlayer(pid, 255, 191, 0, format("(( PM do (%d) %s: %s ))", args[0], getPlayerName(args[0]), args[1]));
							breakSendMessageToPlayer(args[0], 233, 107, 57, format("(( PM od (%d) %s: %s ))", pid, getPlayerName(pid), args[1]));
							pmLog.enter(format("%s do %s: %s", getPlayerName(pid), getPlayerName(args[0]), args[1]));
						}else  sendMessageToPlayer(pid, 192, 192, 192, ">Zbyt wiele znaków.");
					}else sendMessageToPlayer(pid, 192, 192, 192, ">Nieprawid³owe ID.");
				}else sendMessageToPlayer(pid, 192, 192, 192, ">Tip: /p(rivate)m(essage) (id) (text 1-160)");
			break;

			case "b":
				if(params.len()>0 && params.len()<161){
					local pos = getPlayerPosition(pid), string = format("(( (%d) %s: %s ))", pid, getPlayerName(pid), params);
					for(local i = 0; i<getMaxSlots(); ++i){
						if(player[i].isLogged){
							local pos2 = getPlayerPosition(i);
							if(getDistance3d(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z)<800) breakSendMessageToPlayer(i, 198, 206, 206, string);
						}
					}
					bLog.enter(format("%s: %s", getPlayerName(pid), params));
				}else sendMessageToPlayer(pid, 192, 192, 192, ">Tip: /b (text 1-160)");
			break;

		case "s":
		case "shout":
			if(params.len()>0 && params.len()<161){
				local pos = getPlayerPosition(pid), len = params.len()-1;
				if(params[len]!=33 && params[len]!=46) params += "!";
				for(local i = 0; i<getMaxSlots(); ++i){
					if(player[i].isLogged){
						local pos2 = getPlayerPosition(i);
						if(getDistance3d(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z)<1600) breakSendMessageToPlayer(i, 250, 250, 250, format("%s krzyczy: %s", getPlayerName(pid), convertMessageToIC(params)));
					}
				}
				sLog.enter(format("%s: %s", getPlayerName(pid), params));
			}else sendMessageToPlayer(pid, 192, 192, 192, ">Tip: /s(hout) (text 1-160)");;
		break;

		case "w":
		case "whisper":
			if(params.len()>0 && params.len()<161){
				local pos = getPlayerPosition(pid);
				for(local i = 0; i<getMaxSlots(); ++i){
					if(player[i].isLogged){
						local pos2 = getPlayerPosition(i);
						if(getDistance3d(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z)<400) breakSendMessageToPlayer(i, 250, 250, 250, format("%s szepcze: %s", getPlayerName(pid), convertMessageToIC(params)));
					}
				}
				wLog.enter(format("%s: %s", getPlayerName(pid), params));
			}else sendMessageToPlayer(pid, 192, 192, 192, ">Tip: /w(hisper) (text 1-160)");
		break;

		case "ear":
			local args = sscanf("ds", params);
			if(args && args[1].len()<161){
				if(player[args[0]].isLogged && args[0]!=pid){
					if(getDistanceBeetwenPlayers(pid, args[0])<300){
						breakSendMessageToPlayer(args[0], 250, 250, 250, format("%s szepcze Ci na ucho: %s", getPlayerName(pid), convertMessageToIC(args[1])));
						player.narrator(pid, format("szepcze coœ na ucho %s", getPlayerName(args[0])));
						earLog.enter(format("%s do %s: %s", getPlayerName(pid), getPlayerName(args[0]), args[1]));
					}else sendMessageToPlayer(pid, 192, 192, 192, ">Gracz jest za daleko.");
				}else sendMessageToPlayer(pid, 192, 192, 192, ">Nieprawid³owe ID.");
			}else sendMessageToPlayer(pid, 192, 192, 192, ">Tip: /ear (id) (text 1-160)");
		break;

		case "me":
			if(params.len()>0 && params.len()<161){
				local pos = getPlayerPosition(pid), string = format("%s %s", getPlayerName(pid), params);
				for(local i = 0; i<getMaxSlots(); ++i){
					if(player[i].isLogged){
						local pos2 = getPlayerPosition(i);
						if(getDistance3d(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z)<800) sendMessageToPlayer(i, 238, 130, 238, string);
					}
				}
				meLog.enter(format("%s: %s", getPlayerName(pid), params));
			}else sendMessageToPlayer(pid, 192, 192, 192, ">Tip: /me (text 1-160)");
		break;

		case "do":
			if(params.len()>0 && params.len()<161){
				local pos = getPlayerPosition(pid), string = format("%s (( (%d) %s ))", params, pid, getPlayerName(pid));
				for(local i = 0; i<getMaxSlots(); ++i){
					if(player[i].isLogged){
						local pos2 = getPlayerPosition(i);
						if(getDistance3d(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z)<800) breakSendMessageToPlayer(i, 184, 129, 238, string);
					}
				}
				doLog.enter(format("%s: %s", getPlayerName(pid), params));
			}else sendMessageToPlayer(pid, 192, 192, 192, ">Tip: /do (text 1-160)");
		break;

		case "try":
			if(params.len()>0 && params.len()<161){
				local random = rand() % 2, pos = getPlayerPosition(pid), randomResult;
				if(random==1) randomResult = "z powodzeniem";
				else randomResult = "z niepowodzeniem";
				local string = format("#%s %s spróbowa³ %s", getPlayerName(pid), randomResult, params);
				for(local i = 0; i<getMaxSlots(); ++i){
					if(player[i].isLogged){
						local pos2 = getPlayerPosition(i);
						if(getDistance3d(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z)<800) breakSendMessageToPlayer(i, 238, 130, 238, string);
					}
				}
				tryLog.enter(format("%s: %s - %s", getPlayerName(pid), params, randomResult));
			}else sendMessageToPlayer(pid, 192, 192, 192, ">Tip: /try (text 1-160)");
		break;

		case "bones":
				local args = sscanf("d", params);
				if(args && args[0]>1 && args[0]<100){
					local random = rand() % (args[0]+1), pos = getPlayerPosition(pid), string = format("Wylosowano %d z %d (( #(%d) %s ))", random, args[0], pid, getPlayerName(pid));
					for(local i = 0; i<getMaxSlots(); ++i){
						if(player[i].isLogged){
							local pos2 = getPlayerPosition(i);
							if(getDistance3d(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z)<800) sendMessageToPlayer(i, 184, 129, 238, string);
						}
					}
				}else sendMessageToPlayer(pid, 192, 192, 192, ">Tip: /bones (max 2-99)");
		break;

		/*
			Chat commands end
		*/

		/*
			Settings commands start
		*/

		case "description":
			if(params.len()>=1 && params.len()<81){
				player[pid].description = params;
				if(player[pid].description!="delete"){
					sendMessageToPlayer(pid, 194, 178, 128, "Ustawiono opis.");
					setPlayerColor(pid, 184, 129, 238);
					descriptionLog.enter(format("%s: %s", getPlayerName(pid), params));
				}else{
					sendMessageToPlayer(pid, 194, 178, 128, "Usuniêto opis.");
					setPlayerColor(pid, 250, 250, 250);
				}
			}else sendMessageToPlayer(pid, 192, 192, 192, ">Tip: /description (text 1-80)");
		break;

		/*
			Settings commands end
		*/

		/*
			Activity commands start
		*/

		case "citizen":
			if(position.get(pid, "citizen")){
				if(!player[pid].citizen){
					player.narrator(pid, "rejestruje siê jako obywatel miasta.");
					sendMessageToPlayer(pid, 194, 178, 128, "Co godzinê gry przyznawane Ci bêdzie 20 szt. z³.");
					player[pid].citizen = 1;
				}else sendMessageToPlayer(pid, 198, 206, 206, ">Z akt wynika, ¿e posiadasz ju¿ obywatelstwo.");
			}else sendMessageToPlayer(pid, 198, 206, 206, ">Jesteœ w nieodpowiednim miejscu.");
		break;	
		
		case "learn":
			if(position.get(pid, "learn")){
				player.narrator(pid, "rozmawia z nauczycielem.");
				sendMessageToPlayer(pid, 194, 178, 128, "Wszystkie umiejêtnoœci kosztuj¹ 1 PN za 1 punkt.");
				callClientFunc(pid, "dialog.show", 2);
			}
		break;

		case "brothel":
			if(position.get(pid, "brothel")){
				if(item.has(pid, "ITMI_GOLD")>=150){
					player.narrator(pid, "korzysta z us³ug domu publicznego.");
					sendMessageToPlayer(pid, 194, 178, 128, "Uzupe³niono punkty trafieñ do maksymalnej wartoœci.");
					item.remove(pid, false, "ITMI_GOLD", 150);
					callClientFunc(pid, "brothelShow");
					setPlayerHealth(pid, player[pid].maxHealth);
				}else sendMessageToPlayer(pid, 198, 206, 206, ">Nie posiadasz wystarczaj¹co z³ota.");
			}else sendMessageToPlayer(pid, 198, 206, 206, ">Jesteœ nie nieodpowiednim miejscu.");
		break;

		case "roulette":
			if(position.get(pid, "roulette")){
				local args = sscanf("d", params);
				if(args && args[0]>0){
					if(item.has(pid, "ITMI_GOLD")>=args[0]){
						player.narrator(pid, "gra w ruletkê.");
						local random;
						for(local i = 0; i<3; ++i){
							random = rand() % 3;
						}
						if(random==1){
							local gold = args[0]*2;
							sendMessageToPlayer(pid, 194, 178, 128, format("Gratulacje! %d szt. z³. trafia do Twojej kieszeni.", gold));
							item.give(pid, true, "ITMI_GOLD", gold);
						}else{
							sendMessageToPlayer(pid, 194, 178, 128, "Tym razem siê nie uda³o.");
							item.remove(pid, true, "ITMI_GOLD", args[0]);
						}
					}else sendMessageToPlayer(pid, 198, 206, 206, ">Nie posiadasz wystarczaj¹co z³ota.");
				}else{
					sendMessageToPlayer(pid, 198, 206, 206, ">U¿yj /roulette (gold), by zagraæ w ruletkê.");
					sendMessageToPlayer(pid, 194, 178, 128, "Uwa¿aj, bo hazard wci¹ga.");
				}
			}else sendMessageToPlayer(pid, 198, 206, 206, ">Nie znajdujesz siê przy ruletce.");
		break;

		case "lottery":
			if(position.get(pid, "lottery")){
				local args = sscanf("s", params);
				if(args){
					if(args[0]=="pay"){
						if(lottery.players.find(getPlayerName(pid))==null){
							if(item.has(pid, "ITMI_GOLD")>=10){
								player.narrator(pid, "bierze udzia³ w loterii.");
								sendMessageToPlayer(pid, 194, 178, 128, "Wp³acono na loteriê. Jeœli wygrasz, pos³aniec przyniesie Ci z³oto.");
								item.remove(pid, true, "ITMI_GOLD", 10);
								lottery.budget += 10;
								lottery.players.push(getPlayerName(pid));
							}else sendMessageToPlayer(pid, 198, 206, 206, ">Nie posiadasz wystarczaj¹co z³ota.");
						}else sendMessageToPlayer(pid, 198, 206, 206, ">Wp³acono ju¿ na obecn¹ loteriê.");
					}else sendMessageToPlayer(pid, 198, 206, 206, ">Nieprawid³owa opcja.");
				}else{
					local lotteryEnd = (lottery.time-time())/60;
					if(lotteryEnd<=0) sendMessageToPlayer(pid, 198, 206, 206, ">U¿yj /lottery pay, by wzi¹æ udzia³. Loteria za chwilê siê zakoñczy.");
					else sendMessageToPlayer(pid, 198, 206, 206, format(">U¿yj /lottery pay, by wzi¹æ udzia³. Loteria koñczy siê za %d min.", lotteryEnd));
					sendMessageToPlayer(pid, 194, 178, 128, "Pamiêtaj, ¿e musisz znajdowaæ siê na serwerze, by odebraæ ewentualn¹ nagrodê.");
				}
			}else sendMessageToPlayer(pid, 198, 206, 206, ">W tym miejscu loterie nie s¹ organizowane.");
		break;

		case "blacktrader":
			if(position.get(pid, "blacktrader")){
				local args = sscanf("dd", params);
				if(args){
					if(item.hasPlace(pid)){
						if(item[pid].instance.len()>=args[0]){
							if(item[pid].amount[args[0]]>=args[1]){
								player.narrator(pid, "sprzedaje coœ paserowi.");
								sendMessageToPlayer(pid, 194, 178, 128, "Paser da³ Ci sztukê z³ota za ten przedmiot.");
								item.remove(pid, false, item[pid].instance[args[0]], args[1]);
								item.give(pid, true, "ITMI_GOLD", args[1]);
							}else sendMessageToPlayer(pid, 198, 206, 206, ">Nie posiadasz ¿¹danego przedmiotu w takiej liczbie.");
						}else sendMessageToPlayer(pid, 198, 206, 206, ">Nieprawid³owy slot.");
					}else sendMessageToPlayer(pid, 198, 206, 206, ">Brak miejsca w EQ.");
				}else{
					sendMessageToPlayer(pid, 198, 206, 206, ">U¿yj /blacktrader (slot) (amount)");
					sendMessageToPlayer(pid, 194, 178, 128, "Sloty liczone s¹ od 0. By upewniæ siê co do slotu, mo¿esz u¿yæ komendy /slot.");
					sendMessageToPlayer(pid, 194, 178, 128, "Paser nie bierze pod uwagê wartoœci przedmiotu i za ka¿dy zap³aci Ci 1 szt. z³.");
				}
			}else sendMessageToPlayer(pid, 198, 206, 206, ">W okolicy nie widaæ pasera.");
		break;

		case "bank":
			if(position.get(pid, "bank")) callClientFunc(pid, "dialog.show", 8);
			else return 0;
			player.narrator(pid, "rozmawia z bankierem.");
		break;

		case "buy":
			if(player[pid].online>0){
				if(position.get(pid, "food")) callClientFunc(pid, "dialog.show", 3);
				else if(position.get(pid, "potion")) callClientFunc(pid, "dialog.show", 4);
				else if(position.get(pid, "cloth")) callClientFunc(pid, "dialog.show", 5);
				else if(position.get(pid, "weapon")) callClientFunc(pid, "dialog.show", 6);
				else if(position.get(pid, "fletcher")) callClientFunc(pid, "dialog.show", 7);
				else return 0;
				player.narrator(pid, "rozmawia z handlarzem.");
			}else sendMessageToPlayer(pid, 198, 206, 206, ">Kupowaæ mo¿na dopiero po przegraniu 1 godziny online.");
		break;
		
		case "work":
			if(position.get(pid, "work")){
				if(!player[pid].isBusy){
					player.narrator(pid, "pracuje.");
					sendMessageToPlayer(pid, 194, 178, 128, "Rozpoczêto pracê. Trzymaj lewy ctrl do osi¹gniêcia 100%.");
					sendMessageToPlayer(pid, 194, 178, 128, "Spadek do 0% oznacza przerwanie pracy.");
					player[pid].isBusy = true;
					callClientFunc(pid, "work.start");
				}
			}
			else sendMessageToPlayer(pid, 198, 206, 206, ">W tym miejscu nie mo¿na pracowaæ.");
		break;

		case "pay":
			local args = sscanf("dd", params);
			if(args){
				if(player[args[0]].isLogged && args[0]!=pid){
					if(getDistanceBeetwenPlayers(pid, args[0])<600){
						if(item.has(pid, "ITMI_GOLD")>=args[1]){
							if(item.hasPlace(args[1])){
								player.narrator(pid, format("daje z³oto %s.", getPlayerName(args[0])));
								sendMessageToPlayer(args[0], 194, 178, 128, format("(%d) %s podarowuje Ci %d szt. z³.", pid, getPlayerName(pid), args[1]));
								sendMessageToPlayer(pid, 194, 178, 128, format("Podarowano %d szt. z³. (%d) %s.", args[1], args[0], getPlayerName(args[0])));
								item.remove(pid, true, "ITMI_GOLD", args[1]);
								item.give(args[0], true, "ITMI_GOLD", args[1]);
							}else sendMessageToPlayer(pid, 198, 206, 206, ">EQ gracza jest przepe³niony.");
						}else sendMessageToPlayer(pid, 198, 206, 206, ">Nie posiadasz wystarczaj¹co z³ota.");
					}else sendMessageToPlayer(pid, 198, 206, 206, ">Gracz znajduje siê za daleko.");
				}else sendMessageToPlayer(pid, 198, 206, 206, ">Nieprawid³owe ID.");
			}else sendMessageToPlayer(pid, 198, 206, 206, ">Tip: /pay (id) (amount)");
		break;

		case "trade":
			if(params=="accept"){
				if(trade[pid].player!=-1 && trade[pid].mode==0){
					if(item.hasPlace(pid)){
						if(item.has(pid, "ITMI_GOLD")>=trade[trade[pid].player].price){
							if(item.hasPlace(trade[pid].player) || trade[trade[pid].player].price==0){
								if(item.has(trade[pid].player, trade[trade[pid].player].item)>=trade[trade[pid].player].amount){
									player.narrator(pid, format("handluje z %s.", getPlayerName(trade[pid].player)));
									sendMessageToPlayer(trade[pid].player, 194, 178, 128, "Handel udany.");
									sendMessageToPlayer(pid, 194, 178, 128, "Handel udany.");
									if(trade[trade[pid].player].price>0){
										item.remove(pid, false, "ITMI_GOLD", trade[trade[pid].player].price);
										item.give(trade[pid].player, false, "ITMI_GOLD", trade[trade[pid].player].price);
									}
									item.remove(trade[pid].player, true, trade[trade[pid].player].item, trade[trade[pid].player].amount);
									item.give(pid, true, trade[trade[pid].player].item, trade[trade[pid].player].amount);
									trade.destroy(pid, 1);
								}else sendMessageToPlayer(pid, 198, 206, 206, ">Gracz nie posiada ju¿ przedmiotu.");
							}else sendMessageToPlayer(pid, 198, 206, 206, ">Gracz nie posiada miejsca w EQ na przyjêcie z³ota.");
						}else sendMessageToPlayer(pid, 198, 206, 206, ">Nie posiadasz wystarczaj¹co z³ota.");
					}else sendMessageToPlayer(pid, 198, 206, 206, ">Twój EQ jest przepe³niony.");
				}else sendMessageToPlayer(pid, 198, 206, 206, ">Nie prowadzisz z nikim handlu.");
			}else if(params=="stop"){
				if(trade.destroy(pid, 0)) sendMessageToPlayer(pid, 198, 206, 206, ">Nie prowadzisz z nikim handlu.");
			}else{
				local args = sscanf("dddd", params);
				if(args){
					if(player[args[0]].isLogged && args[0]!=pid){
						if(getDistanceBeetwenPlayers(pid, args[0])<600){
							if(item[pid].instance.len()>=args[1] && args[1]>-1){
								if(item[pid].amount[args[1]]>=args[2] && args[2]>0){
									if(trade[args[0]].player==-1){
										if(trade[pid].player==-1){
											sendMessageToPlayer(pid, 194, 178, 128, format("Zaoferowano (%d) %s przedmiot %s w iloœci %d szt. za cenê %d szt. z³.", args[0],
											getPlayerName(args[0]), item[pid].instance[args[1]], args[2], args[3]));
											sendMessageToPlayer(pid, 198, 206, 206, ">U¿yj /trade stop, by anulowaæ ofertê.");
											sendMessageToPlayer(args[0], 194, 178, 128, format("(%d) %s oferuje Ci przedmiot %s w iloœci %d szt. za cenê %d szt. z³.", pid,
											getPlayerName(pid), item[pid].instance[args[1]], args[2], args[3]));
											sendMessageToPlayer(args[0], 198, 206, 206, ">U¿yj /trade accept, by akceptowaæ lub /trade stop, by odrzuciæ ofertê.");
											trade.refresh(pid, item[pid].instance[args[1]], args[2], args[0], args[3], 1);
											trade[args[0]].player = pid;
										}else sendMessageToPlayer(pid, 198, 206, 206, ">Handlujesz ju¿ z kimœ.");
									}else sendMessageToPlayer(pid, 198, 206, 206, ">Gracz obecnie z kimœ handluje.");
								}else sendMessageToPlayer(pid, 198, 206, 206, ">Nie posiadasz ¿¹danego przedmiotu w takiej liczbie.");
							}else sendMessageToPlayer(pid, 198, 206, 206, ">Nieprawid³owy slot.");
						}else sendMessageToPlayer(pid, 198, 206, 206, ">Gracz znajduje siê za daleko.");
					}else sendMessageToPlayer(pid, 198, 206, 206, ">Nieprawid³owe ID.");
				}else{
					sendMessageToPlayer(pid, 198, 206, 206, ">Tip: /trade (id) (slot) (amount) (price)");
					sendMessageToPlayer(pid, 194, 178, 128, "Sloty liczone s¹ od 0. By upewniæ siê co do slotu, mo¿esz u¿yæ komendy /slot.");
				}
		}
		break;

		case "drunk":
			if(!player[pid].isBusy){
				if(position.get(pid, "drunk")){
					if(item.has(pid, "ITMI_GOLD")>=2){
						player.narrator(pid, "zak³ada siê z pijakami.");
						callClientFunc(pid, "drunk.start");
						player[pid].isBusy = true;
					}
					else sendMessageToPlayer(pid, 198, 206, 206, ">Nie posiadasz wystarczaj¹co z³ota.");
				}
				else sendMessageToPlayer(pid, 198, 206, 206, ">W tym miejscu nie widaæ pijaka.");
			}
		break;
		
		case "search":
			local args = sscanf("d", params);
			if(args){
				if(player[args[0]].isLogged && args[0]!=pid){
					if(player[pid].adminIsLogged || getDistanceBeetwenPlayers(pid, args[0])<600){
						if(item[args[0]].instance.len()>0){
							if(!player[pid].adminIsLogged) player.narrator(pid, format("przeszukuje %s", getPlayerName(args[0])));
							local pos = 0;
							while(pos<item[args[0]].instance.len()){
								local msg = "";
								while(1){
									msg += format("(%d) %s, ", item[args[0]].amount[pos], item[args[0]].instance[pos]);
									pos++;
									if(pos>item[args[0]].instance.len()-1) break;
									else{
										local temp = msg + format("(%d) %s), ", item[args[0]].amount[pos], item[args[0]].instance[pos]);
										if(temp.len()>90) break;
									}
								}
								sendMessageToPlayer(pid, 194, 178, 128, msg.slice(0, msg.len()-2));
							}
						}else sendMessageToPlayer(pid, 198, 206, 206, ">Gracz nie posiada ¿adnych przedmiotów."); 
					}else sendMessageToPlayer(pid, 198, 206, 206, ">Gracz znajduje siê za daleko.");
				}else sendMessageToPlayer(pid, 198, 206, 206, ">Nieprawid³owe ID."); 
			}else sendMessageToPlayer(pid, 198, 206, 206, ">Tip: /search (id)"); 
		break;
		
		/*
			Activity commands end
		*/

		/*
			Other commands start
		*/

		case "slot":
			local args = sscanf("d", params);
			if(args){
				if(item[pid].instance.len()>args[0]) sendMessageToPlayer(pid, 194, 178, 128, format("Slot nr %d: %s", args[0], item[pid].instance[args[0]]));
				else sendMessageToPlayer(pid, 198, 206, 206, ">Slot jest pusty.");
			}else sendMessageToPlayer(pid, 198, 206, 206, ">Tip: /slot (nr)");
		break;

		case "admins":
			local id = [], lvl = [];
			for(local i = 0; i<getMaxSlots(); ++i){
				if(player[i].adminIsLogged){
					id.push(i);
					lvl.push(player[i].admin);
				}
			}
			if(id.len()>0){
				local sort = true, len = id.len()-1;
				while(sort){
					local n = 0;
					for(local i = 0; i<len; ++i){
						if(lvl[i]>lvl[i+1]){
							local temp = lvl[i];
							lvl[i] = lvl[i+1];
							lvl[i+1] = temp;

							temp = id[i];
							id[i] = id[i+1];
							id[i+1] = temp;
						}else n++;
					}
					if(n>=len) sort = false;
				}
				sendMessageToPlayer(pid, 207, 41, 66, "Dostêpni supporterzy:");
				for(local i = 0; i<id.len(); ++i){
					sendMessageToPlayer(pid, 207, 41, 66, format("(Level: %d) (%d) (%s)", lvl[i], id[i], getPlayerName(id[i])));
				}
			}else sendMessageToPlayer(pid, 207, 41, 66, "Brak dostêpnych supporterów.");
		break;

		case "report":
			if(params.len()>0 && params.len()<161){
				sendMessageToPlayer(pid, 207, 41, 66, "Raport zosta³ wys³any.");
				local string = format("Raport od (%d) %s: %s", pid, getPlayerName(pid), params);
				for(local i = 0; i<getMaxSlots(); ++i){
					if(player[i].adminIsLogged) sendMessageToPlayer(i, 128, 0, 0, string);
				}
				reportLog.enter(format("%s: %s", getPlayerName(pid), params));
			}else sendMessageToPlayer(pid, 192, 192, 192, ">Tip: /report (text 1-160)");
		break;

		/*
			Other commands end
		*/

		/*
			Fraction commands start
		*/
		
		case "fhelp":
			if(player[pid].fraction>-1){
				sendMessageToPlayer(pid, 25, 165, 111, "/f, /online, /fexit");
				if(fractions[player[pid].fraction]._leader==getPlayerName(pid)) sendMessageToPlayer(pid, 25, 165, 111, "/invite, /uninvite");
			}	
		break;
				
		case "f":
			if(player[pid].fraction>-1){
				if(params.len()>0 && params.len()<161){
					for(local i = 0; i<getMaxSlots(); ++i){
						if(player[i].fraction==player[pid].fraction) sendMessageToPlayer(pid, 25, 165, 111, format("(( (%d) %s: %s ))", pid, getPlayerName(pid), params));
					}	
				}else sendMessageToPlayer(pid, 25, 165, 111, ">Tip: /f (text 1-160)");
			}
		break;	
		
		case "fexit":
			if(player[pid].fraction>-1){
				sendMessageToPlayer(pid, 25, 165, 111, "Opuszczono frakcjê.");
				player[pid].fraction=-1;
			}
		break;	
		
		case "magazine":
			if(player[pid].fraction>-1){
				if(fractions[player[pid].fraction].magazinePosition(pid)){
					if(player[pid].fraction==0) callClientFunc(pid, "dialog.show", 11);
					else if(player[pid].fraction==1) callClientFunc(pid, "dialog.show", 12);
					player.narrator(pid, "rozmawia z magazynierem.");
				}else sendMessageToPlayer(pid, 25, 165, 111, ">Nie znajdujesz siê w magazynie swojej frakcji.");
			}
		break;	
		
		case "invite":
			if(player[pid].fraction>-1){
				if(fractions[player[pid].fraction]._leader==getPlayerName(pid)){
						local args = sscanf("d", params);
						if(args){
							if(player[args[0]].isLogged && args[0]!=pid){
								if(player[args[0]].fraction==-1){
									player[args[0]].fraction = player[pid].fraction;
									sendMessageToPlayer(pid, 25, 165, 111, format("Dodano (%d) %s do frakcji.", args[0], getPlayerName(args[0])));
									sendMessageToPlayer(args[0], 25, 165, 111, format("Gracz (%d) %s doda³ Ciê do frakcji (%d) %s.", pid, getPlayerName(pid), player[pid].fraction, fraction[[player[pid].fraction]]._name));
								}else sendMessageToPlayer(pid, 25, 165, 111, ">Gracz nale¿y ju¿ do jakiejœ frakcji.");
							}else sendMessageToPlayer(pid, 25, 165, 111, ">B³êdne ID.");
						}else sendMessageToPlayer(pid, 25, 165, 111, ">Tip: /invite (id)");
					}else sendMessageToPlayer(pid, 25, 165, 111, ">Nie jesteœ liderem frakcji.");
				}
		break;
		
		case "uninvite":
			if(player[pid].fraction>-1){
				if(fractions[player[pid].fraction]._leader==getPlayerName(pid)){
						local args = sscanf("d", params);
						if(args){
							if(player[args[0]].isLogged && args[0]!=pid){
								if(player[args[0]].fraction==player[pid].fraction){
									player[args[0]].fraction = -1;
									sendMessageToPlayer(pid, 25, 165, 111, format("Wyproszono (%d) %s z frakcji.", args[0], getPlayerName(args[0])));
									sendMessageToPlayer(args[0], 25, 165, 111, format("Gracz (%d) %s wyprosi³ Ciê z frakcji (%d) %s.", pid, getPlayerName(pid), player[pid].fraction, fraction[[player[pid].fraction]]._name));
								}else sendMessageToPlayer(pid, 25, 165, 111, ">Gracz nie nale¿y do Twojej frakcji.");
							}else sendMessageToPlayer(pid, 25, 165, 111, ">B³êdne ID.");
						}else sendMessageToPlayer(pid, 25, 165, 111, ">Tip: /uninvite (id)");
					}else sendMessageToPlayer(pid, 25, 165, 111, ">Nie jesteœ liderem frakcji.");
				}
		break;
		
		case "online":
			if(player[pid].fraction>-1){
				local count = 0;
				for(local i = 0; i<getMaxSlots(); ++i){
					if(player[i].isLogged && i!=pid){
						sendMessageToPlayer(pid, 25, 165, 111, format("- (%d) %s", i, getPlayerName(i)));
						count++;
					}
				}
				if(!count) sendMessageToPlayer(pid, 25, 165, 111, "Oprócz Ciebie ¿aden cz³onek frakcji nie jest dostêpny.");
			}
		break;
		
		/*Fraction command end
		
		*/
		
		/*
			Admin commands start
		*/

		case "alogin":
			if(player[pid].admin>0){
				if(!player[pid].adminIsLogged){
					if(player[pid].adminPassword==md5(params)){
						sendMessageToPlayer(pid, 128, 0, 0, "Zalogowano.");
						player[pid].adminIsLogged = true;
					}
				}else{
					sendMessageToPlayer(pid, 128, 0, 0, "Wylogowano.");
					player[pid].adminIsLogged = false;
				}
			}
		break;

		case "ahelp":
			if(player[pid].adminIsLogged){
				sendMessageToPlayer(pid, 128, 0, 0, " ");
				sendMessageToPlayer(pid, 128, 0, 0, "/a, /all, /search, /getip, /tp, /tppos, /kick, /ban, /block, /warn, /descdelete, /sethp");
				if(player[pid].admin>1) sendMessageToPlayer(pid, 128, 0, 0, "/setlp, /setstr, /setdex, /setwp");
				if(player[pid].admin>2){
					sendMessageToPlayer(pid, 128, 0, 0, "/giveadmin, /giveitem, /removeitem, /setserverdescription");
					sendMessageToPlayer(pid, 128, 0, 0, "/setleader, /deleteleader");
				}	
					
				sendMessageToPlayer(pid, 128, 0, 0, " ");
			}
		break;

		case "a":
			if(player[pid].adminIsLogged){
				if(params.len()>0 && params.len()<180){
					for(local i = 0; i<getMaxSlots(); ++i){
						if(player[i].adminIsLogged) sendMessageToPlayer(i, 128, 0, 0, format("(%d) %s: %s", pid, getPlayerName(pid), params));
					}
				}else sendMessageToPlayer(pid, 128, 0, 0, "Tip: /a (text)");
			}
		break;

		case "all":
			if(player[pid].adminIsLogged){
				if(params.len()>0 && params.len()<180) sendMessageToAll(pid, 207, 41, 66, format("Supporter (%d) %s: %s", pid, getPlayerName(pid), params));
				else sendMessageToPlayer(pid, 128, 0, 0, "Tip: /all (text)");
			}
		break;
		
		case "getip":
			if(player[pid].adminIsLogged){
				local args = sscanf("d", params);
				if(args){
					if(isPlayerConnected(args[0])){
						if(player[pid].admin==1) sendMessageToPlayer(pid, 128, 0, 0, censure(getPlayerIP(args[0])));
						else sendMessageToPlayer(pid, 128, 0, 0, getPlayerIP(args[0]));
					}else sendMessageToPlayer(pid, 128, 0, 0, ">Nieprawid³owe ID.");
				}else sendMessageToPlayer(pid, 128, 0, 0, "Tip: /getip (id)");
			}
		break;	

		case "tp":
			if(player[pid].adminIsLogged){
				local args = sscanf("dd", params);
				if(args){
					if(player[args[0]].isLogged){
						sendMessageToPlayer(pid, 128, 0, 0, format("Teleportowano gracza do gracza. Gracz: (%d) %s, gracz 2: (%d) (%s)", args[0], getPlayerName(args[0]),
						args[1], getPlayerName(args[1])));
						sendMessageToPlayer(args[0], 207, 41, 66, format("Supporter (%d) %s teleportowa³ Ciê do (%d) %s.", pid, getPlayerName(pid), args[1],
						getPlayerName(args[1])));
						local pos = getPlayerPosition(args[0]);
						setPlayerPosition(args[0], pos.x, pos.y, pos.z);
					}else sendMessageToPlayer(pid, 128, 0, 0, ">Nieprawid³owe ID.");
				}else sendMessageToPlayer(pid, 128, 0, 0, ">Tip: /tp (id) (id2)");
			}
		break;

		case "tppos":
			if(player[pid].adminIsLogged){
				local args = sscanf("dddd", params);
				if(args){
					if(player[args[0]].isLogged){
						sendMessageToPlayer(pid, 128, 0, 0, format("Teleportowno gracza. Gracz: (%d) %s.", args[0], getPlayerName(args[0])));
						sendMessageToPlayer(args[0], 207, 41, 66, format("Supporter (%d) %s teleportowa³ Ciê na inn¹ pozycjê.", pid, getPlayerName(pid)));
						setPlayerPosition(args[0], args[1], args[2], args[3]);
					}else sendMessageToPlayer(pid, 128, 0, 0, ">Nieprawid³owe ID.");
				}else sendMessageToPlayer(pid, 128, 0, 0, ">Tip: /tppos (id) (x) (y) (z)");
			}
		break;

		case "kick":
			if(player[pid].adminIsLogged){
				local args = sscanf("ds", params);
				if(args){
					if(isPlayerConnected(args[0])){
						sendMessageToPlayer(pid, 128, 0, 0, format("Wyrzucono gracza. Gracz: (%d) %s, powód: %s.", args[0], getPlayerName(args[0]), args[1]));
						sendMessageToAll(207, 41, 66, format("Supporter (%d) %s wyrzuci³ %s. Powód: %s", pid, getPlayerName(pid), getPlayerName(args[0]), args[1]));
						kick(args[0], args[1]);
					}else sendMessageToPlayer(pid, 128, 0, 0, ">Nieprawid³owe ID.");
				}else sendMessageToPlayer(pid, 128, 0, 0, ">Tip: /kick (id) (reason)");
			}
		break;

		case "ban":
			if(player[pid].adminIsLogged){
				local args = sscanf("dds", params);
				if(args && args[1]>0){
					if(isPlayerConnected(args[0])){
						sendMessageToPlayer(pid, 128, 0, 0, format("Zbanowano gracza. Gracz: (%d) %s, minut: %d, powód: %s.", args[0], getPlayerName(args[0]), args[1], args[2]));
						sendMessageToAll(207, 41, 66, format("Supporter (%d) %s zbanowa³ %s. Powód: %s", pid, getPlayerName(pid), getPlayerName(args[0]), args[1]));
						player[args[0]].active = 0; ban(args[0], args[1], args[2]);
					}else sendMessageToPlayer(pid, 128, 0, 0, ">Nieprawid³owe ID.");
				}else sendMessageToPlayer(pid, 128, 0, 0, ">Tip: /ban (id) (minutes) (reason)");
			}
		break;
		
		case "block":
			if(player[pid].adminIsLogged){
				local args = sscanf("ds", params);
				if(args){
					if(player[args[0]].isLogged){
						sendMessageToPlayer(pid, 128, 0, 0, format("Zablokowano gracza. Gracz: (%d) %s, minut: %d, powód: %s.", args[0], getPlayerName(args[0]), args[1]));
						sendMessageToAll(207, 41, 66, format("Supporter (%d) %s zablokowa³ %s. Powód: %s", pid, getPlayerName(pid), getPlayerName(args[0]), args[1]));
						player[args[0]].active = 0; kick(args[0], args[1]);
					}else sendMessageToPlayer(pid, 128, 0, 0, ">Nieprawid³owe ID.");
				}else sendMessageToPlayer(pid, 128, 0, 0, ">Tip: /block (id) (reason)");
			}
		break;

		case "warn":
			if(player[pid].adminIsLogged){
				local args = sscanf("ds", params);
				if(args){
					if(player[args[0]].isLogged){
						sendMessageToPlayer(pid, 128, 0, 0, format("Ostrze¿ono gracza. Gracz: (%d) %s, powód: %s.", args[0], getPlayerName(args[0]), args[1]));
						sendMessageToPlayer(args[0], 207, 41, 66, format("Supporter (%d) %s nada³ Ci ostrze¿enie. Powód: %s", pid, getPlayerName(pid), args[1]));
						sendMessageToAll(207, 41, 66, format("Supporter (%d) %s ostrzeg³ (%d) %s. Powód: %s", pid, getPlayerName(pid), args[0], getPlayerName(args[0]), args[1]));
						local pos = getPlayerPosition(pid);
						setPlayerPosition(args[0], pos.x, pos.y+300, pos.z);
					}else sendMessageToPlayer(pid, 128, 0, 0, ">Nieprawid³owe ID.");
				}else sendMessageToPlayer(pid, 128, 0, 0, ">Tip: /warn (id) (reason)");
			}
		break;

		case "descdelete":
			if(player[pid].adminIsLogged){
				local args = sscanf("d", params);
				if(args){
					if(player[args[0]].isLogged){
						sendMessageToPlayer(pid, 128, 0, 0, format("Usuniêto opis gracza. Gracz: (%d) %s.", args[0], getPlayerName(args[0])));
						sendMessageToPlayer(args[0], 207, 41, 66, format("Supporter (%d) %s usun¹³ Twój opis.", pid, getPlayerName(pid)));
						player[args[0]].description = "delete"; setPlayerColor(args[0], 250, 250, 250);
					}else sendMessageToPlayer(pid, 128, 0, 0, ">Nieprawid³owe ID.");
				}else sendMessageToPlayer(pid, 128, 0, 0, ">Tip: /descdelete (id)");
			}
		break;

		case "sethp":
			if(player[pid].adminIsLogged){
				local args = sscanf("dd", params);
				if(args){
					if(player[args[0]].isLogged){
						sendMessageToPlayer(pid, 128, 0, 0, format("Zmieniono punkty trafieñ. Gracz: (%d) %s, liczba: %d.", args[0], getPlayerName(args[0]), args[1]));
						sendMessageToPlayer(args[0], 207, 41, 66, format("Supporter (%d) %s zmieni³ Ci punkty trafieñ na %d.", pid, getPlayerName(pid), args[1]));
						setPlayerHealth(args[0], args[1]);
					}else sendMessageToPlayer(pid, 128, 0, 0, ">Nieprawid³owe ID.");
				}else sendMessageToPlayer(pid, 128, 0, 0, ">Tip: /sethp (id) (amount)");
			}
		break;

		case "setmaxhp":
			if(player[pid].adminIsLogged && player[pid].admin>1){
				local args = sscanf("dd", params);
				if(args){
					if(player[args[0]].isLogged){
						sendMessageToPlayer(pid, 128, 0, 0, format("Zmieniono maksymalne punkty trafieñ. Gracz: (%d) %s, liczba: %d.", args[0], getPlayerName(args[0]), args[1]));
						sendMessageToPlayer(args[0], 207, 41, 66, format("Supporter (%d) %s zmieni³ Ci maksymalne punkty trafieñ na %d.", pid, getPlayerName(pid), args[1]));
						setPlayerMaxHealth(args[0], args[1]);
					}else sendMessageToPlayer(pid, 128, 0, 0, ">Nieprawid³owe ID.");
				}else sendMessageToPlayer(pid, 128, 0, 0, ">Tip: /setmaxhp (id) (amount)");
			}
		break;

		case "setlp":
			if(player[pid].adminIsLogged && player[pid].admin>1){
				local args = sscanf("dd", params);
				if(args){
					if(player[args[0]].isLogged){
						sendMessageToPlayer(pid, 128, 0, 0, format("Zmieniono PN. Gracz: (%d) %s, liczba: %d.", args[0], getPlayerName(args[0]), args[1]));
						sendMessageToPlayer(args[0], 207, 41, 66, format("Supporter (%d) %s zmieni³ Ci PN na %d.", pid, getPlayerName(pid), args[1]));
						player[args[0]].pn = args[1];
					}else sendMessageToPlayer(pid, 128, 0, 0, ">Nieprawid³owe ID.");
				}else sendMessageToPlayer(pid, 128, 0, 0, ">Tip: /setlp (id) (amount)");
			}
		break;

		case "setstr":
			if(player[pid].adminIsLogged && player[pid].admin>1){
				local args = sscanf("dd", params);
				if(args){
					if(player[args[0]].isLogged){
						sendMessageToPlayer(pid, 128, 0, 0, format("Zmieniono si³ê. Gracz: (%d) %s, liczba: %d.", args[0], getPlayerName(args[0]), args[1]));
						sendMessageToPlayer(args[0], 207, 41, 66, format("Supporter (%d) %s zmieni³ Ci si³ê na %d.", pid, getPlayerName(pid), args[1]));
						setPlayerStrength(args[0], args[1]);
					}else sendMessageToPlayer(pid, 128, 0, 0, ">Nieprawid³owe ID.");
				}else sendMessageToPlayer(pid, 128, 0, 0, ">Tip: /setstr (id) (amount)");
			}
		break;

		case "setdex":
			if(player[pid].adminIsLogged && player[pid].admin>1){
				local args = sscanf("dd", params);
				if(args){
					if(player[args[0]].isLogged){
						sendMessageToPlayer(pid, 128, 0, 0, format("Zmieniono zrêcznoœæ. Gracz: (%d) %s, liczba: %d.", args[0], getPlayerName(args[0]), args[1]));
						sendMessageToPlayer(args[0], 207, 41, 66, format("Supporter (%d) %s zmieni³ Ci zrêcznoœæ na %d.", pid, getPlayerName(pid), args[1]));
						setPlayerDexterity(args[0], args[1]);
					}else sendMessageToPlayer(pid, 128, 0, 0, ">Nieprawid³owe ID.");
				}else sendMessageToPlayer(pid, 128, 0, 0, ">Tip: /setdex (id) (amount)");
			}
		break;

		case "setwp":
			if(player[pid].adminIsLogged && player[pid].admin>1){
				local args = sscanf("ddd", params);
				if(args && args[1]>-1 && args[1]<4){
					if(player[args[0]].isLogged){
						sendMessageToPlayer(pid, 128, 0, 0, format("Zmieniono umiejêtnoœæ walki broni¹. Gracz: (%d) %s, umiejêtnoœæ: %d, liczba: %d.", args[0],
						getPlayerName(args[0]), args[1], args[2]));
						sendMessageToPlayer(args[0], 207, 41, 66, format("Supporter (%d) %s zmieni³ Ci umiejêtnoœæ walki broni¹ nr %d na %d.", pid, getPlayerName(pid), args[1], args[2]));
						setPlayerSkillWeapon(args[0], args[1], args[2]);
					}else sendMessageToPlayer(pid, 128, 0, 0, ">Nieprawid³owe ID.");
				}else sendMessageToPlayer(pid, 128, 0, 0, ">Tip: /setwp (id) (nr) (amount)");
			}
		break;

		case "giveadmin":
			if(player[pid].adminIsLogged && player[pid].admin==3){
				local args = sscanf("dds", params);
				if(args && args[1]>0 && args[1]<4){
					if(player[args[0]].isLogged){
							sendMessageToPlayer(pid, 128, 0, 0, format("NADANO ADMINISTRATORA. GRACZ: (%d) %s, POZIOM: %d.", args[0], getPlayerName(args[0]), args[1]));
							player[args[0]].admin = args[1];
							player[args[0]].password = md5(args[2]);
					}else sendMessageToPlayer(pid, 128, 0, 0, ">Nieprawid³owe ID.");
				}else sendMessageToPlayer(pid, 128, 0, 0, ">Tip: /giveadmin (id) (level 1-3) (password)");
			}
		break;

		case "giveitem":
			if(player[pid].adminIsLogged && player[pid].admin==3){
			local args = sscanf("dds", params);
			if(args){
				if(player[args[0]].isLogged){
					if(item.hasPlace(args[0])){
						sendMessageToPlayer(pid, 128, 0, 0, format("Podarowano przedmiot. Gracz: (%d) %s, instancja: %s, liczba: %d.", args[0], getPlayerName(args[0]), args[2], args[1]));
						sendMessageToPlayer(pid, 207, 41, 66, format("Supporter (%d) %s podarowa³ Ci przedmiot/y %s w liczbie %d.", pid, getPlayerName(pid), args[2], args[1]));
						item.give(args[0], true, args[2], args[1]);
					}else sendMessageToPlayer(pid, 128, 0, 0, ">Gracz nie ma miejsca w EQ.");
				}else sendMessageToPlayer(pid, 128, 0, 0, ">Nieprawid³owe ID.");
			}else sendMessageToPlayer(pid, 128, 0, 0, ">Tip: /giveitem (id) (amount) (instance)");
		}
		break;

		case "removeitem":
			if(player[pid].adminIsLogged && player[pid].admin==3){
			local args = sscanf("dds", params);
			if(args){
				if(player[args[0]].isLogged){
					sendMessageToPlayer(pid, 128, 0, 0, format("Zabrano przedmiot. Gracz: (%d) %s, instancja: %s, liczba: %d.", args[0], getPlayerName(args[0]), args[2], args[1]));
					sendMessageToPlayer(pid, 207, 41, 66, format("Supporter (%d) %s usun¹³ Ci przedmiot/y %s w liczbie %d.", pid, getPlayerName(pid), args[2], args[1]));
					item.remove(args[0], true, args[2], args[1]);
				}else sendMessageToPlayer(pid, 128, 0, 0, ">Nieprawid³owe ID.");
			}else sendMessageToPlayer(pid, 128, 0, 0, ">Tip: /removeitem (id) (amount) (instance)");
		}
		break;

		case "setserverdescription":
			if(player[pid].adminIsLogged && player[pid].admin==3){
				if(params && params.len()<180){
					sendMessageToPlayer(pid, 128, 0, 0, format("Zmieniono opis serwera. Tekst: %s", params));
					setServerDescription(params);
				}else sendMessageToPlayer(pid, 128, 0, 0, ">Tip: /setserverdescription (text)");
			}
		break;
		
		case "setleader":
			if(player[pid].adminIsLogged && player[pid].admin==3){
				local args = sscanf("dd", params);
				if(args){
					if(player[args[0]].isLogged){
					if(args[1]<fractions.len()){
							fractions[args[1]].setLeader(getPlayerName(args[0]));
							player[args[0]].fraction = args[1];
							sendMessageToPlayer(pid, 128, 0, 0, format("Zmieniono lidera frakcji. Gracz: (%d) %s, frakcja (%d) %s.", args[0], getPlayerName(args[0]), args[1], fractions[args[1]]._name));
							sendMessageToPlayer(args[0], 207, 41, 66, format("Supporter (%d) %s mianowa³ Ciê liderem frakcji %s.", pid, getPlayerName(pid), fractions[args[1]]._name));
						}else sendMessageToPlayer(pid, 128, 0, 0, ">Nie istnieje frakcja o podanym ID.");
					}else sendMessageToPlayer(pid, 128, 0, 0, ">B³êdne ID.");
				}else sendMessageToPlayer(pid, 128, 0, 0, ">Tip: /setleader (id) (fraction id)");
			}
		break;

		case "deleteleader":
			if(player[pid].adminIsLogged && player[pid].admin==3){
				local args = sscanf("d", params);
				if(args){
					if(player[args[0]].isLogged){
					if(args[1]<fractions.len()){
							sendMessageToPlayer(pid, 128, 0, 0, format("Usuniêto lidera. Frakcja (%d) %s", args[1], fractions[args[1]]._name));
							fractions[args[1]].setLeader("");
						}else sendMessageToPlayer(pid, 128, 0, 0, ">Nie istnieje frakcja o podanym ID.");
					}else sendMessageToPlayer(pid, 128, 0, 0, ">B³êdne ID.");
				}else sendMessageToPlayer(pid, 128, 0, 0, ">Tip: /delete (fraction id)");
			}
		break;
		
		/*
			Admin commands end
		*/

		}
	}
});

addEventHandler("onPlayerRespawn", function(pid){
	setPlayerVisual(pid, player[pid].visual[0], player[pid].visual[1], player[pid].visual[2], player[pid].visual[3]);
	for(local i = 0; i<item[pid].instance.len(); ++i){
		item.give(pid, false, item[pid].instance[i], item[pid].amount[i]);
	}
});

function onPlayerDialogBoxResponse(pid, id, position){
	if(id==0){
		switch(position){
			case 0: player[pid].sex=1; callClientFunc(pid, "dialog.show", 1); break;
			case 1: player[pid].sex=2; callClientFunc(pid, "dialog.show", 1); break;
		}
	}
	else if(id==1){
		switch(position){
			case 0: player[pid].race=1; player.registerEnd(pid); break;
			case 1: player[pid].race=2; player.registerEnd(pid); break;
			case 2: player[pid].race=3; player.registerEnd(pid); break;
			case 3: player[pid].race=4; player.registerEnd(pid); break;
		}
	}
	else if(id==2){
		if(position!=7){
			if(player[pid].pn>0){
				player[pid].pn--;
				sendMessageToPlayer(pid, 194, 178, 128, "Podniesiono poziom umiejêtnoœci.");
				switch(position){
					case 0: setPlayerMaxHealth(pid, player[pid].maxHealth+1); break;
					case 1: setPlayerStrength(pid, player[pid].strength+1); break;
					case 2: setPlayerDexterity(pid, player[pid].dexterity+1); break;
					case 3: setPlayerSkillWeapon(pid, 0, player[pid].skillWeapon[0]+1); break;
					case 4: setPlayerSkillWeapon(pid, 1, player[pid].skillWeapon[1]+1); break;
					case 5: setPlayerSkillWeapon(pid, 2, player[pid].skillWeapon[2]+1); break;
					case 6: setPlayerSkillWeapon(pid, 3, player[pid].skillWeapon[3]+1); break;
					}
				}else sendMessageToPlayer(pid, 192, 192, 192, ">Nie posiadasz ¿adnych punktów nauki.");
			}else callClientFunc(pid, "dialog.destroy");
	}else if(id==3){
			switch(position){
				case 0: item.buy(pid, 2, "ITFO_FISH", 1); break;
				case 1: item.buy(pid, 3, "ITFO_BREAD", 1); break;
				case 2: item.buy(pid, 5, "ITFO_HONEY", 1); break;
				case 3: item.buy(pid, 5, "ITFO_CHEESE", 1); break;
				case 4: callClientFunc(pid, "dialog.destroy");
			}
	}else if(id==4){
			switch(position){
				case 0: item.buy(pid, 3, "ITPO_SPEED", 1); break;
				case 1: item.buy(pid, 15, "ITPO_HEALTH_01", 1); break;
				case 2: item.buy(pid, 25, "ITPO_HEALTH_03", 1); break;
				case 3: item.buy(pid, 25, "ITFO_ADDON_SCHLAFHAMMER", 1); break;
				case 4: callClientFunc(pid, "dialog.destroy");
			}
	}else if(id==5){
			switch(position){
				case 0: item.buy(pid, 100, "ITAR_VLK_L", 1); break;
				case 1: item.buy(pid, 220, "ITAR_LEATHER_L", 1); break;
				case 2: item.buy(pid, 600, "ITAR_DIEGO", 1); break;
				case 3: item.buy(pid, 12000, "ITAR_OREBARON_ADDON", 1); break;
				case 4: item.buy(pid, 13000, "ITAR_DJG_CRAWLER", 1); break;
				case 5: callClientFunc(pid, "dialog.destroy");
			}
	}else if(id==6){
			switch(position){
				case 0: item.buy(pid, 12, "ITMW_1H_BAU_MACE", 1); break;
				case 1: item.buy(pid, 110, "ITMW_1H_MISC_AXE", 1); break;
				case 2: item.buy(pid, 170, "ITMW_1H_SWORD_L_03", 1); break;
				case 3: item.buy(pid, 800, "ITMW_2H_SWORD_M_01", 1); break;
				case 4: item.buy(pid, 1200, "ITMW_SHORTSWORD5", 1); break;
				case 5: item.buy(pid, 9500, "ITMW_ADDON_PIR2HAXE", 1); break;
				case 6: item.buy(pid, 10000, "ITMW_ADDON_PIR1HSWORD", 1); break;
				case 7: callClientFunc(pid, "dialog.destroy");
			}
	}else if(id==7){
			switch(position){
				case 0: item.buy(pid, 25, "ITRW_ARROW", 25); break;
				case 1: item.buy(pid, 25, "ITRW_BOLT", 25); break;
				case 2: item.buy(pid, 70, "ITRW_BOW_L_01", 1); break;
				case 3: item.buy(pid, 90, "ITRW_CROSSBOW_L_01", 1); break;
				case 4: callClientFunc(pid, "dialog.destroy");
			}
	}else if(id==8){
		switch(position){
			case 0:
				if(item[pid].instance.len()>0) callClientFunc(pid, "dialog.show", 9);
				else sendMessageToPlayer(pid, 192, 192, 192, ">Nie posiadasz ¿adnego EQ.");
			break;
			case 1:
				local packet = bank.depositPacket(pid);
				if(packet) callClientFunc(pid, "dialog.show", 10, packet);
				else sendMessageToPlayer(pid, 192, 192, 192, ">Nie posiadasz ¿adnego depozytu w banku.");
			break;
			case 2: callClientFunc(pid, "dialog.destroy");
		}
	}else if(id==9){
		if(position!=item[pid].instance.len()){
			if(position<=item[pid].instance.len()){
				if(bank[pid].instance.len()<60){
					sendMessageToPlayer(pid, 194, 178, 128, "Zdeponowano przedmiot.");
					item.remove(pid, false, item[pid].instance[position], 1);
					local index = bank[pid].instance.find(item[pid].instance[position]);
					if(index!=null) bank[pid].amount[index]++;
					else{
						bank[pid].instance.push(item[pid].instance[position]);
						bank[pid].amount.push(1);
					}
					callClientFunc(pid, "bankRefresh", 0);
				}else sendMessageToPlayer(pid, 192, 192, 192, ">Brak miejsca w banku.");
			}
		}else callClientFunc(pid, "dialog.destroy");
	}else if(id==10){
		if(position!=bank[pid].instance.len()){
			if(position<=bank[pid].instance.len()){
				if(item.hasPlace(pid)){
					sendMessageToPlayer(pid, 194, 178, 128, "Odebrano przedmiot.");
					item.give(pid, false, bank[pid].instance[position], 1);
					local index = bank[pid].instance.find(bank[pid].instance[position]);
					if(index!=null){
						if(bank[pid].amount[index]>1) bank[pid].amount[index]--;
						else{
							bank[pid].instance.remove(index);
							bank[pid].amount.remove(index);
						}
					}
					bank.depositPacketSend(pid);
				}else sendMessageToPlayer(pid, 192, 192, 192, ">Brak miejsca w EQ.");
			}else sendMessageToPlayer(pid, 192, 192, 192, ">Nie posiadasz wiêcej depozytu w banku.");
		}else callClientFunc(pid, "dialog.destroy");
	}else if(id==11){
		switch(position){
			case 0: item.buy(pid, 100, "ITMW_SHORTSWORD1", 1); break;
			case 1: item.buy(pid, 700, "ITAR_MIL_L", 1); break;
			case 2: item.buy(pid, 13500, "ITAR_MIL_M", 1); break;
			case 3: callClientFunc(pid, "dialog.destroy"); break;
		}
	}else if(id==12){
		switch(position){
			case 0: item.buy(pid, 9700, "ITMW_1H_PAL_SWORD", 1); break;
			case 1: item.buy(pid, 12000, "ITMW_2H_PAL_SWORD", 1); break;
			case 2: item.buy(pid, 20000, "ITAR_PAL_M", 1); break;
			case 3: item.buy(pid, 35000, "ITAR_PAL_H", 1); break;
			case 4: callClientFunc(pid, "dialog.destroy"); break;
		}
	}
}
