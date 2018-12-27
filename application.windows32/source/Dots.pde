Population test;
PVector goal;
public static int startPosX;
public static int startPosY;
int stage = 1; // 1 is deciding where the goal is AND the text screen; 2 or higher is the actual program.

void setup(){
  size(800, 800); //sets the window's size
}

void draw(){ //called every frame; the plan is to move the 
  background(255); //white background
  if (stage == 1){ //the initial text screen
    fill(255, 0, 0); //red colour
    textSize(40);
    text("The aim of this is to get the dots", 20, height/ 3);
    text("to learn to reach the goal", 20, height/2);
    text("Click somewhere on the window to ", 20, height/ 1.5);
    text("set a goal for the dots", 20, height/ 1.25);
    
  }else if(stage == 2) {
    text("now click somewhere else for the", 20, height/4);
    text("starting position of the dots", 20, height/2);
    
  }else { //the actual program
      fill(255, 0, 0); //red colour
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
  } 
  if (stage == 2){ //deciding where the dots start from
    startPosX = mouseX; //it goes crazy when trying to put them into a PVector
    startPosY = mouseY;
    test = new Population(1000); //!!!!! Try changing the population size !!!!!\\
  }
  stage++;
}
