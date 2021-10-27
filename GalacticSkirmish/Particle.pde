class Particle {
  float x;
  float y;
  String type;
  PVector v = new PVector();
  PVector a = new PVector();
  float minSpeed = -100;
  float maxSpeed = 100;
  float decay = 1;
  float maxVel = 550;
  Boolean xVelGreaterThanZero; //Whether x velocity is greater than zero
  Boolean yVelGreaterThanZero; //Whether y velocity is greater than zero
  float lifespan = 128;
  Particle(float xPos, float yPos, String name) {
    x = xPos;
    y = yPos;
    type = name;
    switch (type) {
    case "dust":
      v.x = random(minSpeed, maxSpeed);
      v.y = random(minSpeed, maxSpeed);
      break;
    case "wind":
      x = random(0, width);
      y = random(150, height);
      v.x = 0;
      v.y = 0;
      break;
    case "wind2":
      x = random(0, width);
      y = random(150, height);
      v.x = 0;
      v.y = 0;
      maxVel = maxVel-50;
      break;
    case "wind3":
      x = random(0, width);
      y = random(150, height);
      v.x = 0;
      v.y = 0;
      maxVel = maxVel-100;
      break;
    case "wind4":
      x = random(0, width);
      y = random(150, height);
      v.x = 0;
      v.y = 0;
      maxVel = maxVel-150;
      break;    
    case "smonk":
      v.x = random(-50, 50);
      v.y = random(-100, -200);
      maxVel = maxVel-125;
      break;
    }

    if (v.x > 0) xVelGreaterThanZero = true;
    else xVelGreaterThanZero = false;
    if (v.y > 0) yVelGreaterThanZero = true;
    else yVelGreaterThanZero = false;
  }
  void update() {
    switch (type) {
    case "dust":
      lifespan -= 50*dt;
      if(yVelGreaterThanZero) v.y-=decay;
      else v.y+=decay;
      if (yVelGreaterThanZero && v.y < 0) v.y = 0;
      else if (!yVelGreaterThanZero && v.y >0) v.y = 0;
      break;
    case "wind":
      if (x > width + 10) x = -5;
      if (x < -10) x = width + 5;
      break;
    case "wind2":
      if (x > width + 10) x = -5;
      if (x < -10) x = width + 5;
      break;
    case "wind3":
      if (x > width + 10) x = -5;
      if (x < -10) x = width + 5;
      break;
    case "wind4":
      if (x > width + 10) x = -5;
      if (x < -10) x = width + 5;
      break;
    case "smonk":
      lifespan -= 250*dt;
      break;
    }

    v.x+=a.x*2.5;
    if (v.x > maxVel) v.x = maxVel;
    else if (v.x < -maxVel) v.x = -maxVel;
    if (v.y > maxVel) v.y = maxVel;
    else if (v.y < -maxVel) v.y = -maxVel;
    x+=v.x*dt;
    y+=v.y*dt;


    //if(xVelGreaterThanZero) v.x-=decay;
    //else v.x+=decay;


    //if(xVelGreaterThanZero && v.x < 0) v.x = 0;
    //else if(!xVelGreaterThanZero && v.x >0) v.x = 0;
    //if(yVelGreaterThanZero && v.y < 0) v.y = 0;
    //else if(!yVelGreaterThanZero && v.y >0) v.y = 0;
  }
  void draw() {

    switch (type) {
    case "dust":
      tint(255, lifespan);
      noStroke();
      fill(255, 0, 0);
      //ellipse(x, y, 4, 4);
      image(rock, x, y, 3, 3);
      tint(255);
      break;
    case "wind":
      tint(255, 128);
      noStroke();
      fill(255, 0, 0);
      //ellipse(x, y, 4, 4);
      image(rock, x, y, 3, 3);
      tint(255);
      break;
    case "wind2":
      tint(255, 128);
      noStroke();
      fill(255, 0, 0);
      //ellipse(x, y, 4, 4);
      image(rock, x, y, 3, 3);
      tint(255);
      break;
    case "wind3":
      tint(255, 128);
      noStroke();
      fill(255, 0, 0);
      //ellipse(x, y, 4, 4);
      image(rock, x, y, 3, 3);
      tint(255);
      break;
    case "wind4":
      tint(255, 128);
      noStroke();
      fill(255, 0, 0);
      //ellipse(x, y, 4, 4);
      image(rock, x, y, 3, 3);
      tint(255);
      break;
    case "smonk":
      tint(255, lifespan);
      noStroke();
      fill(255, 0, 0);
      //ellipse(x, y, 4, 4);
      image(smonk, x, y);
      tint(255);
      break;
    }
  }
}
