final int GAME_STOP = 0, GAME_RUN = 1;
int gameState;
int balloonX = 35, balloonY, balloonW = 60, balloonH = 86;
int fireW = 15, fireH = 20; 
int cameraOffsetX = 0;
boolean debugMode = false;
PImage bg, balloon, fire, sHill, mHill, lHill;

final int _ = 0;
final int S = 1;
final int M = 2;
final int L = 3;
int[] hills = new int[8];
int pointer;
int headX;
int hillCounter;

void setup() {
  size(800,300);
  noCursor();  //隱藏鼠標
  
  bg = loadImage("img/bg.png"); 
  balloon = loadImage("img/balloon.png"); 
  fire = loadImage("img/fire.png"); 
  sHill = loadImage("img/sHill.png"); 
  mHill = loadImage("img/mHill.png"); 
  lHill = loadImage("img/lHill.png");
  
  fill(10);
  textAlign(CENTER);
  textFont(createFont("OpenSansRegular.ttf", 10));
  
  gameState = GAME_RUN;
  balloonY = 0;
  
  // 將四種山坡隨機填入陣列
  for(int i = 0; i < hills.length; i++) {
    hills[i] = floor(random(4));
  }
  pointer = 0;
  headX = 0;
  hillCounter = 0;
}

void draw() {
  
  /* ------ Debug Function ------ 
    Please DO NOT edit the code here.
    It's for reviewing other requirements when you fail to complete the camera moving requirement.
  */
  if (debugMode) {
    pushMatrix();
    translate(cameraOffsetX, 0);
  }
  /* ------ End of Debug Function ------ */
    
    
  switch(gameState) {
    case GAME_RUN:
    
    // 背景
    image(bg, -cameraOffsetX, 0, width, height);
    
    // 熱氣球
    if(balloonY < 0) { 
      balloonY = 0;
    } else if(balloonY + balloonH > height) {
      balloonY = height - balloonH;
    }   
    image(balloon, balloonX, balloonY, balloonW, balloonH);   
    balloonY++; 
    
    // 山坡
    for(int i = 0; i < 5; i++) {
      
      PImage showHill = null;
      int hillW = 0, hillH = 0;
      
      //配置山坡圖片、寬、高
      switch(hills[(pointer + i) % 8]) {  
        case _:  showHill =  null;  break;
        case S:  showHill =  sHill;  hillW = 100;  hillH = 50;  break;
        case M:  showHill =  mHill;  hillW = 150;  hillH = 75;  break;  
        case L:  showHill =  lHill;  hillW = 200;  hillH = 100;  break;
      }
      
      if(showHill != null) {
        //配置山坡位置
        int hillX = 200 * (i+1) - hillW - headX;
        image(showHill, hillX, height - hillH, hillW, hillH);
        
        // 碰撞偵測
        if(dist(balloonX + (balloonW/2), balloonY + balloonH, hillX + (hillW/2), height) < hillH) {
          gameState = GAME_STOP;
        }
      }
    }
    
    // 每 frame 由右至左移動 2px，且 200px一循環
    headX = (headX + 2) % 200;
    
    if(headX == 0) {
      // 當山坡消失於畫面時，pointer 移到下一格，且無限循環
      pointer = (pointer + 1) % 8; 
    
      // 計算越過山坡數
      if(hills[pointer] != _) {
        hillCounter++;
      } 
    }
    
    // 顯示越過山坡數
    text(hillCounter + " hills", balloonX + (balloonW / 2), balloonY - 10);
  
    // 滑鼠圖示
    imageMode(CENTER);
    image(fire, mouseX, mouseY, fireW, fireH);
    imageMode(CORNER);
    
    break;
    
    case GAME_STOP:
      // 點擊滑鼠重啟遊戲
      if(mousePressed) {
        gameState = GAME_RUN;
        balloonY = 0;      
        for(int i = 0; i < hills.length; i++) {
          hills[i] = hills[floor(random(4))];
        }
        pointer = 0;
        headX = 0;
        hillCounter = 0;
      }
    break;
    }
    
    // DO NOT REMOVE OR EDIT THE FOLLOWING 3 LINES
    if (debugMode) {
        popMatrix();
    }
}

void mouseClicked() {
  // 點擊滑鼠熱氣球上升 50px
  balloonY -= 50; 
}

void keyPressed() {
  // DO NOT REMOVE OR EDIT THE FOLLOWING SWITCH/CASES
  switch(key) {
    case 'a':  
    if(cameraOffsetX < 0) {
      debugMode = true;
      cameraOffsetX += 25;
    }
    break;

    case 'd':
    if(cameraOffsetX > -width) {
      debugMode = true;
      cameraOffsetX -= 25;
    }
    break;
  }
}