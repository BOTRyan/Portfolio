class Enemies {

  // GRID-SPACE COORDINATES:
  Point gridP = new Point();
  Point gridT = new Point();

  // PIXEL-SPACE COORDINATES:
  PVector pixlP = new PVector(); // CURRENT PIXEL POSITION
  PVector pixlT = new PVector(); 

  PImage enemy;

  float x;
  float y;

  Tile tile = level.enemySpawn;
  Wall wall;

  ArrayList<Tile> path;
  boolean findPath = false;
  boolean canAttack = false;
  float radius = 16;
  float angle;
  float prevAngle;
  int attackTimer = 100;
  int health = 100;
  boolean isDead = false;
  boolean isDying = false;
  boolean isFlying = false;
  boolean isSlowed = false;
  int slowTimer = 0;
  int slowTimerReset = 50;
  float speed = .1;
  float speedReset;
  float dmg = 5;

  //Determines what enemy is spawned
  //1 = basic
  //2 = fast
  //3 = tank
  //4 = flying
  int enemyType = 1;

  //variables to change based on which enemy spawns
  //Health
  //speed
  //isFlying

  Enemies(Point spawnP, Point targetP, int eType) {
    teleportTo(spawnP);
    setTargetPosition(targetP);
    enemyType = eType;
    setEnemyValues();
  }

  void teleportTo(Point gridP) {
    Tile tile = level.getTile(gridP);
    if (tile != null) {
      this.gridP = gridP.get();
      this.gridT = gridP.get();
      this.pixlP = tile.getCenter();
    }
  }

  void setTargetPosition(Point gridT) {
    this.gridT = gridT.get();
  }

  void update() {
    if (!isDying) {
      if (findPath == true) findPathAndTakeNextStep();
      updateMove();
      attackTimer--;
      x = X;
      y = Y;
      if (attackTimer < 0) attackTimer = 0;

      //stop moving, stay and attack wall until wall is gone

      if (canAttack == true) {
        wall.health--;
      }
      if (isSlowed) speed = speedReset * .5;
      if (!isSlowed) speed = speedReset;
      if (slowTimer <= 0) {
        isSlowed = false;
        slowTimer = 0;
      }
      slowTimer--;
      if (health <= 0) {
        if (!extraDeaths) isDead = true;
        else {
          if (random(0, 1) > 0.95) {
            isDying = true;
            dying.play();
          } else isDead = true;
        }
      }
    } else {
      angle+=5*PI*dt;
      if (!dying.isPlaying()) {
        isDead = true;
      }
    }
  }

  void findPathAndTakeNextStep() {
    findPath = false;
    // FIND PATH TO TARGET GRID POSITION
    Tile start = level.getTile(gridP);
    Tile end = level.getTile(gridT);
    if (start == end) {
      path = null;
      isDead = true;
      baseHealth-=10;
      return;
    }

    // CHANGE CURRENT GRID POSITION TO NEXT STEP TOWARDS TARGET
    path = pathfinder.findPath(start, end);

    if (path != null && path.size() > 1) {
      tile = path.get(1);

      if (tile.isPassable()) {
        gridP = new Point(tile.X, tile.Y);
        canAttack = false;
      }
    }
  }

  void updateMove() {
    angleToNext();
    float snapThreshold = 1;


    // GET THE TARGET POSITION IN PIXELS
    pixlT = level.getTileCenterAt(gridP);
    PVector diff = PVector.sub(pixlT, pixlP);

    // MOVE CURRENT PIXEL POSITION TOWARDS TARGET
    pixlP.x += diff.x * speed;
    pixlP.y += diff.y * speed;

    // ENSURE NO MOVEMENT BUGS
    if (abs(diff.x) < snapThreshold) pixlP.x = pixlT.x;
    if (abs(diff.y) < snapThreshold) pixlP.y = pixlT.y;

    // IF WE'VE ARRIVED AT LOCATION, TRIGGER NEXT PATH FIND
    if (pixlT.x == pixlP.x && pixlT.y == pixlP.y) findPath = true;
  }

  void draw() {
    noStroke();


    pushMatrix();
    translate( pixlP.x, pixlP.y);    
    if (angle != 0) rotate(angle - degrees(40));
    if (angle == 0) rotate(prevAngle - degrees(40));
    image(enemy, - 10, - 10, 20, 20);

    popMatrix();

    //fill(0);
    //ellipse(pixlP.x, pixlP.y, 16, 16);
    //drawPath();
  }

  void drawPath() {
    // DRAW PATH
    if (path != null && path.size() > 1) {
      stroke(0);
      PVector prevP = pixlP.get();
      for (int i = 1; i < path.size(); i++) {
        PVector currP = path.get(i).getCenter();
        strokeWeight(2);
        line(prevP.x, prevP.y, currP.x, currP.y);
        prevP = currP;
      }
      noStroke();
      ellipse(prevP.x, prevP.y, 8, 8);
    }
  }


  void angleToNext() {
    prevAngle = angle;
    float dx = pixlP.x - pixlT.x;
    float dy = pixlP.y - pixlT.y;
    angle =  atan2(dy, dx);
  }

  void setEnemyValues() {
    if (enemyType == 1) {
      health = 100;
      speed = .1 * mult;
      isFlying = false;  
      enemy = baseEnemy;
    }
    if (enemyType == 2) {
      health = 60;
      speed = .2 * mult;
      isFlying = false;  
      enemy = fastEnemy;
    }
    if (enemyType == 3) {
      health = 350;
      speed = .07 * mult;
      isFlying = false;  
      enemy = tankEnemy;
    }
    if (enemyType == 4) {
      health = 150;
      speed = .11 * mult;
      isFlying = true;  
      enemy = flyEnemy;
    }
    speedReset = speed;
  }
}
