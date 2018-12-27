class Brain { //decides where the dot travels
              //'decides' - generates random directions
 
  PVector[] directions;
  int step = 0; //will keep track of which index of the directions array we're on
  
  Brain(int size){
   directions = new PVector[size];
   randomize();
  }
 

  //---------------

  void randomize(){ //putting random values into the directions array
   
    for (int i = 0; i < directions.length; i++){
     float randomAngle = random(2 * PI);
     directions[i] = PVector.fromAngle(randomAngle);
    }
    
  }
  
  //---------------------
  
  Brain clone(){
    Brain clone = new Brain(directions.length);
    for(int i = 0; i < directions.length; i++){
      clone.directions[i] = directions[i].copy(); //copy the path the dot took
    }
    
    return clone;
  }
  
  //------------------------
  
  void mutate(){
    float mutationRate = 0.01; //the *chance* that a mutation will occur
    for (int i = 0; i < directions.length; i++){
      float rnd = random(1);
      
      if(rnd < mutationRate){ //then mutate!!
        float randomAngle = random(2*PI);
        directions[i] = PVector.fromAngle(randomAngle);
      }
    }
  }
  

}
