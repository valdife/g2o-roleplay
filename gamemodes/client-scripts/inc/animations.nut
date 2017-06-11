local animations = ["legshake", "scratchegg", "lookleft", "lookright", "lookdown", "scratchshoulder", "scratchhead", "rolex", "broom",
"dead", "dead2", "wounded", "dontshoot", "horn", "pray", "pray2", "get", "guard", "guard2", "map", "pee", "wash", "watchfight", "dance",
"dance2", "dontknow", "forget", "great", "noentry", "no", "plunder", "search", "yes", "kick", "sit", "sleep"];

function animations(id){
	local instance = animations[id];
	switch(instance){
		case "legshake": playAni(heroId, "R_LEGSHAKE"); return 1;
		case "scratchegg": playAni(heroId, "R_SCRATCHEGG"); return 1;
		case "lookleft": playAni(heroId, "C_LOOK_1"); return 1;
		case "lookright": playAni(heroId, "C_LOOK_3"); return 1;
		case "lookdown": playAni(heroId, "S_BARBQ_S0"); return 1;
		case "scratchshoulder": playAni(heroId, "R_SCRATCHLSHOULDER"); return 1;
		case "scratchhead": playAni(heroId, "R_SCRATCHHEAD"); return 1;
		case "rolex": playAni(heroId, "S_BARBQ_S1"); return 1;
		case "broom": playAni(heroId, "S_BROOM_S1"); return 1;
		case "dead": playAni(heroId, "S_DEAD"); return 1;
		case "dead2": playAni(heroId, "S_DEADB"); return 1;
		case "wounded": playAni(heroId, "T_STAND_2_WOUNDEDB"); return 1;
		case "dontshoot": playAni(heroId, "S_FEASHOOT"); return 1;
		case "horn": playAni(heroId, "S_HORN_S1"); return 1;
		case "pray": playAni(heroId, "S_INNOS_S1"); return 1;
		case "pray2": playAni(heroId, "S_IDOL_S1"); return 1;
		case "get": playAni(heroId, "S_IGET"); return 1;
		case "guard": playAni(heroId, "S_HGUARD"); return 1;
		case "guard2": playAni(heroId, "S_LGUARD"); return 1;
		case "map": playAni(heroId, "S_MAP_S0"); return 1;
		case "pee": playAni(heroId, "S_PEE"); return 1;
		case "wash": playAni(heroId, "S_WASH"); return 1;
		case "watchfight": playAni(heroId, "S_WATCHFIGHT"); return 1;
		case "dance": playAni(heroId, "T_DANCE_01"); return 1;
		case "dance2": playAni(heroId, "T_DANCE_04"); return 1;
		case "dontknow": playAni(heroId, "T_DONTKNOW"); return 1;
		case "forget": playAni(heroId, "T_FORGETIT"); return 1;
		case "great": playAni(heroId, "T_GREETCOOL"); return 1;
		case "noentry": playAni(heroId, "T_HGUARD_NOENTRY"); return 1;
		case "no": playAni(heroId, "T_NO"); return 1;
		case "plunder": playAni(heroId, "T_PLUNDER"); return 1;
		case "search": playAni(heroId, "T_SEARCH"); return 1;
		case "yes": playAni(heroId, "T_YES"); return 1;
		case "kick": playAni(heroId, "T_BORINGKICK"); return 1;
		case "sit": playAni(heroId, "T_STAND_2_SIT"); return 1;
		case "sleep": playAni(heroId, "T_STAND_2_SLEEPGROUND"); return 1;
	}
	return 0;
}
