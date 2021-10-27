class SceneWin {

  SceneWin() {
    newButton("Back", "Back", width/2, height/1.25, buttonWidth, buttonHeight, buttonRadii, true);
    newButton("Restart", "Restart", width/2, height/1.8, buttonWidth, buttonHeight, buttonRadii, true);
  }

  void draw() {
    image(levelBG, 0, 0 );

    // TOP TEXT
    pushMatrix();
    textSize(89);
    fill(255, 0, 0);
    text("Victory", width/2, height/5);
    popMatrix();
    updateButtons();
    drawButtons();
  }

  void update() {
  }
}
