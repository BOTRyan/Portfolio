class SceneLoss {
  
  int levelToLoad;
  int fillColorR;
  int fillColorG = 85;
  int fillColorB = 170;
  boolean fillcolorRed;
  boolean fillcolorGreen;
  boolean fillcolorBlue;

  SceneLoss() {
    newButton("Back", "Back", width/2, height/1.25, buttonWidth, buttonHeight, buttonRadii, true);
    newButton("Restart", "Restart", width/2, height/1.8, buttonWidth, buttonHeight, buttonRadii, true);
  }

  void draw() {
    image(bgMars, 0, 0 );
    
    if(fillColorR >= 255) fillcolorRed = true;
    if(fillColorG >= 255) fillcolorGreen = true;
    if(fillColorB >= 255) fillcolorBlue = true;
    if(fillColorR <= 0) fillcolorRed = false;
    if(fillColorG <= 0) fillcolorGreen = false;
    if(fillColorB <= 0) fillcolorBlue = false;
    if(!fillcolorRed) fillColorR++;
    if(!fillcolorGreen) fillColorG++;
    if(!fillcolorBlue) fillColorB++;
    if(fillcolorRed) fillColorR--;
    if(fillcolorGreen) fillColorG--;
    if(fillcolorBlue) fillColorB--;

    // TOP TEXT
    pushMatrix();
    textSize(89);
    fill(fillColorR, fillColorG, fillColorB);
    text("Take this fat L", width/2, height/5);
    popMatrix();
    updateButtons();
    drawButtons();
  }

  void update() {
  }
}
