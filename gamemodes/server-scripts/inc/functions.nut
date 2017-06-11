function get8601Date(){local date = date(); return format("%d-%d-%dT%d:%d:%dZ", date.year, date.month, date.wday, date.hour, date.min, date.sec);}

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

function isEven(number){
  local calc = number % 2;
  if(calc==0) return true;
  else return false;
}
