int getColor(int state) {
  if (state == 0) return #4c9897;
  else if (state == 1) return #a48f50;
  else if (state == 2) return #7c110e;
  else return 0;
}

void renderHistory(int[][] history, int historyIndex, int renderedHistory, int cellSize) {
  for (int i = 0; i < renderedHistory; i++) {
    int circularIndex = (historyIndex - i) % history.length;
    circularIndex = circularIndex < 0 ? history.length + circularIndex : circularIndex;
    renderLine(renderedHistory - i, history[circularIndex], cellSize);
  }
}

void renderLine(int line, int[] hab, int cellSize) {
  for (int j = 0; j < hab.length; j++) {
    fill(getColor(hab[j]));
    rect(j * cellSize, line * cellSize, cellSize, cellSize);
  }
}

void renderRuleMenu(int[][][] ruleFrequency) {
  fill(backCol);
    rect(menuX, menuY, 13*pauseCellSize, 28*pauseCellSize, 15);
          
    int xOff = menuX + pauseCellSize;
    int yOff = menuY + pauseCellSize;
    
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        for (int k = 0; k < 3; k++) {
          
          // render background squares
          int intensity = 43 + ruleFrequency[i][j][k] * 3;
          fill(intensity, intensity, intensity);
          rect(xOff - pauseCellSize / 2, yOff - pauseCellSize / 2, pauseCellSize * 4, pauseCellSize * 3, 4);
          fill(backCol);
          rect(xOff - pauseCellSize / 6, yOff - pauseCellSize / 6, 20 * pauseCellSize / 6, 14 * pauseCellSize / 6, 4);
          
          // render mouse highlight
          if (mouseX > xOff - pauseCellSize / 2 && mouseX < xOff + 7 * pauseCellSize / 2 &&
              mouseY > yOff - pauseCellSize / 2 && mouseY < yOff + 5 * pauseCellSize / 2) stroke(#FFFFFF);
              
          // render neihborhood triple
          fill(getColor(i));
          rect(xOff, yOff, pauseCellSize, pauseCellSize, 4);
          
          fill(getColor(j));
          rect(xOff + pauseCellSize, yOff, pauseCellSize, pauseCellSize, 4);
          
          fill(getColor(k));
          rect(xOff + 2 * pauseCellSize, yOff, pauseCellSize, pauseCellSize, 4);
          
          // render rule
          fill(getColor(nextMap[i][j][k]));
          rect(xOff + pauseCellSize, yOff + pauseCellSize, pauseCellSize, pauseCellSize, 4);
          
          noStroke();
          
          xOff += 4 * pauseCellSize;
        }
        yOff += 3 * pauseCellSize;
        xOff = menuX + pauseCellSize;
      }
    }
    
    // render drag handle
    fill(#C8C8C8);
    ellipse(menuX + pauseCellSize / 3, menuY + pauseCellSize / 3, 2 * pauseCellSize / 3, 2 * pauseCellSize / 3);
    fill(backCol);
    ellipse(menuX + pauseCellSize / 3, menuY + pauseCellSize / 3, pauseCellSize / 6, pauseCellSize / 2);
    ellipse(menuX + pauseCellSize / 3, menuY + pauseCellSize / 3, pauseCellSize / 2, pauseCellSize / 6);
}
