class Bullet {

  float x;
  float y;
  float angle;
  float speed = 500;
  float radius = 10;
  boolean isDead = false;
  int damage;
  int towerType;
  int towerUpgrade;
  boolean canDamageFlying = false;

  Bullet(float posX, float posY, float angleT, int baseDamage, int tType, int uType) {
    x = posX;
    y = posY;
    angle = angleT;
    damage = baseDamage;
    towerType = tType;
    towerUpgrade = uType;
    shoot.play();
  }

  void update() {
    x += cos(angle) * speed * dt;
    y += sin(angle) * speed * dt;
    if (x < -100) isDead = true;
    if (x > width + 100) isDead = true;
    if (y < 160) isDead = true;
    if (y > height + 100) isDead = true;
  }

  void draw() {
    pushMatrix();
    fill(0);
    noStroke();
    if (towerType == 1) {
      if (towerUpgrade < 4) {
        fill(100, 100, 255);
        circle(x - 5, y - 5, 10);
      } else if (towerUpgrade >= 4) {
        image(bulletUpgrade, x - 5, y - 5, 10, 10);
      }
    }
    if (towerType == 2) {      
      if (towerUpgrade < 4) {
        image(acidPatch, x - 5, y - 5, 10, 10);
      } else if (towerUpgrade >= 4) {
        image(acidUpgrade, x - 5, y - 5, 10, 10);
      }
    }
    if (towerType == 3) {      
      image(ufoBullet, x - 5, y - 5, 10, 10);
      canDamageFlying = true;
    }

    popMatrix();
  }
}
