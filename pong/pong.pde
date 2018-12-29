boolean mode = false; //PvP mode or P Vs computer
int choice = 0; //to draw the correct mode
player P1; 
Comp C; 
ball b; 
player2 P2; 
float level= 1.5; //used to increase speed of the ball and tracking distance of the computer
int points1 = 0;  //the points of the left side paddle for both modes
int points2 = 0;  //the points of the right side paddle for both modes
boolean end = false; //if the game has ended
boolean start = true; //used to stop the mousePressed method
void setup() {
  background (30, 235, 70);
  size(800, 500); 
  fill(230, 180, 175);
  rect(300, 100, 230, 60); //enclosing the words
  rect(300, 300, 200, 60);
  textSize(40);
  fill(0);
  text("P1 vs Comp", 300, 150); 
  text("P1 vs P2", 300, 350);
  P1 = new player();
  b = new ball();
  C = new Comp(); 
  P2 = new player2();
}
void draw() {
  if (end == false) { //if the game hasn't ended
    if (choice == 1) { //if player vs computer mode is selected
      background (0);
      textSize(20);
      fill(255); 
      //texts at the top of the screen
      text("Comp points:", 20, 50); 
      text("player points:", width-183, 50);
      text(points1, 150, 50);
      text(points2, 750, 50);
      //calling all methods
      b.display();
      b.move();
      b.collision(); 
      b.bounce();
      b.levelup();
      b.score();
      P1.display();
      P1.move(); 
      P1.keyPressed();
      P1.out();
      C.display();
      C.move();
      endgame(); //checking to see if a player has won
    } else if (choice == 2) { // if PvP mode is selected
      background(0, 0, 255);
      //text on the top of the screen
      textSize(20);
      fill(255); 
      text("player2 points:", 15, 50); 
      text("player1 points:", width-187, 50);
      text(points1, 170, 50);
      text(points2, width-30, 50);
      //calling all functions
      b.display();
      b.move();
      b.collision(); 
      b.bounce();
      b.levelup();
      b.score();
      P1.display();
      P1.move(); 
      P1.keyPressed();
      P1.out();
      P2.display();
      P2.move();
      P2.keyPressed();
      P2.out();
            endgame(); //checking to see a player has won 
    }
  } else { // if the game has ended
    background(50, 235, 10);
    //using text to announce the correct winner by checking points
    if (choice == 1 && points1 > points2) {
      textSize(40);
      fill(0, 0, 255);
      text("Computer Wins", width/2 - 150, height/2);
      textSize(20);
      text("press esc to exit", width/2-100, height-100);
      keyPressed();
    } else if (choice == 1 && points1 < points2) {
      textSize(40);
      fill(0, 0, 255);
      text("player wins", width/2 - 140, height/2);
      text("press esc to exit", width/2-100, height-100);
      keyPressed();
    } else if (choice == 2 && points1 < points2) {
      textSize(40);
      fill(230, 50, 80);
      text("player1 wins", width/2 - 140, height/2);
      text("press esc to exit", width/2-100, height-100);
      keyPressed();
    } else if (choice == 2 && points1 > points2) {
      textSize(40);
      fill(230, 50, 80);
      text("player2 wins", width/2 - 140, height/2);
      text("press esc to exit", width/2-100, height-100);
      keyPressed();
    }
  }
}
//for the user to choose the mode
void mousePressed() {
  if (start) {
    if (mouseY > 100 && mouseY < 160) {
      choice = 1 ;
      start = false;
    } else{
      choice = 2;
      start = false;
    }
  }
}
//a super class for my paddles
class paddle {
  public float x; 
  public float y; 
  public float speed; 
  public boolean out = false; //checking if the paddle is at the top or bottom of the screen
  //just a rectangle 
  public void display() {
    fill(255, 0, 0); 
    rectMode(CENTER);
    rect(x, y, 20, 90);
  }
  //only moving up and down
  public void move() {
    this.y += this.speed;
  }
  
  public void keyPressed() {
    if (key == CODED) {
      if (this.out == false) {
        if (keyCode == DOWN) {
          this.speed = 1+points1; // the paddle speed corresponds with the opponent's points
          keyCode = LEFT;
        }

        if (keyCode == UP) {
          this.speed = -1 - points1;
          keyCode = LEFT;
        }
      }
    }
  }
  //if the paddle is at the top or bottom of the screen it bounces back slowly
  public void out() {
    if (this.y > 450) {
      this.speed = -1- points1;
    } else if (this.y < 40) {
      this.speed = 1+ points1;
    }
  }
}
//the right side paddle a.k.a player1 in both modes
class player extends paddle { 
  public player() {
    this.x = width-80; 
    this.y=height/2 - 50;
  }
}
//the computer paddle for the computer vs player mode
class Comp extends paddle {
  public Comp() {
    this.x = 80;
    this.y = height/2-50;
  }
  //overiding the move method 
  public void move() {
    //tracking the ball if the ball is beyond a certain x coordinate
    float by = b.getY();
    float bx = b.getX(); 
    if (bx < width/2 + 30*level) { // using level to control when the computer will start tracking the ball
      if (by > this.y) {
        this.y += 1+points2 ;
      } else if (by < this.y) {
        this.y -= 1+points2 ;
      }
    } else { //if the ball is beyond the x coordinate for tracking, return to the middle
      if (this.y < height/2) {
        this.y += 1;
      } else if (this.y > height/2) {
        this.y -= 1;
      }
    }
  }
  //just a rectangle
  public void display() {
    fill(225); 
    rectMode(CENTER);
    rect(x, y, 20, 90);
  }
}
class ball {
  private float x; 
  private float y; 
  private float xspeed;
  private float yspeed; 
  private int bounces = 0 ; 
  private boolean check = true; //used to make collision smoother
  public ball() {
    this.x = (width/2);
    this.y = (height/2);
    this.xspeed = 1;
    this.yspeed = -1;
  }
  //a circle
  public void display() {
    ellipseMode(CENTER); 
    fill(255, 235, 10);
    ellipse(this.x, this.y, 25, 25);
  }
  //the speed increase as level goes up
  public void move() {
    this.x += xspeed*level;
    this.y += yspeed*level;
  }
  //moving the ball back to the middle after a goal and giving it a random direction
  public void reset() {
    check = true; 
    this.x = (width/2);
    this.y = (height/2);
    P1.y = height/2; 
    if (choice == 1) {

      C.y = height/2;
    } else if (choice == 2) {
      P2.y = height/2;
    }
    this.xspeed = (random(-2, 2)); 
    this.yspeed = (random(-2, 2)); 
    if (this.xspeed == 0) {
      while (this.xspeed == 0) {
        this.xspeed = (random(-2, 2));
      }
    }
    if (this.xspeed < 0) {
      this.xspeed = -1;
    } else if (this.xspeed > 0) {
      this.xspeed = 1;
    }

    if (this.yspeed == 0) {
      while (this.yspeed == 0) {
        this.yspeed = int(random(-2, 2));
      }
    }
    if (this.yspeed < 0) {
      this.yspeed = -1;
    } else if (this.yspeed > 0) {
      this.yspeed = 1;
    }
  }
  //if the ball collides with any paddle
  public void collision() {
    if (check == true) { //if the ball hasn't passed the x coordinate of a paddle
      if (this.x >= width - 100) { // the ball has passed the paddle so it should bounce if y coordinates are right
        check = false;  //passed the paddle so stop the method to prevent multiple bounces
        if (this.y - P1.y <= 50 && this.y - P1.y >= -50) { //checking if the ball is in the right y coordinate zone
          this.xspeed = -this.xspeed; //bouncing back 
          bounces += 1; //counting the bounces
        }
      }
      if (choice == 1) { //if P vs computer mode check with computer paddle
        if (this.x < 100) {
          check = false; 
          if (C.y - this.y <= 45 && C.y - this.y >= -45) {
            this.xspeed = -this.xspeed; 
            bounces += 1;
          }
        }
      } else { // if PVP mode check with P2 paddle
        if (this.x < 100) {
          check = false; 
          if (P2.y - this.y <= 50 && P2.y - this.y >= -50) {
            this.xspeed = -this.xspeed; 
            bounces += 1;
          }
        }
      }
    }
  }
  //to bounce the ball when the ball hits the bottom or top and to reset boolean check 
  public void bounce() {
    if (this.y <= 20) {
      this.yspeed = -1*this.yspeed;
      check = true; 
    } else if (this.y >= height - 20) {
      this.yspeed = -1*this.yspeed;
      check = true; 
    }
  }
  public float getY() {
    return this.y;
  }
  public float getX() {
    return this.x;
  }
  //to increase the level when 3 bounces have been made
  public void levelup() {
    if (bounces >= 3) {
      level += 0.5; 
      bounces = 0;
    }
  }
  //updating the scoring system and resetting the ball
  public void score() {
    if (this.x > width - 50) {
      reset();
      points1++;
      delay(2000);
    } else if (this.x < 50) {
      reset();
      points2++;
      delay(2000);
    }
  }
}
//checking if someone has won
void endgame() {
  if (points1 > 6) {
    end = true;
  } else if (points2 > 6) {
    end = true;
  }
}
//the left side paddle in the PVP mode
class player2 extends paddle {
  public player2() {
    this.x = 80;
    this.y = height/2-50;
  }
  //controlled with WASD
  public void keyPressed() {
    if (this.out == false) {
      if (key == 's') {
        this.speed = 1+points2 ;
        key = LEFT;
      }

      if (key == 'w') {
        this.speed = -1-points2;
        key = LEFT;
      }
    }
  }
  public void display() {
    fill(0, 255, 0); 
    rectMode(CENTER);
    rect(x, y, 20, 90);
  }
}
//quitting the game 
void keyPressed() {
  if (key == ESC) {
    exit();
  }
}
