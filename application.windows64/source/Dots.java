import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Dots extends PApplet {

Population test;
PVector goal;
public static int startPosX;
public static int startPosY;
int stage = 1; // 1 is deciding where the goal is AND the text screen; 2 or higher is the actual program.

public void setup(){
   //sets the window's size
}

public void draw(){ //called every frame; the plan is to move the 
  background(255); //white background
  if (stage == 1){ //the initial text screen
    fill(255, 0, 0); //red colour
    textSize(40);
    text("The aim of this is to get the dots", 20, height/ 3);
    text("to learn to reach the goal", 20, height/2);
    text("Click somewhere on the window to ", 20, height/ 1.5f);
    text("set a goal for the dots", 20, height/ 1.25f);
    
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

public void mouseClicked(){
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
class Brain { //decides where the dot travels
              //'decides' - generates random directions
 
  PVector[] directions;
  int step = 0; //will keep track of which index of the directions array we're on
  
  Brain(int size){
   directions = new PVector[size];
   randomize();
  }
 

  //---------------

  public void randomize(){ //putting random values into the directions array
   
    for (int i = 0; i < directions.length; i++){
     float randomAngle = random(2 * PI);
     directions[i] = PVector.fromAngle(randomAngle);
    }
    
  }
  
  //---------------------
  
  public Brain clone(){
    Brain clone = new Brain(directions.length);
    for(int i = 0; i < directions.length; i++){
      clone.directions[i] = directions[i].copy(); //copy the path the dot took
    }
    
    return clone;
  }
  
  //------------------------
  
  public void mutate(){
    float mutationRate = 0.01f; //the *chance* that a mutation will occur
    for (int i = 0; i < directions.length; i++){
      float rnd = random(1);
      
      if(rnd < mutationRate){ //then mutate!!
        float randomAngle = random(2*PI);
        directions[i] = PVector.fromAngle(randomAngle);
      }
    }
  }
  

}
class Dot{
  
  PVector pos;//position
  PVector vel;//velocity
  PVector acc;//acceleration
  boolean dead = false;
  boolean reachedGoal = false;
  boolean isBest = false;
  float fitness;
  Brain brain;
 
  Dot(){ //posx and y are the *starting* positions
   brain = new Brain(400); //initialises a brain with 400 different vectors
   pos = new PVector(Dots.startPosX, Dots.startPosY);
   vel = new PVector(0, 0); //(0 velocity, 0 acceleration)
   
   dead = false;
   reachedGoal = false;
  }
  
  //---------------------------
  
  public void show(){
    
    if (isBest){
      fill(0, 255, 0);
      ellipse(pos.x, pos.y, 6, 6);
    } else{
      fill(0); //the fill *colour* is 0 (black) i think
      ellipse(pos.x, pos.y, 4, 4); //draw an ellipse at position (x,y) and size 4x4.
    }
  }
  
  //---------------------------
  
  public void move(){
    if (brain.directions.length > brain.step){
      acc = brain.directions[brain.step]; //set acc to the next element in brain's direction array
      brain.step++;
    } else{
      dead = true; //if the dot runs out of vectors to follow
    }
    
    vel.add(acc);
    vel.limit(5); //stopping the effect of the added acc; otherwise the dot travels in the same direction forever
    pos.add(vel);
  }
  
  //---------------------------
  
  public void update(){
    if (!dead && !reachedGoal){ 
      move();
      if (pos.x < 2 || pos.y < 2 || pos.x > width - 2 || pos.y > height - 2){
         dead = true; //kill the dot if it goes outside of the window 
      } else if(dist(pos.x, pos.y, goal.x, goal.y) < 5){
        //if the dot reached the goal
        reachedGoal = true;
      }
    }
    
  }
  
  //----------------------------
  
  public void calculateFitness(){
    if (reachedGoal){ //judge fitness by how many steps it took
      fitness = 1.0f/16.0f * 10000.0f / (float)(brain.step + brain.step); 
      
    }else { //judge fitness only by how close to the goal they were
      float distanceToGoal = dist(pos.x, pos.y, goal.x, goal.y); //give the difference in distance betweem pos and goal
      fitness = 1.0f/(distanceToGoal * distanceToGoal); //like a percentage of how close the dot was to the goal;
                                                       //squared so a small improvement in distance is more heavily favoured (?)
    }
  }
  
  public Dot getChild(){ //usually you'd have 'crossover' stuff here,
                    //but the program is so simple it doesn't need it
                    //just cloning instead
     Dot child = new Dot();
     child.brain = brain.clone();
     return child;
   }
  
}
class Population{
  Dot[] dots;
  float fitnessSum;
  int generation = 1;
  int bestDotIndex = 0;
  int bestSteps = 1000; //the smallest amount of steps a dot took to get to the goal
  
  Population(int size){ //will create 'size' amount of dots and save them in the dots array
    dots = new Dot[size];
    for (int i = 0; i < size; i++){
      dots[i] = new Dot(); 
    }
  }
  
  //-----------------
  //the following just calls the functions on the entire population
  
  public void show(){
   for (int i = 0; i < dots.length; i++){
     dots[i].show();
   }
   dots[0].show(); //the best dot
  }
   
   public void update(){
     for (int i = 0; i < dots.length; i++){
       if(dots[i].brain.step > bestSteps){
         dots[i].dead = true; //kill the dot if it's taken too many steps
       } else {
         dots[i].update();
       }
     }
   
   }
   
   public void calculateFitness(){
     for (int i = 0; i < dots.length; i++){
       dots[i].calculateFitness();
     }
     
   }
   
   //-------------------
   
   public boolean allDotsDead(){
     for (int i = 0; i < dots.length; i++){
       if (!dots[i].dead && !dots[i].reachedGoal) {
         return false;
       }
       
     }
     return true;
     
   }
   
   //------------------------
   
   public void naturalSelection(){ //the 'AI' bit
     
     Dot[] newDots = new Dot[dots.length];
     
     setBestDot();
     newDots[0] = dots[bestDotIndex].getChild();
     newDots[0].isBest = true;
     
     calculateFitnessSum();
     
     for (int i = 1; i < newDots.length; i++){
       //select parent based on fitness
       Dot parent = selectParent();
       
       //get its child
       newDots[i] = parent.getChild();
     }
     
     dots = newDots.clone(); //replace the current generation with the new generation
     generation++;
     println("generation " + generation);
   }
   
   //-----------------------------
   
   public void setBestDot(){ //the 'champion' of the generation goes through to the 
                      //next generation without mutations
                      
    float max = 0;
    for (int i = 0; i < dots.length; i++){
     if (dots[i].fitness > max){
      max = dots[i].fitness;
      bestDotIndex = i;
     }
     
    }
     
     if (dots[bestDotIndex].reachedGoal){
       bestSteps = dots[bestDotIndex].brain.step;
     }
     
  }
   
   //------------------------------
   
   public void calculateFitnessSum(){
     fitnessSum = 0;
     for(int i = 0; i < dots.length; i++){
       fitnessSum += dots[i].fitness;
     }
   }
   
   //-----------------------------------
   
   public Dot selectParent(){
     //see selectingParents.jpg in this folder
     float rnd = random(fitnessSum);
     
     float runningSum = 0; //used to return the selected dot
     
     for (int i = 0; i < dots.length; i++){
       runningSum += dots[i].fitness;
       
       if(runningSum > rnd){
         return dots[i];
       }
       
     }
     
     //shouldn't get to this point
     return null;
   }
   
   //----------------------------
   
   public void mutate(){
    for (int i = 1; i < dots.length; i++){
      dots[i].brain.mutate();
    }
    
   }
   
}  
  public void settings() {  size(800, 800); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Dots" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
