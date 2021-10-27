public class Tower { 

  boolean hasBeenPlaced = false;
  float radius = 150;
  float angle;
  float shootTimer;
  float shootTimerReset;
  int baseDamage = 30;
  
  int explosionTimer = 0;
  int explosionDrawTimer = 0;
  int explosionRadius = 100;
  boolean hasExploded = false;
  
  boolean canHitFlying = false;
  
  //PImage tower1; 

  // 1 == base level
  // 2 == damage upgrade
  // 3 == damage upgrade
  // 4 == change in type
  int upgradeTool = 1;

  int towerType;

  // PIXEL-SPACE COORDINATES:
  PVector pixlP = new PVector(); // CURRENT PIXEL POSITION

  Tower(PVector tileLocation) {
    pixlP = tileLocation;
    
  }

  void draw() {
    
    
    
  }

  void update() {    
    if (shootTimer > 0) {
          shootTimer--;
        } else shootTimer = 0;
  }

  boolean distanceTowerEnemy(Tower a, Enemies b) {
    float dx = b.pixlP.x - a.pixlP.x;
    float dy = b.pixlP.y - a.pixlP.y;
    float dis = sqrt(dx * dx + dy * dy);
    if (dis < a.radius + b. radius) return true;
    return false;
  }

  float angleToEnemy(Tower a, Enemies b) {
    float dx = b.pixlP.x - a.pixlP.x;
    float dy = b.pixlP.y - a.pixlP.y;
    return atan2(dy, dx);
  }
  
  boolean distanceToExplosionRadius(Tower a, Enemies b) {
    float dx = b.pixlP.x - a.pixlP.x;
    float dy = b.pixlP.y - a.pixlP.y;
    float dis = sqrt(dx * dx + dy * dy);
    if (dis < a.explosionRadius + b. radius) return true;
    return false;
  }
}
