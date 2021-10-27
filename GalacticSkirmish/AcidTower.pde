class AcidTower extends Tower {  

  public final PVector tileLocation = new PVector(0, 0);
  int poisonTimer = 50;
  int poisonReset = poisonTimer;
  boolean hasPoisoned = false;


  AcidTower(PVector tileLocation) {
    super(tileLocation);
    radius = 75;
    baseDamage = 10;
    shootTimer = int(75 / mult);
    shootTimerReset = shootTimer;
  }

  void draw() {
    super.draw();
    fill(0, 255, 0);

    towerType = 2;

    //circle(pixlP.x, pixlP.y, radius * 2);

    image(tower2, pixlP.x - 10, pixlP.y - 10, 20, 20);

    //circle(pixlP.x,pixlP.y,20);
  }

  void update() {
    super.update();

    if (hasPoisoned) poisonTimer--;
    if (poisonTimer <= 0) {
      poisonTimer = poisonReset;
      hasPoisoned = false;
    }    
    if (upgradeTool == 2) {
      radius = 100;
      baseDamage = 15;
    }
    if (upgradeTool == 3) {
      radius = 125;
      baseDamage = 20;
    }
    if (upgradeTool == 4) {
      radius = 150;
    }
  }
}
