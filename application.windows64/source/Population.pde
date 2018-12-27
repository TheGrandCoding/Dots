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
  
  void show(){
   for (int i = 0; i < dots.length; i++){
     dots[i].show();
   }
   dots[0].show(); //the best dot
  }
   
   void update(){
     for (int i = 0; i < dots.length; i++){
       if(dots[i].brain.step > bestSteps){
         dots[i].dead = true; //kill the dot if it's taken too many steps
       } else {
         dots[i].update();
       }
     }
   
   }
   
   void calculateFitness(){
     for (int i = 0; i < dots.length; i++){
       dots[i].calculateFitness();
     }
     
   }
   
   //-------------------
   
   boolean allDotsDead(){
     for (int i = 0; i < dots.length; i++){
       if (!dots[i].dead && !dots[i].reachedGoal) {
         return false;
       }
       
     }
     return true;
     
   }
   
   //------------------------
   
   void naturalSelection(){ //the 'AI' bit
     
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
   
   void setBestDot(){ //the 'champion' of the generation goes through to the 
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
   
   void calculateFitnessSum(){
     fitnessSum = 0;
     for(int i = 0; i < dots.length; i++){
       fitnessSum += dots[i].fitness;
     }
   }
   
   //-----------------------------------
   
   Dot selectParent(){
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
   
   void mutate(){
    for (int i = 1; i < dots.length; i++){
      dots[i].brain.mutate();
    }
    
   }
   
}  
