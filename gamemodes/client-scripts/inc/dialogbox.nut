dialog <- {
	active = null,
	texture = Texture(0, 0, 500, 500, "DLG_CONVERSATION.TGA"),
	draw = {},
	text = {},
	maxPosition = 6,
	drawPosition = 0,
	position = 0
}

function dialog::create(id, ...){
	if(active!=null) destroy();
	setFreeze(true);
	draw[0] <- Draw(0, 0, "QWERTYUIOPASDFGHJKLZXCVBNM");

	local textureHeight = 0,
	textureY = getResolution().y/2-textureHeight,
	drawHeight = draw[0].heightPx;

	if(vargv.len()>=maxPosition) textureHeight = drawHeight*maxPosition;
	else textureHeight = drawHeight*vargv.len();

	draw.rawdelete([0]);
	texture.setPositionPx(0, textureY);
	texture.setSizePx(getResolution().x, textureHeight);
	texture.visible = true;

	local longestDraw = 0;

	for(local i = 0; i<vargv.len(); ++i){
		text[i] <- vargv[i];
		if(i<maxPosition){
			draw[i] <- Draw(0, 0, vargv[i]);
			if(draw[i].widthPx>longestDraw) longestDraw = draw[i].widthPx;
		}
	}

	local resolutionXHalf = (getResolution().x/2)-(longestDraw/2);
	for(local i = 0; i<draw.len(); ++i){
		draw[i].setPositionPx(resolutionXHalf, texture.getPositionPx().y+(drawHeight*i));
		draw[i].visible = true;
	}

	draw[0].setColor(255, 255, 0);
	active = id;
}

function dialog::destroy(){
	texture.visible = false;
	for(local i = 0; i<draw.len(); ++i){
		draw[i].visible = false;
	}
	if(position!=0 && position<maxPosition) draw[position].setColor(255, 255, 255);
	drawPosition = 0;
	position = 0;
	draw.clear();
	text.clear();
	active = null;
	setFreeze(false);
}

function dialog::switcher(select){
	draw[drawPosition].setColor(255, 255, 255);
	if(select){
		position++;
		if(drawPosition<(maxPosition-1)) drawPosition++;
		else if(position>=maxPosition && drawPosition==(maxPosition-1)){
			for(local i = 0; i<maxPosition; i++){
				draw[i].text = text[(position-maxPosition+i)+1];
			}
		}
	}
	else{
		if(drawPosition==0){
			for(local i = 0; i<maxPosition; i++){
				draw[i].text = text[(position+i)-1];
			}
		}
		position--;
		if(drawPosition>0) drawPosition--;
	}
	draw[drawPosition].setColor(255, 255, 0);
}

function dialog::show(id, ...){
	switch(id){
		case 0: 
			Chat.print(194, 178, 128, "Zarejestrowano konto. Wybierz p³eæ postaci.");
			create(0, "Mê¿czyzna", "Kobieta"); 
		break;
		case 1:
			Chat.print(194, 178, 128, "Wybierz kolor skóry.");
			create(1, "Bia³y", "Bia³y opalony", "Latynoski", "Czarny"); 
		break;
		case 2: create(2, "Punkty trafieñ", "Si³a", "Zrêcznoœæ", "Broñ jednorêczna", "Broñ dwurêczna", "£ucznictwo",
		"Kusznictwo", "Opuœæ"); break;
		case 3: create(3, "Ryba 2 szt. z³.", "Chleb 3 szt. z³.", "Miód 5 szt. z³", "Ser 5 szt. z³.", "Opuœæ"); break;
		case 4: create(4, "Mikstura szybkoœci 3 szt. z³.", "Esencja lecznicza 15 szt. z³.", "Eliksir leczniczy 25 szt. z³", "Podwójny M³ot 25 szt. z³" "Opuœæ"); break;
		case 5: create(5, "Strój obywatela 100 szt. z³.", "Skórzany pancerz 220 szt. z³", "Pancerz Diega 600 szt. z³." "Opuœæ"); break;
		case 6: create(6, "Laga 12 szt. z³.", "Zardzewia³y topór 110 szt. z³.", "Nó¿ na wilki 170 szt. z³.", "Opuœæ"); break;
		case 7: create(7, "25 strza³ 25 szt. z³.", "25 be³tów 25 szt. z³.", "Krótki ³uk 70 szt. z³.", "Kusza myœliwska 90 szt. z³.", "Opuœæ"); break;
		case 8: create(8, "Zdeponuj przedmiot", "Odbierz przedmiot", "Opuœæ"); break;
		case 9:
			local eq = getEq(), i = 0, func = "create(9,";
			if(eq.len()>0){
				foreach(item in eq){
					if(i<30) func += format("\"%s - %d sztuk\",", item.instance.toupper(), item.amount);
					else break;
					++i;
				}
				func += "\"Opuœæ\");";
				local compiledScript = compilestring(func);
				compiledScript();
			}else{
				Chat.print(192, 192, 192, ">Nie posiadasz wiêcej itemów w ekwipunku.");
				dialog.destroy();
			}
		break;
		case 10:
			local deposit = split(vargv[0], "."), eq, func = "create(10,";
			for(local i = 0; i<deposit.len(); ++i){
				eq = split(deposit[i], ":");
				func += format("\"%s - %s sztuk\",", Items.name(eq[0].tointeger()), eq[1]);
			}
			func += "\"Opuœæ\");";
			local compiledScript = compilestring(func);
			compiledScript();
		break;
	}
}
