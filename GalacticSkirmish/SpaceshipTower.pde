class SpaceshipTower extends Tower{  
  
  public final PVector tileLocation = new PVector(0,0);
  
  
  SpaceshipTower(PVector tileLocation){
    super(tileLocation);
    radius = 200;
    shootTimer = int(90 / mult);
    shootTimerReset = shootTimer;
    baseDamage = 40;
    canHitFlying = true;
  }
  
  void draw(){
    super.draw();
    fill(0,0,255);
    //circle(pixlP.x,pixlP.y,explosionRadius * 2);
    towerType = 3;
    if(upgradeTool == 4 && explosionDrawTimer > 0) image(explosion, pixlP.x - 75 , pixlP.y - 75 , 150 , 150);
    
    image(spaceship, pixlP.x - 10 , pixlP.y - 10 , 20 , 20);
    
    
    
  }
  
  void update(){
    super.update();
    explosionTimer--;
    explosionDrawTimer--;
    if(explosionTimer <= -1) explosionTimer = -1;
    if(explosionDrawTimer <= -1) explosionDrawTimer = -1;
    
    if (hasExploded) {
      explosionTimer = 800;
      explosionDrawTimer = 40;
      hasExploded = false;
    }
    
    if(upgradeTool == 2){
      radius = 200;
      baseDamage = 50;
    }
    if(upgradeTool == 3){
      radius = 225;
      shootTimerReset = int(60 / mult);
      
    }
    if(upgradeTool == 4){
      radius = 250;
      baseDamage = 60;
    }
  }
}
