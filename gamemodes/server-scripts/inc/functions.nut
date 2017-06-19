function get8601Date(){local date = date(); return format("%d-%d-%dT%d:%d:%dZ", date.year, date.month, date.wday, date.hour, date.min, date.sec);}

function pickUpFirstChar(string){
  if(string.len()>1){
    string = string.tolower();
    return string.slice(0, 1).toupper() + string.slice(1, string.len());  
  }else return string.toupper();
}

function convertMessageToIC(message){
  local isEmoticons, startIndex = 0, find, emoticons = [[":)", "#uœmiecha siê#"], [":(", "#smuci siê#"]];
  do{
    isEmoticons = -1;
    for(local i = 0; i<emoticons.len(); ++i){
      find = message.find(emoticons[i][0], startIndex);
      if(find!=null){
        startIndex = find;
        message = message.slice(0, startIndex) + emoticons[i][1] + message.slice(startIndex+emoticons[i][0].len(), message.len());
        isEmoticons++;
      }
    }
  }while(isEmoticons!=-1);

  if(message.len()>1) message = message.slice(0, 1).toupper() + message.slice(1, message.len());
  else message = message = message.slice(0, 1).toupper();

  return message;
}

function breakSendMessageToPlayer(pid, r, g, b, message){
  if(message.len()>90){
	sendMessageToPlayer(pid, r, g, b, message.slice(0, 90)+"-");
    if(message.len()<180) sendMessageToPlayer(pid, r, g, b, message.slice(90, message.len()));
    else sendMessageToPlayer(pid, r, g, b, message.slice(90, 180));
  }
  else sendMessageToPlayer(pid, r, g, b, message);
}

function isEven(number){
  local calc = number % 2;
  if(calc==0) return true;
  else return false;
}

function censure(string){
  if(string.len()>1){
	local half = string.len()/2;
	string = string.slice(0, string.len()-half);
	for(local i = 0; i<half; ++i){
	  string += "#";
	}
  }else return string;
}

function getDistanceBeetwenPlayers(pid, rid){
	local pos = getPlayerPosition(pid), pos2 = getPlayerPosition(rid);
	return getDistance3d(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z);
}