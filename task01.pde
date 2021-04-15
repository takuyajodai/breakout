
class Ball {
  float x, y; //ボールのx,y座標を保持するメンバ変数
  int dirX, dirY; //方向を決める変数
  float v; //速度を決める変数
  

  //コンストラクタ（オブジェクトを生成した時に自動的に呼ばれる初期化用のメソッド）
  Ball(){
    x = random(600);
    y = 500;
    if(int(random(2))%2 == 0) {
      dirX = -1;
    } else {
      dirX = 1;
    }
    
    
    dirY = -1;
    v = 2;
    
  }

  //オブジェクトを描画するメソッド（オブジェクトの内部の関数）
  void show(){
      
      //右側の壁の当たり判定
      if(x + 10 > 600) {
         dirX = -1;
         x = 600 - 10;//場所のリセット
      }
      //左側の壁の当たり判定
      if(x - 10 < 0) {
         dirX = 1;
         x = 10;//場所のリセット
      }
  
      //下の壁当たり判定
      if(y + 10 > 600) {
         dirY = -1;
         y = 600 - 10;//場所のリセット
      }
  
      //上の壁当たり判定
      if(y - 10 < 0) {
         dirY = 1;
         y = 10;//場所のリセット
      }
  
      //barとの当たり判定
      if(y + 10 > my_bar.barY && x > my_bar.barX && x < my_bar.barX+100) {
        dirY = -1;
      }
  
      noStroke();
      fill(201,26,47);
      x += v*dirX;
      y += v*dirY;
      ellipse(x, y, 10, 10);
      rect(my_bar.barX, my_bar.barY, 100, 30);
  }
  
}//class Ball

class Block {
  float blockX, blockY; //ブロックの座標
  boolean[] blocks = new boolean[18]; //trueで表示, falseで非表示
  
  Block() {
    blockX = 0;
    blockY = 0;
  }
  
  void showBlock() {
    for(int i = 0; i<18; i++) {
        blockX = i%6 * 100;
        blockY = i/6 * 30;
        //生きていればブロック描画
        if(blocks[i] == true) {
          stroke(32,24,78);
          fill(34,13,87);
          rect(blockX, blockY, 100, 30);
        }
        //接触条件
        for(int j=0; j<cnt; j++) {
          if(my_ball[j].y - 10 < blockY + 30 && my_ball[j].y + 10 > blockY && my_ball[j].x - 10 < blockX + 100 && my_ball[j].x + 10 > blockX && blocks[i] == true) {
            my_ball[j].dirY = 1;
            blocks[i] = false; 
            score += 10;
          }
          if(my_ball[j].y > 585) {
            textSize(50);
            text("Game Over", 170, 200);
            noLoop();
          }
        }
        
     }
  }
  
  void createBlocks() {
    //ブロックを作成
    stroke(32,24,78);
    fill(34,13,87);
    for(int i=0; i<18; i++) {
      blockX = i%6 * 100;
      blockY = i/6 * 30;
      rect(blockX, blockY, 100, 30);
      blocks[i] = true;
    }
  }
  
  void checkClear() {
    for(int i=0; i<18; i++) {
      if(blocks[i] == true) {
        return;
      }
      textSize(50);
      text("Clear", 230, 200);
      noLoop();
      
    }
  }
  
  //関数呼び出しにするとおそらく処理速度が間に合わずにdirY = 1 が効いてない
  /*boolean checkBallHit(int i) {
    for(int j=0; j<numBall; j++) {
      if(my_ball[j].y - 10 < blockY + 30 && my_ball[j].y + 10 > blockY && my_ball[j].x - 10 < blockX + 100 && my_ball[j].x + 10 > blockX && blocks[i] == true) {
      return true;
      }
    }
    return false;
  }
  */
  
  
}//class Block

class Bar {
  float barX, barY; //バーの座標
  
  Bar() {
    barX = width/2;
    barY = 500;
  }
  
  void moveRight() {
    barX += 7;
  }
  
  void moveLeft() {
    barX -= 7;
  }
}//class Bar

//ボールを格納する配列
Ball[] my_ball;
Bar my_bar;
Block my_block;

int numBall = 100;
int prevMs = 0;
int cnt = 0;
int score = 0;

//起動時実行
void setup() {
  size(600,600);
  colorMode(HSB, 360, 100, 100);
  background(255);
  ellipseMode(RADIUS);
  my_ball = new Ball[numBall];
  my_ball[cnt] = new Ball();
  cnt++;
  my_bar = new Bar();
  my_block = new Block();
  my_block.createBlocks();
}


//繰り返し実行
void draw() {
  //一定時間ごとに実行
  if(millis() > prevMs + 10000) {
    my_ball[cnt] = new Ball();
    cnt++;
    prevMs = millis();
  }
  //background(43,6,94);
  fill(43,6,94);
  rect(0, 0, width, height);
  my_block.showBlock();
  for(int i=0; i<cnt; i++) {
    my_ball[i].show();
  }
  my_block.checkClear();
  scoreShow();
}

void keyPressed() {
  if (key == CODED) {//キーが特殊キーかの判定
     if(keyCode == RIGHT) {//右矢印なら
       my_bar.moveRight(); //my_ballオブジェクトのmoveRight()メソッドを実行
     } else if (keyCode == LEFT) {//左矢印なら
       my_bar.moveLeft(); //my_ballオブジェクトのmoveLeft()メソッドを実行
     }
  }
}

void scoreShow() {
  textSize(24);
  fill(0,0,100);
  text("score:"+score, 260, 25);
}
