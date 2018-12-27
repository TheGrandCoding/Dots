import java.util.*; // so lists work

Population test;
PVector goal;
public static int startPosX;
public static int startPosY;
int stage = 1; // 1 is deciding where the goal is AND the text screen; 2 or higher is the actual program.
boolean mouseIsDown = false;
public static List<int[]> obstacles = new ArrayList<int[]>();

void setup(){
  size(800, 800); //sets the window's size
}

void draw(){ //called every frame
  
  background(255); //white background
  
  stroke(0);
  strokeWeight(0);
  
  if (stage == 1){ //the initial text screen
    fill(255, 0, 0); //red colour
    textSize(40);
    text("The aim of this is to get the dots", 20, height/ 3);
    text("to learn to reach the goal", 20, height/2);
    text("Click somewhere on the window to ", 20, height/ 1.5);
    text("set a goal for the dots", 20, height/ 1.25);
    
  }else if(stage == 2) { //picking where the dots start
    fill(255, 0, 0); //red colour
    ellipse(goal.x, goal.y, 10, 10); //draw a circle where the goal is
    text("now click somewhere else for the", 20, height/4);
    text("starting position of the dots", 20, height/2);
    
  }else if(stage == 3){ //drawing the obstacles
    fill(255, 0, 0); //red colour
    ellipse(goal.x, goal.y, 10, 10); //draw a circle where the goal is
    
    text("now make some obstacles and press ", 20, 40);
    text("the ominous black button in the corner", 20, 70);
    text("(but please don't draw too much)", 20, 100);
    text("(and draw slowly)", 20, 130);
    
    fill(0);
    rect(650, 700, 100, 50); //confirm button
    ellipse(startPosX, startPosY, 4, 4); //a little dot showing where the population starts
    
    drawObstacles();
    
    stroke(0, 0, 255); //blue
    strokeWeight(10); //thick
    
    if (mouseIsDown){
      line(mouseX, mouseY, pmouseX, pmouseY);
      obstacles.add(new int[] {pmouseX, pmouseY});
      obstacles.add(new int[] {mouseX, mouseY});
    }
  
  }else { //the actual program
      drawObstacles();
  
      fill(255, 0, 0); //red colour
      strokeWeight(0); //thin
      stroke(0); //black
      ellipse(goal.x, goal.y, 10, 10); //draw a circle where the goal is
    
    if(test.allDotsDead()){
      //the genetic algorithm
      test.calculateFitness();
      test.naturalSelection();
      test.mutate();
      
    } else{
      test.update();
      test.show();    
    }
    
    textSize(32);
    fill(0);
    text("Generation: " + test.generation, 50, 50);
  }
  
}

void mouseClicked(){
  if (stage == 1){ //deciding where the goal is
    goal = new PVector(mouseX, mouseY);
    
  } else if (stage == 2){ //deciding where the dots start from
    startPosX = mouseX; //it goes crazy when trying to put them into a PVector
    startPosY = mouseY;
    test = new Population(1000); //!!!!! Try changing the population size !!!!!\\
    
  }
  stage++;
}

void mousePressed(){
  mouseIsDown = true;
}

void mouseReleased(){
  mouseIsDown = false;
}

void drawObstacles(){ //draw all of the previous points
    stroke(0, 0, 255);
    strokeWeight(10);
    for (int i = 0; i < obstacles.size(); i += 2){
      line(obstacles.get(i)[0], obstacles.get(i)[1], obstacles.get(i + 1)[0], obstacles.get(i + 1)[1]); 
    }
}
