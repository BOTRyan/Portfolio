class ShooterTower extends Tower {  

  public final PVector tileLocation = new PVector(0, 0);

  ShooterTower(PVector tileLocation) {
    super(tileLocation);
    shootTimer = int(80 / mult);
    shootTimerReset = shootTimer;
  }

  void draw() {
    super.draw();

    towerType = 1;

    pushMatrix();
    if(!biggerTowers) image(tower1, pixlP.x - 10 , pixlP.y - 10 , 20 , 20);
    else image(tower1, pixlP.x - 12.5 , pixlP.y - 12.5 , 25 , 25);
    //fill(255, 0, 0);
    //if (upgradeTool == 2) fill(255, 0, 255);
    //if (upgradeTool == 3) fill(255, 255, 0);
    //if (upgradeTool == 4) fill(255, 255, 255);
    //translate(pixlP.x, pixlP.y);
    //rotate(angle);
    //circle(0, 0, 20);
    popMatrix();
  }

  void update() {
    super.update();
    
    if(upgradeTool == 2){
      radius = 175;
      baseDamage = 35;
    }
    if(upgradeTool == 3){
      radius = 200;
      baseDamage = 40;
    }
    if(upgradeTool == 4){
      radius = 225;
      shootTimerReset = int(24 / mult);
    }
  }
}
