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

  //food
  draw3dCreate(2000, -20, -2039, "Spotykasz handlarza ¿ywnoœci¹ ((/buy))", 184, 129, 238);
  draw3dCreate(-231, -15, -5116, "Spotykasz handlarza ¿ywnoœci¹ ((/buy))", 184, 129, 238);
  draw3dCreate(8459, 434, 4517, "Spotykasz handlarza ¿ywnoœci¹ ((/buy))", 184, 129, 238);
  draw3dCreate(10427, 451, 4718, "Spotykasz handlarza ¿ywnoœci¹ ((/buy))", 184, 129, 238);
  draw3dCreate(7193, 429, -5068, "Spotykasz handlarza ¿ywnoœci¹ ((/buy))", 184, 129, 238);
  draw3dCreate(12659, 998, 3246, "Znajdujesz siê w sklepie z ¿ywnoœci¹ ((/buy))", 184, 129, 238);

	//potion
  draw3dCreate(9249, 437, 4429, "Spotykasz handlarza miksturami ((/buy))", 184, 129, 238);

	//work
  draw3dCreate(6336, 368, -2584, "Wygl¹da na to, ¿e mo¿na tu zarobiæ ((/work))", 184, 129, 238);
  draw3dCreate(12358, 998, -1804, "Wygl¹da na to, ¿e mo¿na tu zarobiæ ((/work))", 184, 129, 238);

	//cloth
  draw3dCreate(5739, 368, -4389, "Znajdujesz siê w sklepie z pancerzami ((/buy))", 184, 129, 238);

  //weapon
  draw3dCreate(9172, 433, 5652, "Spotykasz handlarza broni ((/buy))", 184, 129, 238);

  //fletcher
  draw3dCreate(10327, 437, 4086, "Spotykasz handlarza ³ukami i kuszami ((/buy))", 184, 129, 238);
  draw3dCreate(8155, 368, -3356, "Znajdujesz siê w sklepie z ³ukami i kuszami ((/buy))", 184, 129, 238);

  //lottery
  draw3dCreate(3123, -7, -2525, "Mieszkaj¹cy tu cz³owiek co jakiœ czas organizuje loteriê. ((/lottery))", 184, 129, 238);

  //roulette
  draw3dCreate(1368, 5, -538, "W karczmie jest t³oczno, na stole znajduje siê prowizoryczna wersja ruletki ((/roulette))", 184, 129, 238);

  //bank
  draw3dCreate(8734, 456, 3704, "Z dalekich krain do Khorinis trafi³ system bankowy ((/bank))", 184, 129, 238);

  //brothel
  draw3dCreate(793, 15, -2842, "Us³uga 150 szt. z³. ((/brothel))", 184, 129, 238);

  //blacktrader
  draw3dCreate(4785, 9, -4334, "Podejrzany cz³owiek z wypchanym worem. ((/blacktrader))", 184, 129, 238);

  //drunk
  draw3dCreate(8720, 314, 1486, "Lokalni pijacy zak³adaj¹ siê o to, kto wypije wiêcej Lou za 2 szt. z³. ((/drunk))", 184, 129, 238);

  //citizen
  draw3dCreate(3335, 848, 6409, "W tym miejscu mo¿esz zarejestrowaæ siê jako obywatel miasta ((/citizen))", 184, 129, 238);
  
}
