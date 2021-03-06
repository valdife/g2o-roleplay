local draw3d = [];

local function draw3dCreate(x, y, z, text, r, g, b){
  draw3d.push(Draw3d(x, y, z));
	local len = draw3d.len()-1;
  if(text.len()>50){
    if(text[50].tochar()!=" ") draw3d[len].insertText(text.slice(0, 50) + "-");
		else draw3d[len].insertText(text.slice(0, 50));
    if(text.len()>100) draw3d[len].insertText(text.slice(50, 100));
    else draw3d[len].insertText(text.slice(50, text.len()));
  }else draw3d[len].insertText(text);
  draw3d[len].setColor(r, g, b);
  draw3d[len].visible = true;
}

function draw3dInit(){
	//learn
  draw3dCreate(3711, -88, 3377, "Spotykasz nauczyciela ((/learn))", 184, 129, 238);
  draw3dCreate(4448, 848, 7214, "Spotykasz nauczyciela ((/learn))", 184, 129, 238);
  draw3dCreate(13292, 1186, -499, "Spotykasz nauczyciela ((/learn))", 184, 129, 238);
	draw3dCreate(74647, 3501, -14690, "Spotykasz nauczyciela ((/learn))", 184, 129, 238);
	
  //food
  draw3dCreate(2000, -20, -2039, "Spotykasz handlarza �ywno�ci� ((/buy))", 184, 129, 238);
  draw3dCreate(-231, -15, -5116, "Spotykasz handlarza �ywno�ci� ((/buy))", 184, 129, 238);
  draw3dCreate(8459, 434, 4517, "Spotykasz handlarza �ywno�ci� ((/buy))", 184, 129, 238);
  draw3dCreate(10427, 451, 4718, "Spotykasz handlarza �ywno�ci� ((/buy))", 184, 129, 238);
  draw3dCreate(7193, 429, -5068, "Spotykasz handlarza �ywno�ci� ((/buy))", 184, 129, 238);
  draw3dCreate(12659, 998, 3246, "Spotykasz handlarza �ywno�ci� ((/buy))", 184, 129, 238);
	draw3dCreate(72117, 3348, -8849, "Spotykasz handlarza �ywno�ci� ((/buy))", 184, 129, 238);

	//potion
  draw3dCreate(9249, 437, 4429, "Spotykasz handlarza miksturami ((/buy))", 184, 129, 238);
	draw3dCreate(72135, 3344, -11747, "Spotykasz handlarza miksturami ((/buy))", 184, 129, 238);

	//work
  draw3dCreate(6336, 368, -2584, "Wygl�da na to, �e mo�na tu zarobi� ((/work))", 184, 129, 238);
  draw3dCreate(12358, 998, -1804, "Wygl�da na to, �e mo�na tu zarobi� ((/work))", 184, 129, 238);
	draw3dCreate(71361, 3264, -10646, "Wygl�da na to, �e mo�na tu zarobi� ((/work))", 184, 129, 238);
	
	//cloth
  draw3dCreate(5739, 368, -4389, "Znajdujesz si� w sklepie z pancerzami ((/buy))", 184, 129, 238);

  //weapon
  draw3dCreate(9172, 433, 5652, "Spotykasz handlarza broni ((/buy))", 184, 129, 238);

  //fletcher
  draw3dCreate(10327, 437, 4086, "Spotykasz handlarza �ukami i kuszami ((/buy))", 184, 129, 238);
  draw3dCreate(8155, 368, -3356, "Znajdujesz si� w sklepie z �ukami i kuszami ((/buy))", 184, 129, 238);

  //lottery
  draw3dCreate(3123, -7, -2525, "Mieszkaj�cy tu cz�owiek co jaki� czas organizuje loteri�. ((/lottery))", 184, 129, 238);

  //roulette
  draw3dCreate(1368, 5, -538, "Na stole znajduje si� prowizoryczna wersja ruletki ((/roulette))", 184, 129, 238);
	draw3dCreate(72010, 3332, -13008, "Na stole znajduje si� prowizoryczna wersja ruletki ((/roulette))", 184, 129, 238);
	
  //bank
  draw3dCreate(8734, 456, 3704, "Z dalekich krain do Khorinis trafi� system bankowy ((/bank))", 184, 129, 238);
	draw3dCreate(38087, 4015, -2493, "Z dalekich krain do Khorinis trafi� system bankowy ((/bank))", 184, 129, 238);
	
  //brothel
  draw3dCreate(793, 15, -2842, "Us�uga 150 szt. z�. ((/brothel))", 184, 129, 238);

  //blacktrader
  draw3dCreate(4785, 9, -4334, "Podejrzany cz�owiek z wypchanym worem. ((/blacktrader))", 184, 129, 238);
	draw3dCreate(73423, 3262, -8850, "Podejrzany cz�owiek z wypchanym worem. ((/blacktrader))", 184, 129, 238);
	
  //drunk
  draw3dCreate(8720, 314, 1486, "Lokalni pijacy zak�adaj� si� o to, kto wypije wi�cej Lou za 2 szt. z�. ((/drunk))", 184, 129, 238);
	draw3dCreate(72512, 3339, -9390, "Lokalni pijacy zak�adaj� si� o to, kto wypije wi�cej Lou za 2 szt. z�. ((/drunk))", 184, 129, 238);
	
  //citizen
  draw3dCreate(3335, 848, 6409, "W tym miejscu mo�esz zarejestrowa� si� jako obywatel miasta ((/citizen))", 184, 129, 238);
	
	//fraction shop
	draw3dCreate(6395, 917, 7391, "W tym miejscu mo�esz zdoby� wyposa�enie frakcyjne ((/magazine))" 184, 129, 238);
	draw3dCreate(14420, 1202, -203, "W tym miejscu mo�esz zdoby� wyposa�enie frakcyjne ((/magazine))", 184, 129, 238);
	draw3dCreate(71048, 3248, -9461, "W tym miejscu mo�esz zdoby� wyposa�enie frakcyjne ((/magazine))", 184, 129, 238);
	
	//beer
	draw3dCreate(5913, 473, 2654, "Piwo za 1 szt. z�. ((/beer))", 184, 129, 238);
}
