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
  
  void show(){
    
    if (isBest){
      fill(0, 255, 0);
      ellipse(pos.x, pos.y, 6, 6);
    } else{
      fill(0); //the fill *colour* is 0 (black) i think
      ellipse(pos.x, pos.y, 4, 4); //draw an ellipse at position (x,y) and size 4x4.
    }
  }
  
  //---------------------------
  
  void move(){
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
  
  void update(){
    if (!dead && !reachedGoal){ 
      move();
      if (pos.x < 2 || pos.y < 2 || pos.x > width - 2 || pos.y > height - 2){
         dead = true; //kill the dot if it goes outside of the window 
      } else if(dist(pos.x, pos.y, goal.x, goal.y) < 5){
        //if the dot reached the goal
        reachedGoal = true;
      } else {
        for (int[] boundary : Dots.obstacles){
          if (dist(pos.x, pos.y, boundary[0], boundary[1]) < 5){
            dead = true; //kill the dot if it is within an obstacle
          }
        }
      }
    }
  }
  
  //----------------------------
  
  void calculateFitness(){
    if (reachedGoal){ //judge fitness by how many steps it took
      fitness = 1.0/16.0 * 10000.0 / (float)(brain.step + brain.step); 
      
    }else { //judge fitness only by how close to the goal they were
      float distanceToGoal = dist(pos.x, pos.y, goal.x, goal.y); //give the difference in distance betweem pos and goal
      fitness = 1.0/(distanceToGoal * distanceToGoal); //like a percentage of how close the dot was to the goal;
                                                       //squared so a small improvement in distance is more heavily favoured (?)
    }
  }
  
  Dot getChild(){ //usually you'd have 'crossover' stuff here,
                    //but the program is so simple it doesn't need it
                    //just cloning instead
     Dot child = new Dot();
     child.brain = brain.clone();
     return child;
   }
  
}
