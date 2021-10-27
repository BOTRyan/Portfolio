class Emitter {
  float x;
  float y;
  float lifetime;
  String type;
  float frequency;
  Boolean isDead = false;
  float timer;
  Emitter(float xPos, float yPos, String ptype, float duration, float particlesPerSecond) {
    lifetime = duration;
    x = xPos;
    y = yPos;
    type = ptype;
    frequency = particlesPerSecond;
    timer = 0;
  }
  void update() {
    timer+=dt;
    lifetime-=dt;
    if (lifetime<0) isDead = true;
    else if (!isDead) {
      if (timer >= 1/frequency) {
        burst(x-10, y-10, type, 1);
        timer -= 1/frequency;
      }
      //freq
    }
  }
}
