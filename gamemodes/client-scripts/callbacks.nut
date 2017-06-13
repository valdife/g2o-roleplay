addEventHandler("onInit", function(){
	Chat.print(194, 178, 128,  "U¿yj komendy /register (nick) (password), by zarejestrowaæ now¹ postaæ.");
	Chat.print(194, 178, 128, "Jeœli ju¿ j¹ posiadasz, u¿yj /login (nick) (password)");
	Chat.print(194, 178, 128, "Po zalogowaniu pamiêtaj o komendzie /help.");
	disableKey(KEY_C, true);
	disableKey(KEY_L, true);
	setFreeze(true);
	draw3dInit();
	helloShow();
	setPlayerPosition(heroId, -1158, -522, -730);
	setPlayerAngle(heroId, 90);

	enableEvent_Render(true);
});

addEventHandler("onCommand", function(cmd, params){
	switch(cmd){
		case "q":
		case "quit":
			exitGame();
		break;

		case "fps":
			Chat.print(194, 178, 128, getFpsRate());
		break;

		case "position":
			local pos = getPlayerPosition(heroId);
			Chat.print(194, 178, 128, format("X, Y, Z: %d, %d, %d", pos.x, pos.y, pos.z));
		break;

		case "angle":
			Chat.print(194, 178, 128, getPlayerAngle(heroId));
		break;

		case "help":
			Chat.print(213, 173, 66, " ");
			Chat.print(213, 173, 66, "Czaty: /w, /s, /ear, /me, /do, /try, /pm, /b, /report");
			Chat.print(213, 173, 66, "Inne: /trade, /bones, /description, /anims, /admins");
			Chat.print(213, 173, 66, "Dostêpne emotikony na czacie: :), :(");
			Chat.print(213, 173, 66, "Payday w postaci PN i paru sztuk z³ota rozdawany jest co godzinê gry.");
			Chat.print(213, 173, 66, "Gdy gracz posiada ró¿owy nick opisa³ swoj¹ postaæ. Aby odczytaæ - klawisz O.");
			Chat.print(213, 173, 66, " ");
		break;

		case "anims":
			Chat.print(213, 173, 66, " ");
			Chat.print(213, 173, 66, "@legshake, @scratchegg, @lookleft, @lookright, @lookdown, @scratchshoulder");
			Chat.print(213, 173, 66, "@scratchhead, @rolex, @broom, @dead, @dead2, @wounded, @dontshoot, @horn");
			Chat.print(213, 173, 66, "@pray, @pray2, @get, @guard, @guard2, @map, @pee, @wash, @watchfight");
			Chat.print(213, 173, 66, "@dance, @dance2, @dontknow, @forget, @great, @noentry, @no, @plunder");
			Chat.print(213, 173, 66, "@search, @yes, @kick, @sit, @sleep");
			Chat.print(213, 173, 66, " ");
		break;
	}
});

addEventHandler("onKey", function(key){
	if(dialog.active!=null){
		switch(key){
			case KEY_DOWN:
				if(dialog.position<(dialog.text.len()-1)) dialog.switcher(true);
			break;

			case KEY_UP:
				if(dialog.position>0) dialog.switcher(false);
			break;

			case KEY_RETURN:
				callServerFunc("onPlayerDialogBoxResponse", heroId, dialog.active, dialog.position);
			break;
		}
	}

	if(!chatInputIsOpen()){
		if(key==KEY_B){
			if (Chat.visible){
				chatInputOpen();
				chatInputSetText("/b ");
				disableControls(false);
			}
		}
		else if(key==KEY_O){
			callServerFunc("player.description", heroId);
		}
		else if(key==KEY_C){
			callServerFunc("player.showStats", heroId);
		}
	}
});

addEventHandler("onUseItem", function(instance, amount, hand){
	itemSave();
	if(instance=="ITFO_ADDON_SCHLAFHAMMER"){
		lou();
	}
});

addEventHandler("onTakeItem", function(instance, amount){
	cancelEvent();
});

addEventHandler("onDropItem", function(instance, amount){
	cancelEvent();
});
