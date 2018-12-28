PImage img;         //read image file
//PGraphics[][] blockPic;
PGraphics[][] ImageBlockPic;
final int COL=9;
final int ROW=5;
int ww, hh;
color back_color = color(0,0,0,0);

// ブロックのパラメータ

int[] blockX = new int[ROW * COL];  // ブロックのx座標格納用の配列
int[] blockY = new int[ROW * COL];  // ブロックのy座標格納用の配列
color[] blockColor = new int[ROW * COL];
int first_block_x = 0;    // 最初のブロックのx座標
int first_block_y = 0;    // 最初のブロックのy座標
int block_width = 600/9;      // ブロックの幅
int block_height = 120/5;     // ブロックの高さ
int block_interval_x = (600/9)+1; // ブロックの間隔(x方向)
int block_interval_y = (120/5)+1; // ブロックの間隔(y方向)
color block_color = color(0,50,100); // ブロックの色
color none_block  = color(0,255,255,0);
DrawBlock[] block = new DrawBlock[ROW * COL]; // ブロック描画用オブジェクトの宣言

// バーのパラメータ
int bar_width = 60; // バーの幅
int bar_height = 15;// バーの高さ
int bar_x = 200;    // バーのx座標
int bar_y = 470;    // バーのy座標
color bar_color = color(150, 0, 100); // バーの色

// ボールのパラメータ
float ball_dia = 12;                 // ボールの直径
float ball_x = bar_x + bar_width/2;  // ボールのx座標
float ball_y = bar_y - ball_dia/2;   // ボールのy座標
float vx = random(random(-3, -3),random(3, 3)); // ボールの速さ(x方向)
float vy = -5.5;                                // ボールの速さ(y方向)


boolean start_click = false;
int score;


class DrawBlock{
  int x, y, w, h;
  color rgb;  
  
  DrawBlock(int block_x, int block_y, int block_width, int block_height, color rgb_color){
    x = block_x;
    y = block_y;
    w = block_width;
    h = block_height;
    rgb = rgb_color;
  }
  
  void init(){
    noStroke();
    fill(rgb);
    rect(x, y, w, h);
  }
}

void setup() {
  size(600, 600);
  img=loadImage("Mobingi_logo_horizontal.png");
  img.resize(600, 120);
  ww=img.width/COL;//ブロックの幅, 600/11
  hh=img.height/ROW;//ブロックの高さ, 120/10
  
  ImageBlockPic = new PGraphics[ROW][COL];

//ロゴ配置
 for (int y=0; y<ROW; y++) {
  for (int x=0; x<COL; x++) {
     // int i = x + (y * COL);
      ImageBlockPic[y][x]=createGraphics((int)ww, (int)hh);//描画オブジェクト生成
      ImageBlockPic[y][x].beginDraw();
      ImageBlockPic[y][x].background(255);
      ImageBlockPic[y][x].noFill();
      ImageBlockPic[y][x].noStroke();
      ImageBlockPic[y][x].image(img, -x*ww, (-y)*hh);//画を貼り付ける
      ImageBlockPic[y][x].rect(0, 0, ww-1, hh-1);//ブロックの枠を描く
      ImageBlockPic[y][x].endDraw();
    }
  }

 // ブロックの初期化
 for(int y=0; y<ROW; y++){
   for(int x=0; x<COL; x++){
      int i = x + (y * COL);
      blockColor[i] = block_color;
      blockX[i] = first_block_x + block_interval_x * x;
      blockY[i] = first_block_y + block_interval_y * y;
      block[i] = new DrawBlock(blockX[i], blockY[i], ww, hh, blockColor[i]);
    }
  }

}//end of set up




void draw(){
  background(0);
  //logo block
  for (int y=0; y<ROW; y++) {
    for (int x=0; x<COL; x++) {
         image(ImageBlockPic[y][x].get(), x*ww, y*hh+5);//ブロック描写位置
    }
  }
  
  //block
  for (int i=0; i<block.length; i++) {
    block[i].init();
  }

 // バーの描画
  fill(200,155,155);  
  rect(bar_x, bar_y, bar_width, bar_height);
  bar_x = mouseX - bar_width/2;
  
  // バーが画面外にある場合の処理
  if(bar_x > width - bar_width){
    bar_x = width - bar_width;
  }
  if(bar_x < 0){
    bar_x = 0;
  }
  
   // ボールの描画
  fill(200, 0, 0);
  ellipse(ball_x, ball_y, ball_dia, ball_dia);
  // ボールの移動(速度分)
  if(start_click){
    ball_x += vx;
    ball_y += vy;
  }
  // ボールの処理(壁と衝突後)
  if( ball_x > width || ball_x < 0){
    vx *= -1;
  }
  if( ball_y < 0){
    vy *= -1;
  }
  // ボールがバーより下ならゲームオーバー
  if( ball_y > height){
    text("Game Over", width/2 , height/2);
    text("Your Score:"+score, width/2 , height/2 + 30);
  }
  
    // バーにボールが衝突した場合の処理
  if(ball_x > bar_x-5 && ball_x < bar_x + bar_width + 5){
    if(ball_y > bar_y && ball_y < bar_y + 6){
      vx += random(0.5,0.5);
      vy *= -1.01;
    }
  }
  
   // ボールと衝突したブロックの描画
  for(int y = 0; y < ROW; y++){
    for(int x = 0; x < COL; x++){
      int i = x + (y * COL);
      if(blockColor[i] == block_color){
        if(ball_y > blockY[i] && ball_y < blockY[i]+ hh){
          if(ball_x > blockX[i]-5 && ball_x < blockX[i] + ww){
            vy *= -1;
            blockColor[i] = none_block;
            score += 10;  // スコア+10加点

          }
        }
        
        if(ball_y > blockY[i] && ball_y < blockY[i] + hh){
          if(ball_x > blockX[i]-5 && ball_x < blockX[i]-6 ){
            vx *= -1;
            blockColor[i] = none_block;
            score += 10;
          }
          
          if(ball_x > blockX[i]+5 + ww && ball_x < blockX[i] + ww + 6){
            vx *= -1;
            blockColor[i] = none_block;
            score += 10;
          } 
        }
      }
      
     block[i] = new DrawBlock(blockX[i], blockY[i], ww, hh, blockColor[i]);   
    }
  }
  
  text("Score: " + score, 500, 500);
  if(score == 450){
     text("Finish!!!", width/2 , height/2);
  }
 
}


void mousePressed(){
  start_click = !start_click;
}
