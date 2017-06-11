local animations = ["legshake", "scratchegg", "lookleft", "lookright", "lookdown", "scratchshoulder", "scratchhead", "rolex", "broom",
"dead", "dead2", "wounded", "dontshoot", "horn", "pray", "pray2", "get", "guard", "guard2", "map", "pee", "wash", "watchfight", "dance",
"dance2", "dontknow", "forget", "great", "noentry", "no", "plunder", "search", "yes", "kick", "sit", "sleep"];

function animations(pid, string){
  local instance = string.slice(1, string.len()), find = animations.find(instance);
  if(find!=null) callClientFunc(pid, "animations", find);
  else sendMessageToPlayer(pid, 192, 192, 192, ">Nie znaleziono animacji.");
}
