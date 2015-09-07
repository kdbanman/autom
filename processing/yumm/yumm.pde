color backCol = #1c1c1c;

int habSize = 100;
int cellSize = 5;
int renderedHistory = 160;

int pauseCellSize = 19;

int framerate = 30;

// cells are 0, 1, or 2
// history is a circular buffer of habitats
int[][] history;
int historyIndex;

int[][][] ruleFrequency;

int cellViewWidth;

boolean paused;
int menuX;
int menuY;
boolean menuDragging;

// 27 possible nbrhood states
//  --> 7625597484987 possible rulesets
//  --> range is 0L to 7625597484986L
// this number might actually correspond reversed rule map...
// (this shit only works on 64 bit machines because it takes
// 43 bits to describe all 3 state outer totallistic 1D
// automata)
// long initialRule = 214582522525L; "120202021212121212111200000";
String stringInitialRule = "221221121220202201101122120";
int[][][] nextMap;

void setup() {
  cellViewWidth = habSize * cellSize;
  int spectrumViewWidth = (habSize - 2) * cellSize;
  
  int screenWidth = cellViewWidth + spectrumViewWidth;
  int screenHeight = cellSize * renderedHistory;
  
  size(screenWidth, screenHeight);
  
  paused = false;
  int menuWidth = pauseCellSize * 13;
  menuX = screenWidth - menuWidth;
  menuY = 0;
  menuDragging = false;
  
  history = new int[renderedHistory][habSize];
  historyIndex = 0;
  randomizedSeed(history, historyIndex);
  
  ruleFrequency = new int[3][3][3];
  
  nextMap = new int[3][3][3];
  makeMapBase3(nextMap, stringInitialRule);
  
  noStroke();
  background(backCol);
  frameRate(framerate);
}

void draw() {
  background(backCol);

  // iterate and analyze
  if (!paused) {
    updateRuleFrequency(ruleFrequency, history, historyIndex);
    calculateNext(history, historyIndex, nextMap);
    historyIndex = (historyIndex + 1) % history.length;
  }
  //render
  renderHistory(history, historyIndex, renderedHistory, cellSize);
  
  // load pixels before menu has been rendered to look underneath it
  loadPixels();
  renderRuleMenu(ruleFrequency);
}

void mouseClicked() {
  int menuButtonsClickX = mouseX - menuX + pauseCellSize / 2;
  int menuButtonsClickY = mouseY - menuY + pauseCellSize / 2;
  
  if (menuButtonsClickX > pauseCellSize && menuButtonsClickX < 13*pauseCellSize &&
      menuButtonsClickY > pauseCellSize && menuButtonsClickY < 28*pauseCellSize) {
    int k = int((menuButtonsClickX - pauseCellSize) / (pauseCellSize * 4));
    int j = int((menuButtonsClickY - pauseCellSize) / (pauseCellSize * 3)) % 3;
    int i = ((menuButtonsClickY - pauseCellSize) / (pauseCellSize * 9)) % 3;
    
    nextMap[i][j][k] = (nextMap[i][j][k] + 1) % 3;
    
    println(mapString(nextMap));
  }
}

void mousePressed() {
  int menuClickX = mouseX - menuX;
  int menuClickY = mouseY - menuY;
  
  // determine if the mouse was pressed within the menu drag handle
  int dragBoxRadius = pauseCellSize;
  if (menuClickX > -dragBoxRadius && menuClickX < dragBoxRadius &&
      menuClickY > -dragBoxRadius && menuClickY < dragBoxRadius) {
        menuDragging = true;
  }
}

void mouseReleased() {
  menuDragging = false;
}

void mouseDragged() {
  if (menuDragging) {
    menuX += mouseX - pmouseX;
    menuY += mouseY - pmouseY;
  }
}

void keyPressed() {
  if (key == ' ') {
    paused = !paused;
    
  } else if (!paused && (key == 'M' || key == 'm')) {
    singletSeed(history, historyIndex);
  } else if (!paused && (key == 'R' || key == 'r')) {
    randomizedSeed(history, historyIndex);
  }
}

