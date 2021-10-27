// This program runs a tower defense game
// Copyright Ryan O'Connor, David Vargas, Jacob Klukas, Lincoln Grinenko, Samuel Robey 2020

import processing.sound.*;

SceneGame sceneGame;
SceneTitle sceneTitle;
SceneLevelSelect sceneSelect;
SceneLoss sceneLoss;
SceneWin sceneWin;
Level level;
Enemies enemies;
Pathfinder pathfinder;

float currTime;
float prevTime = 0;
float dt;

// 0 == nothing
// 1 == shooter tower
// 2 == acid tower
// 3 = spaceship tower
int towerSelector = 0;

float mult = 1;

int levelToLoad = 1;

String priceToPay = "";

boolean rightMouse = false;
boolean leftMouse = false;
boolean prevMousePressed = false;
boolean hasRemoveTool = false;
boolean hasUpgradeTool = false;

PImage rock;//Graphic for the boulders which populate levels
PImage tower1;//Shooter tower image
PImage tower2;//Acid tower image
PImage spaceship;
PImage baseEnemy;//Image for basic enemy type
PImage tankEnemy;//Sprite for tanky enemies
PImage fastEnemy;//Sprite for fast-moving enemies
PImage flyEnemy;//Sprite for flying enemies
PImage splash;//Menu splash art
PImage levelBG;//In-game background
PImage homeBase;//Base the player guards
PImage enemyBase;
PImage acidPatch;//Graphic for acid puddles from un-upgraded towers
PImage wall;//Image for placeable wall tiles
PImage acidUpgrade;//Image for acid puddles from upgraded towers
PImage bulletUpgrade;//Image for bullets from upgraded shooter towers
PImage ufoBullet;//Image for spaceship tower bullets
PImage explosion;//Image for explosions from spaceship tower
PImage smonk;//Smoke particle
PImage bgMoon;
PImage bgMars;

float baseHealth = 100;

//Button variables:
float buttonWidth = 300;//Determines default width of buttons.
float buttonHeight = 100;//Determines default height of buttons.
float buttonRadii = 10;//Determines default roundness of button corners.
ArrayList<Button> buttons = new ArrayList();//Array list which stores all buttons.

//Sam's experimental variables - Should never be true for final build
boolean extraDeaths = true; //5% chance to proc during enemy death when enabled
boolean biggerTowers = false; //looks nifty until you place a tower above another tower

ArrayList<Particle> particles = new ArrayList();

PFont font;//Font in the style of the title screen
PFont moneyFont;//Font similar to the title screen text but with clearer numbers

PVector wind;

SoundFile hoverSFX;
SoundFile pressSFX;
SoundFile bgmSFX;
SoundFile dying;
SoundFile death01;
SoundFile death02;
SoundFile shoot;

void setup() {
  size(1280, 720);
  TileHelper.app = this;
  pathfinder = new Pathfinder();
  rectMode(CENTER);
  switchToTitle();
  rock = loadImage("redWall.png");
  tower1 = loadImage("tower01.png");
  tower2 = loadImage("tower02.png");
  spaceship = loadImage("spaceship.png");
  baseEnemy = loadImage("baseEnemy.png");
  tankEnemy = loadImage("tankEnemy.png");
  fastEnemy = loadImage("fastEnemy.png");
  flyEnemy = loadImage("flyEnemy.png");
  splash = loadImage ("splash.png");
  levelBG = loadImage ("levelBG.png");
  homeBase= loadImage ("homeBase.png");
  enemyBase = loadImage ("enemyBase.png");
  acidPatch = loadImage ("acidPatch.png");
  acidUpgrade = loadImage ("acidUpgrade.png");
  bulletUpgrade = loadImage ("bulletUpgrade.png");
  wall = loadImage ("wall.png");
  ufoBullet = loadImage ("UFObullet.png");
  explosion = loadImage ("explosion.png");
  smonk = loadImage("smonk.png");
  bgMoon = loadImage("bgMoon.png");
  bgMars = loadImage("bgMars.png");

  font = createFont("fml.ttf", 32);
  textFont(font, 32);
  moneyFont = createFont("fyl.ttf", 32);

  hoverSFX = new SoundFile(this, "hover.wav");
  pressSFX = new SoundFile(this, "press.wav");
  //bgmSFX = new SoundFile(this, "bgm.wav");
  dying = new SoundFile(this, "dying.wav");
  death01 = new SoundFile(this, "death01.wav");
  death02 = new SoundFile(this, "death02.wav");
  shoot = new SoundFile(this, "shoot.wav");
  pressSFX.amp(0.75);
  shoot.amp(0.15);
  //bgmSFX.amp(0.15);
  
}

void draw() {
  //DELTAAA TIMEEE
  dt = calcDeltaTime();
  //if (!bgmSFX.isPlaying()) bgmSFX.play();
  //Switch Scene
  if (sceneTitle != null) {
    sceneTitle.update();
    if (sceneTitle != null) sceneTitle.draw(); // this extra if statement exists because the sceneTitle.update() might result in the scene switching...
  } else if (sceneGame != null) {
    sceneGame.update();
    if (sceneGame != null) sceneGame.draw(); // this extra if statement exists because the scenePlay.update() might result in the scene switching...
  } else if (sceneSelect != null) {
    sceneSelect.update();
    if (sceneSelect != null) sceneSelect.draw();
  }else if (sceneWin != null) {
    sceneWin.update();
    if (sceneWin != null) sceneWin.draw();
  }else if (sceneLoss != null) {
    sceneLoss.update();
    if (sceneLoss != null) sceneLoss.draw();
  }
}

void switchToTitle() {
  sceneTitle = new SceneTitle();
  sceneGame = null;
  sceneSelect = null;
  sceneWin = null;
  sceneLoss = null;
}
void switchToGame() {
  sceneGame = new SceneGame();
  sceneTitle = null;
  sceneSelect = null;
  sceneWin = null;
  sceneLoss = null;
}
void switchToSelect() {
  sceneSelect = new SceneLevelSelect();
  sceneGame = null;
  sceneTitle = null;
  sceneWin = null;
  sceneLoss = null;
}
void switchToLoss() {
  sceneLoss = new SceneLoss();
  sceneSelect = null;
  sceneGame = null;
  sceneTitle = null;
  sceneWin = null;
}
void switchToWin() {
  sceneWin = new SceneWin();
  sceneSelect = null;
  sceneGame = null;
  sceneTitle = null;
  sceneLoss = null;
}


void mousePressed() {
  if (mouseButton == LEFT) leftMouse = true;
  if (mouseButton == RIGHT) rightMouse = true;
}
void mouseReleased() {
  if (mouseButton == LEFT) leftMouse = false;
  if (mouseButton == RIGHT) rightMouse = false;
}

float calcDeltaTime() {
  currTime = millis();
  float deltaTime = (currTime - prevTime)/1000;
  prevTime = currTime;
  return deltaTime;
}

void newButton(String s, String n, float x, float y, float w, float h, float r, boolean c) {
  Button b = new Button(s, n, x, y, w, h, r, c);
  buttons.add(b);
}

//Iterates through the button array and executes the update function.
void updateButtons() {
  for (int i = 0; i < buttons.size(); i++) {
    buttons.get(i).update();
  }
}

void setButtonsToTrue() {
  for (int i = 0; i < buttons.size(); i++) {
    buttons.get(i).canBePressed = true;
  }
}

//Iterates through the button array and executes the draw function.
void drawButtons() {
  for (int i = 0; i < buttons.size(); i++) {
    buttons.get(i).draw();
  }
}

void fuckThoseButtons() {
  for (int i = buttons.size()-1; i >= 0; i--) {
    buttons.remove(i);
  }
}

void fuckThoseParticles() {
  for (int i = particles.size()-1; i >= 0; i--) {
    particles.remove(i);
  }
}

void burst(float x, float y, String type, float amount) {
  for (int i = 0; i < amount; i++) {
    Particle p = new Particle(x, y, type);
    particles.add(p);
  }
}

//Iterates through the particles array and executes the update function.
void updateParticles() {
  //particles.applyForce(wind);
  for (int i = 0; i < particles.size(); i++) {
    particles.get(i).a.x = wind.x;
    particles.get(i).update();
  }
}

//Iterates through the particles array and executes the draw function.
void drawParticles() {
  for (int i = 0; i < particles.size(); i++) {
    particles.get(i).draw();
  }
}


void polygon(float x, float y, float radius, int npoints) {
  float angle = TWO_PI / npoints;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}
