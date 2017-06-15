position <- {};
local positions = {};

local function positionCreate(name, x, y, z){
  positions[name][positions[name].len()] <- [x, y, z];
}

function position::init(){
  positions["work"] <- {};
  positionCreate("work", 6336, 368, -2584);
  positionCreate("work", 12358, 998, -1804);

  positions["learn"] <- {};
  positionCreate("learn", 3711, -88, 3377);
  positionCreate("learn", 4448, 848, 7214);
  positionCreate("learn", 13292, 1186, -499);

  positions["food"] <- {};
  positionCreate("food", 2000, -20, -2039);
  positionCreate("food", -231, -15, -5116);
  positionCreate("food", 8459, 434, 4517);
  positionCreate("food", 10427, 451, 4718);
  positionCreate("food", 7193, 429, -5068);
  positionCreate("food", 12659, 998, 3246);

  positions["potion"] <- {};
  positionCreate("potion", 9249, 437, 4429);

  positions["cloth"] <- {};
  positionCreate("cloth", 5739, 368, -4389);

  positions["weapon"] <- {};
  positionCreate("weapon", 9172, 433, 5652);

  positions["fletcher"] <- {};
  positionCreate("fletcher", 10327, 437, 4086);
  positionCreate("fletcher", 8155, 368, -3356);

  positions["lottery"] <- {};
  positionCreate("lottery", 3123, -7, -2525);

  positions["roulette"] <- {};
  positionCreate("roulette", 1368, 5, -538);

  positions["bank"] <- {};
  positionCreate("bank", 8734, 456, 3704);

  positions["brothel"] <- {};
  positionCreate("brothel", 793, 15, -2842);

  positions["blacktrader"] <- {};
  positionCreate("blacktrader", 4785, 9, -4334);

  positions["drunk"] <- {};
  positionCreate("drunk", 8720, 314, 1486);
}

function position::get(pid, name){
  local pos = getPlayerPosition(pid);
  for(local i = 0; i<positions[name].len(); ++i){
    if(getDistance3d(pos.x, pos.y, pos.z, positions[name][i][0], positions[name][i][1], positions[name][i][2])<600) return 1;
  }
}
