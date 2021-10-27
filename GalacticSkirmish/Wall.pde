public class Wall {

  PVector pixlP = new PVector(); // CURRENT PIXEL POSITION

  float x;
  float y;
  int health = 50;
  boolean isDead = false;

  Wall(PVector tileLocation) {
    pixlP = tileLocation;
    x = tileLocation.x;
    y = tileLocation.y;
  }

  void draw() {

    image(wall, x - 10, y - 10, 20, 20);
    
    //ellipse(x - 7.5, y - 7.5, 15, 15);
  }

  void update() {
    if(health <= 0) isDead = true;
  }
}
