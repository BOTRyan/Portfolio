class Button {
  float inc = 2.5;//increment by which stats increase
  float x;      //x position
  float y;      //y position
  float w;      //width
  float h;      //height
  float r;      //roundness of corners
  String name;  //name of button
  String desc;  //button tag
  int relPos;   //relative x position: 1, 2, and 3 are equivalent to left, middle and right respectively

  Boolean deleteThisShit = false;
  Boolean sfxReady = false;
  Boolean canBePressed = true;


  Button(String tag, String title, float xpos, float ypos, float buttonWidth, float buttonHeight, float radii, boolean isActive) {
    x = xpos;
    y = ypos;
    w = buttonWidth;
    h = buttonHeight;
    r = radii;
    name = title;
    desc = tag;
    if (x<width/2) relPos = 1;
    else if (x > 2*width/5 && x < 3*width/5) relPos = 2;
    else relPos = 3;
    canBePressed = isActive;
  }

  void update() {
    //if(sfxReady) hoverSFX.play();
    if (isHovered() && leftMouse && !prevMousePressed && canBePressed) press();
  }

  void draw() {
    stroke(255);
    strokeWeight(4);       
    if (isHovered()) fill(237, 28, 36);    
    else fill(0);

    if (hasRemoveTool && desc == "Remove") fill(237, 28, 36);
    if (hasUpgradeTool && desc == "Upgrade") fill(237, 28, 36);



    if (towerSelector == 1 && desc == "Tower1") { 
      priceToPay = "-$5";
      name = "";
      fill(237, 28, 36);
    } else if (towerSelector != 1 && desc == "Tower1") {
      name = "$5";
    }

    if (towerSelector == 2 && desc == "Tower2") { 
      priceToPay = "-$10";
      name = "";
      fill(237, 28, 36);
    } else if (towerSelector != 2 && desc == "Tower2") {
      name = "$10";
    }

    if (towerSelector == 3 && desc == "Tower3") { 
      priceToPay = "-$15";
      name = "";
      fill(237, 28, 36);
    } else if (towerSelector != 3 && desc == "Tower3") {
      name = "$15";
    }

    if (towerSelector == 4 && desc == "Wall") {
      priceToPay = "-$5";
      name = "";
      fill(237, 28, 36);
    } else if (towerSelector != 1 && desc == "Wall") {
      name = "Wall:\n$5";
    }

    if (!canBePressed) {
      fill(50);
    }

    rect(x, y, w, h, r);

    if (desc == "Tower1") textFont(moneyFont, 24);
    if (desc == "Tower2") textFont(moneyFont, 24);
    if (desc == "Tower3") textFont(moneyFont, 24);


    fill(255);
    textAlign(CENTER, CENTER);
    textSize(48);
    text(name, x, y);
  }

  Boolean isHovered() {
    float left = x - w/2;
    float right = x + w/2;
    float top = y - h/2;
    float bot = y + h/2;

    if (mouseX >= left && mouseX <= right && mouseY >= top && mouseY <= bot && sfxReady) {
      hoverSFX.play();
      sfxReady = false;
      return true;
    } else if (mouseX >= left && mouseX <= right && mouseY >= top && mouseY <= bot && !sfxReady) {
      return true;
    } else {
      sfxReady = true;
      return false;
    }
  }

  void press() {
    pressSFX.play();
    switch(desc) {
    case "Play":
      fuckThoseButtons();
      fuckThoseParticles();
      switchToSelect();
      break;
    case "Quit":
      if (sceneGame == null) {
        exit();
      } else {
        fuckThoseButtons();
        fuckThoseParticles();
        switchToTitle();
        break;
      }
    case "1":
      //change level to 1 in place of this line
      fuckThoseButtons();
      fuckThoseParticles();
      levelToLoad = 1;
      level = new Level();
      switchToGame();
      break;
    case "2":
      //change level to 2 in place of this line
      fuckThoseButtons();
      fuckThoseParticles();
      levelToLoad = 2;
      level = new Level();
      switchToGame();
      break;
    case "3":
      //change level to 3 in place of this line
      fuckThoseButtons();
      fuckThoseParticles();
      levelToLoad = 3;
      level = new Level();
      switchToGame();
      break;
    case "4":
      //change level to 4 in place of this line
      fuckThoseButtons();
      fuckThoseParticles();
      levelToLoad = 4;
      level = new Level();
      switchToGame();
      break;
    case "5":
      //change level to 5 in place of this line
      fuckThoseButtons();
      fuckThoseParticles();
      levelToLoad = 5;
      level = new Level();
      switchToGame();
      break;
    case "Upgrade":
      if (hasUpgradeTool) hasUpgradeTool = false;
      else hasUpgradeTool = true;
      hasRemoveTool = false;
      towerSelector = 0;
      break;
    case "Remove":
      if (hasRemoveTool) hasRemoveTool = false;
      else hasRemoveTool = true;
      hasUpgradeTool = false;
      towerSelector = 0;
      break;
    case "Back":
      fuckThoseButtons();
      fuckThoseParticles();
      switchToTitle();
      break;
    case "Tower1":
      towerSelector = 1;
      hasUpgradeTool = false;
      hasRemoveTool = false;
      break;
    case "Tower2":
      towerSelector = 2;
      hasUpgradeTool = false;
      hasRemoveTool = false;
      break;
    case "Tower3":
      towerSelector = 3;
      hasUpgradeTool = false;
      hasRemoveTool = false;
      break;
    case "Wall":
      towerSelector = 4;
      hasUpgradeTool = false;
      hasRemoveTool = false;
      break;
    case "Restart":
      fuckThoseButtons();
      fuckThoseParticles();      
      level = new Level();
      switchToGame();
      break;
    }
  }
}
