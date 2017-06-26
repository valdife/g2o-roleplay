function bankRefresh(nr, ...){
	itemSave();
  local position = dialog.position, drawPosition = dialog.drawPosition, maxI, textLen = dialog.text.len();
  if(position>=dialog.maxPosition-1) maxI = position + (dialog.maxPosition - drawPosition);
  else maxI = position;

  if(nr==0) dialog.show(9);
  else if(nr==1) dialog.show(10, vargv[0]);

  if(maxI>dialog.text.len()){
    maxI = dialog.text.len();
    if(position>0) position--;
  }

	if(position!=dialog.position){
		for(local i = 0; i<maxI-1 && i<dialog.text.len(); ++i){
			dialog.switcher(true);
    }
    if(dialog.drawPosition!=drawPosition){
      dialog.draw[dialog.drawPosition].setColor(255, 255, 255);
      dialog.position = position;
      dialog.drawPosition = drawPosition;
      dialog.draw[drawPosition].setColor(255, 255, 255);
      dialog.draw[dialog.drawPosition].setColor(255, 255, 0);
    }
	}
}

	