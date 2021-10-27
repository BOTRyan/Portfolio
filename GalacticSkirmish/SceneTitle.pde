class SceneTitle {

  PImage Title;
 
  //boolean hoverPlay = false;
  //boolean hoverQuit = false;

  SceneTitle() {
    leftMouse = false;
    rightMouse = false;
    prevMousePressed = false;
    //hoverPlay = false;
    //hoverQuit = false;
    Title = loadImage("GalacticSkirmishStacked.png");
  

    newButton("Play", "Play", width/6, height/1.7, buttonWidth, buttonHeight, buttonRadii, true);
    newButton("Quit", "Quit", width/6, height/1.2, buttonWidth, buttonHeight, buttonRadii, true);
  }

  void draw() {
    drawButtons();
  }

  void update() {
    // BACKGROUND
    background(198, 123, 92);

    // SPLASH IMAGE
    
    image(splash, 0, 0, 1280, 720 );


    // TITLE IMAGE
    pushMatrix();
    scale(.2);
    image(Title, width - 1000, 221, 2744, 1326);
    popMatrix();
    
    

    // BUTTONS
    updateButtons();

    ////SPLASH ART
    //pushMatrix();
    //stroke(0);
    //strokeWeight(4);
    //fill(198, 123, 92, 0);
    //rect(width/1.35, height/2, 500, 700);
    //fill(0);
    //text("Splash Art", width/1.35, height/2);
    //popMatrix();

    //PREVENTS DOUBLE CLICKING
    prevMousePressed = leftMouse;
  }
}
