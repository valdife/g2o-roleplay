local _setPlayerVisual = setPlayerVisual, _setPlayerHealth = setPlayerHealth, _setPlayerMaxHealth = setPlayerMaxHealth, _setPlayerStrength = setPlayerStrength, _setPlayerDexterity = setPlayerDexterity, _setPlayerSkillWeapon = setPlayerSkillWeapon;

function setPlayerVisual(pid, bodyModel, bodyTxt, headModel, headTxt){
  player[pid].visual[0] = bodyModel;
  player[pid].visual[1] = bodyTxt;
  player[pid].visual[2] = headModel;
  player[pid].visual[3] = headTxt;
  _setPlayerVisual(pid, bodyModel, bodyTxt, headModel, headTxt);
}

function setPlayerHealth(pid, health){
  player[pid].health = health;
  _setPlayerHealth(pid, health);
}

function setPlayerMaxHealth(pid, maxHealth){
  player[pid].maxHealth = maxHealth;
  _setPlayerMaxHealth(pid, maxHealth);
}

function setPlayerStrength(pid, strength){
  player[pid].strength = strength;
  _setPlayerStrength(pid, strength);
}

function setPlayerDexterity(pid, dexterity){
  player[pid].dexterity = dexterity;
  _setPlayerDexterity(pid, dexterity);
}

function setPlayerSkillWeapon(pid, skillId, value){
  player[pid].skillWeapon[skillId] = value;
  _setPlayerSkillWeapon(pid, skillId, value);
}
