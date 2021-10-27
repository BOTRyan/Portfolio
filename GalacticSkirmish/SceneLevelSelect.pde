class SceneLevelSelect {

  boolean hoverBack = false;
  boolean hoverOne = false;

  float levelSize = 100;

  SceneLevelSelect() {
    leftMouse = false;
    rightMouse = false;
    prevMousePressed = false;
    newButton("1", "1", width/2 - 300, height/2, levelSize, levelSize, buttonRadii, true);
    newButton("2", "2", width/2 - 150, height/2, levelSize, levelSize, buttonRadii, true);
    newButton("3", "3", width/2, height/2, levelSize, levelSize, buttonRadii, true);
    newButton("4", "4", width/2 + 150, height/2, levelSize, levelSize, buttonRadii, true);
    newButton("5", "5", width/2 + 300, height/2, levelSize, levelSize, buttonRadii, true);
    newButton("Back", "Back", width/2, height/1.25, buttonWidth, buttonHeight, buttonRadii, true);
    baseHealth = 100;
  }

  void draw() {
    drawButtons();
  }

  void update() {
    background(198, 123, 92);


  image(levelBG, 0, 0 );

    // TOP TEXT
    pushMatrix();
    textSize(89);
    fill(255, 0, 0);
    text("Level Select", width/2, height/5);
    popMatrix();

    updateButtons();
  }
}
