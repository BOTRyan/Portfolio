class SceneGame {

  Point g;
  Tile tile;

  ArrayList<Enemies> enemies = new ArrayList();
  ArrayList<Tower> towers = new ArrayList();
  ArrayList<Bullet> bullets = new ArrayList();
  ArrayList<Wall> walls = new ArrayList();
  ArrayList<Emitter> emitters = new ArrayList();

  boolean doOnce = false;
  boolean paused = false;

  int currency = 15;
  int currencyAmount = 15;

  //when the player beats wave 10 beats the game, open a win screen or main menu
  int wave = 0;
  boolean isInWave = false;
  boolean isSpawningEnemies = false;
  int waveTimer = 500;
  int spawnTimer = 0;
  int basicEnemiesToSpawn = 0;
  int fastEnemiesToSpawn = 0;
  int tankEnemiesToSpawn = 0;
  int flyingEnemiesToSpawn = 0;
  int totalEnemiesToSpawn = 0;
  int totalEnemiesSpawned = 0;
  int spawnValue = 1;
  int lowSpawnValue;
  int highSpawnValue;

  PVector m;

  float windSpeed = 20;
  Boolean add = false;

  float windParticles = 200; //This MUST be evenly divisible by 4 otherwise you will get an error. Bigger numbers look nicer but drop framerate


  //int phase;
  //1: Placement phase
  //
  //

  //when buttons are added, if remove tool is selected change hasupgradetool to false and vice versa. also set towerSelector = 0 so they can't place any towers. when tower is selected, set tower selector to appropiate tower #

  SceneGame() {
    baseHealth = 100;
    // Prevents Double Clicking on Load
    leftMouse = false;
    rightMouse = false;
    prevMousePressed = false;
    //Spawn Buttons
    newButton("Upgrade", "Upgrade", width/1.275, height/18, 240, 50, buttonRadii, true);
    newButton("Remove", "Remove", width/1.275, height/6.65, 240, 50, buttonRadii, true);
    newButton("Quit", "Quit", width - 74.5, 74.5, 100, 100, buttonRadii, true);
    newButton("Tower1", "$5", width/2 - 300, 74.5, 100, 100, buttonRadii, true);
    newButton("Tower2", "$10", width/2 - 180, 74.5, 100, 100, buttonRadii, false);
    newButton("Tower3", "$15", width/2 - 60, 74.5, 100, 100, buttonRadii, false);
    newButton("Wall", "Wall:\n$5", width/2 + 120, 74.5, 200, 100, buttonRadii, true);



    for (int i = 0; i < (windParticles/4); i++) {
      Particle p = new Particle(0, 0, "wind");
      particles.add(p);
    }
    for (int i = 0; i < (windParticles/4); i++) {
      Particle p = new Particle(0, 0, "wind2");
      particles.add(p);
    }
    for (int i = 0; i < (windParticles/4); i++) {
      Particle p = new Particle(0, 0, "wind3");
      particles.add(p);
    }
    for (int i = 0; i < (windParticles/4); i++) {
      Particle p = new Particle(0, 0, "wind4");
      particles.add(p);
    }
  }

  void update() { 

    if (baseHealth<=0) {
      fuckThoseButtons();
      fuckThoseParticles();
      switchToLoss();
    }

    if (wave >= 4) setButtonsToTrue();

    //WIND
    //float dx = map(mouseX, 0, width, -20, 20); //Maps wind to mouse for debugging
    if (windSpeed >= 20) add = false;
    else if (windSpeed <= -20) add = true;

    if (add)windSpeed+=dt;
    else windSpeed-=dt;

    if (windSpeed>20)windSpeed = 20;
    else if (windSpeed<-20) windSpeed = -20;

    wind = new PVector(windSpeed, 0);

    image(bgMoon, -5, 145);

    // Draw Level & Buttons
    level.draw();
    updateEmitters();
    updateWaves();



    // Gets the Tile Mouse is Hovering
    g = TileHelper.pixelToGrid(new PVector(mouseX, mouseY - 150));
    tile = level.getTile(g);
    if (tile != null) { 
      tile.isHovered = true;
      m = tile.getCenter();
      fill(0);
      //ellipse(m.x, m.y, 8, 8);
    }    

    // Updates Enemy Array
    for (int i = 0; i < enemies.size(); i++) {
      enemies.get(i).update();
      if (enemies.get(i).pixlP.x == enemies.get(i).gridT.x && enemies.get(i).pixlP.y == enemies.get(i).gridT.y) {
        enemies.get(i).isDead = true;
        baseHealth-=enemies.get(i).dmg;
      }
      enemies.get(i).draw();  
      for (int j = 0; j < walls.size(); j++) {
        if (enemies.get(i).tile.getCenter().x == walls.get(j).pixlP.x && enemies.get(i).tile.getCenter().y == walls.get(j).pixlP.y) {
          enemies.get(i).wall = walls.get(j);
          enemies.get(i).canAttack = true;
          //if(enemies.get(i).wall == null) enemies.get(i).tile.TERRAIN = 0;
        }
      }
      if (enemies.get(i).isDead) {
        if (random(0, 1) > 1f) death01.play();
        else death02.play();
        burst(enemies.get(i).pixlP.x, enemies.get(i).pixlP.y, "dust", 25);
        enemies.remove(i);
        totalEnemiesSpawned--;
        currency++;
      }
    }

    //Updates walls array
    try {
      for (int k = 0; k < walls.size(); k++) {
        walls.get(k).update();
        walls.get(k).draw();
        if (walls.get(k).isDead) {       
          for (int i = 0; i < enemies.size(); i++) {
            if (enemies.get(i).tile.getCenter().x == walls.get(k).pixlP.x && enemies.get(i).tile.getCenter().y == walls.get(k).pixlP.y) {
              enemies.get(i).tile.TERRAIN = 0;
              enemies.get(i).tile.hasATower = false;
              spawnSmokeEmitter(walls.get(k).pixlP.x, walls.get(k).pixlP.y);
              walls.remove(k);
            }
          }
        }
      }
    } 
    catch (IndexOutOfBoundsException e) {
    }

    // Updates Tower Array
    for (int i = 0; i < towers.size(); i++) {
      towers.get(i).update();
      towers.get(i).draw();

      // Gets all Enemies
      // If Tower and Enemy Are Close and ShootTimer <= 0
      // Spawn a Bullet
      for (int j = 0; j < enemies.size(); j++) {
        if (towers.get(i).distanceTowerEnemy(towers.get(i), enemies.get(j)) && towers.get(i).shootTimer <= 0 ) {
          if (towers.get(i).canHitFlying) {
            Bullet b = new Bullet(towers.get(i).pixlP.x, towers.get(i).pixlP.y, towers.get(i).angleToEnemy(towers.get(i), enemies.get(j)), towers.get(i).baseDamage, towers.get(i).towerType, towers.get(i).upgradeTool);
            bullets.add(b);
            towers.get(i).shootTimer = towers.get(i).shootTimerReset;
          } else if (!towers.get(i).canHitFlying && !enemies.get(j).isFlying) {
            Bullet b = new Bullet(towers.get(i).pixlP.x, towers.get(i).pixlP.y, towers.get(i).angleToEnemy(towers.get(i), enemies.get(j)), towers.get(i).baseDamage, towers.get(i).towerType, towers.get(i).upgradeTool);
            bullets.add(b);
            towers.get(i).shootTimer = towers.get(i).shootTimerReset;
          }
        }
        if (towers.get(i).distanceToExplosionRadius(towers.get(i), enemies.get(j)) && towers.get(i).upgradeTool == 4 && towers.get(i).towerType == 3 && towers.get(i).explosionTimer <= 0) {          
          enemies.get(j).health -= 110;
          spawnSmokeEmitter(enemies.get(j).pixlP.x, enemies.get(j).pixlP.y);
          towers.get(i).hasExploded = true;
        }
      }




      // If hovering a tile that is not null, and has upgrade tool
      // Change priceToPay variable depending on the type of tower and it's upgrade level

      // Else if has removal tool
      // Change priceToPay variable depending on the type of tower  


      if (hasUpgradeTool && tile != null && tile.isHovered) {
        if (tile.getCenter().x == towers.get(i).pixlP.x && tile.getCenter().y == towers.get(i).pixlP.y) {
          if (towers.get(i).upgradeTool == 1) {
            if (towers.get(i).towerType == 1) {              
              priceToPay = "-$10";
              noFill();
              stroke(255, 255, 255, 100);        
              circle(tile.getCenter().x, tile.getCenter().y, 350);
            } else if (towers.get(i).towerType == 2) {
              priceToPay = "-$15";
              noFill();
              stroke(255, 255, 255, 100);        
              circle(tile.getCenter().x, tile.getCenter().y, 200);
            } else if (towers.get(i).towerType == 3) {
              priceToPay = "-$20";
              noFill();
              stroke(255, 255, 255, 100);        
              circle(tile.getCenter().x, tile.getCenter().y, 400);
            }
          }  
          if (towers.get(i).upgradeTool == 2) {
            if (towers.get(i).towerType == 1) {
              priceToPay = "-$15";
              noFill();
              stroke(255, 255, 255, 100);        
              circle(tile.getCenter().x, tile.getCenter().y, 400);
            } else if (towers.get(i).towerType == 2) {
              priceToPay = "-$20";
              noFill();
              stroke(255, 255, 255, 100);        
              circle(tile.getCenter().x, tile.getCenter().y, 250);
            } else if (towers.get(i).towerType == 3) {
              priceToPay = "-$25";
              noFill();
              stroke(255, 255, 255, 100);        
              circle(tile.getCenter().x, tile.getCenter().y, 450);
            }
          }  
          if (towers.get(i).upgradeTool == 3) {
            if (towers.get(i).towerType == 1) {
              priceToPay = "-$20";
              noFill();
              stroke(255, 255, 255, 100);        
              circle(tile.getCenter().x, tile.getCenter().y, 450);
            } else if (towers.get(i).towerType == 2) {
              priceToPay = "-$25";
              noFill();
              stroke(255, 255, 255, 100);        
              circle(tile.getCenter().x, tile.getCenter().y, 300);
            } else if (towers.get(i).towerType == 3) {
              priceToPay = "-$30";
              noFill();
              stroke(255, 255, 255, 100);        
              circle(tile.getCenter().x, tile.getCenter().y, 500);
            }
          }  
          if (towers.get(i).upgradeTool == 4) {
            priceToPay = "MAX";
          }
        } else priceToPay = "";
      } else if (hasRemoveTool && tile != null && tile.isHovered) {
        if (tile.getCenter().x == towers.get(i).pixlP.x && tile.getCenter().y == towers.get(i).pixlP.y) {
          if (towers.get(i).towerType == 1) {
            priceToPay = "+$0";
          } else if (towers.get(i).towerType == 2) {
            priceToPay = "+$5";
          } else if (towers.get(i).towerType == 3) {
            priceToPay = "+$10";
          }
        } else priceToPay = "";
      } else priceToPay = "";
    }

    // Updates Bullets
    try {
      for (int i = bullets.size()-1; i >= 0; i--) {
        bullets.get(i).update();
        bullets.get(i).draw();
        for (int j = enemies.size()-1; j >= 0; j--) {
          if (detectCollision(bullets.get(i), enemies.get(j))) { 
            if (enemies.get(j).isFlying && bullets.get(i).canDamageFlying) {
              enemies.get(j).health -= 30;
              if (bullets.get(i).towerType == 2 && bullets.get(i).towerUpgrade == 4) {
                enemies.get(j).isSlowed = true;
                enemies.get(j).slowTimer = enemies.get(j).slowTimerReset;
              }
              bullets.remove(i);
            } else if (enemies.get(j).isFlying && !bullets.get(i).canDamageFlying) {
              return;
            } else if (!enemies.get(j).isFlying) {
              enemies.get(j).health -= 30;
              if (bullets.get(i).towerType == 2 && bullets.get(i).towerUpgrade == 4) {
                enemies.get(j).isSlowed = true;
                enemies.get(j).slowTimer = enemies.get(j).slowTimerReset;
              }
              bullets.remove(i);
            }
          }
        }
        if (bullets.get(i).isDead == true) bullets.remove(i);
      }
    } 
    catch (IndexOutOfBoundsException e) {
    }

    // On Left Click
    if (leftMouse && !prevMousePressed) {
      // Check if there is a tile
      if (tile != null) {
        // Check if tile has a tower, have a tower selected, don't have remove tool, and don't have upgrade tool
        if (!tile.hasATower && towerSelector != 0 && !hasRemoveTool && !hasUpgradeTool && tile.TERRAIN != 2 && tile.TERRAIN != 3 && tile.TERRAIN != 4 && tile.TERRAIN != 6) { 
          // Spawn towers based on towerSelector and if you have enough currency
          if (towerSelector == 1 && currency >= 5) {
            PVector tileLocation = tile.getCenter();
            ShooterTower t = new ShooterTower(tileLocation);
            towers.add(t);
            towerSelector = 0;
            currency -= 5;
            //priceToPay = "";
            tile.TERRAIN = 1;
            tile.hasATower = true;
          } else if (towerSelector == 2 && currency >= 10) {
            PVector tileLocation = tile.getCenter();
            AcidTower t = new AcidTower(tileLocation);
            towers.add(t);
            towerSelector = 0;
            currency -= 10;
            //priceToPay = "";
            tile.TERRAIN = 1;
            tile.hasATower = true;
          } else if (towerSelector == 3 && currency >= 15) {
            PVector tileLocation = tile.getCenter();
            SpaceshipTower t = new SpaceshipTower(tileLocation);
            towers.add(t);
            towerSelector = 0;
            currency -= 15;
            //priceToPay = "";
            tile.TERRAIN = 1;
            tile.hasATower = true;
          } else if (towerSelector == 4 && currency >=5) {
            PVector tileLocation = tile.getCenter();
            Wall w = new Wall(tileLocation);
            walls.add(w);
            currency -= 5;
            //priceToPay = "";
            tile.TERRAIN = 5;
            tile.hasATower = true;
          } else {
            towerSelector = 0;
            priceToPay = "";
          }
        } else if (hasRemoveTool) { // If you have the remove tool
          // for all towers
          for (int i = 0; i < towers.size(); i++) {
            // compare tile center to tower x and y              
            if (tile.getCenter().x == towers.get(i).pixlP.x && tile.getCenter().y == towers.get(i).pixlP.y) {    
              // delete if equal to each other 
              if (towers.get(i).towerType == 1) {
                currency += 0;
              } else if (towers.get(i).towerType == 2) {
                currency += 5;
              } else if (towers.get(i).towerType == 3) {
                currency += 10;
              }
              towers.remove(i);
              tile.TERRAIN = 0;
              hasRemoveTool = false;
            }
          }
          for (int i = 0; i < walls.size(); i++) {
            if (tile.getCenter().x == walls.get(i).pixlP.x && tile.getCenter().y == walls.get(i).pixlP.y) {
              //spawnSmokeEmitter(walls.get(i).pixlP.x, walls.get(i).pixlP.y);
              walls.remove(i);
              tile.TERRAIN = 0;
            }
          }
          if (!tile.hasATower) hasRemoveTool = false;
        } else if (hasUpgradeTool) { // If you have the upgrade tool
          // for all towers
          for (int i = 0; i < towers.size(); i++) {
            // compare tile center to tower x and y   
            if (tile.getCenter().x == towers.get(i).pixlP.x && tile.getCenter().y == towers.get(i).pixlP.y) {
              // upgarde if equal to each one
              if (towers.get(i).upgradeTool == 1) {
                if (towers.get(i).towerType == 1 && currency >= 10) {
                  currency -= 10;
                  towers.get(i).upgradeTool++;
                } else if (towers.get(i).towerType == 2 && currency >= 15) {
                  currency -= 15;
                  towers.get(i).upgradeTool++;
                } else if (towers.get(i).towerType == 3 && currency >= 20) {
                  currency -= 20;
                  towers.get(i).upgradeTool++;
                }
              } else if (towers.get(i).upgradeTool == 2 && currency >= 15) {
                if (towers.get(i).towerType == 1) {
                  currency -= 15;
                  towers.get(i).upgradeTool++;
                } else if (towers.get(i).towerType == 2 && currency >= 20) {
                  currency -= 20;
                  towers.get(i).upgradeTool++;
                } else if (towers.get(i).towerType == 3 && currency >= 25) {
                  currency -= 25;
                  towers.get(i).upgradeTool++;
                }
              } else if (towers.get(i).upgradeTool == 3) {
                if (towers.get(i).towerType == 1 && currency >= 20) {
                  currency -= 20;
                  towers.get(i).upgradeTool++;
                } else if (towers.get(i).towerType == 2 && currency >= 25) {
                  currency -= 25;
                  towers.get(i).upgradeTool++;
                } else if (towers.get(i).towerType == 3 && currency >= 30) {
                  currency -= 30;
                  towers.get(i).upgradeTool++;
                }
              } else if (towers.get(i).upgradeTool >= 4) {
                hasUpgradeTool = false;
              }
            }
          }
          if (!tile.hasATower) hasUpgradeTool = false;
        } else {
          towerSelector = 0;
        }

        // set target position for enemy on click
        for (int i = 0; i < enemies.size(); i++) {
          //enemies.get(i).setTargetPosition(TileHelper.pixelToGrid(new PVector(mouseX, mouseY - 150)));
        }
      }
    }

    // If nothing selected priceToPay is empty
    if (!hasUpgradeTool && !hasRemoveTool && towerSelector == 0) priceToPay = "";

    // On right click remove anything selected
    if (rightMouse && !prevMousePressed) {
      towerSelector = 0;
      hasUpgradeTool = false;
      hasRemoveTool = false;
    }

    // Draws Towers on Mouse Cursor if Selected
    if (towerSelector == 1) {
      if (tile != null) {
        noStroke();
        fill(255, 0, 0);
        image(tower1, tile.getCenter().x - 7.5, tile.getCenter().y - 7.5, 15, 15);
        noFill();
        stroke(255, 255, 255, 100);        
        circle(tile.getCenter().x, tile.getCenter().y, 300);
      } else {
        noStroke();
        fill(255, 0, 0);
        circle(mouseX, mouseY, 15);
      }
    } else if (towerSelector == 2) {
      if (tile != null) {
        noStroke();
        fill(0, 255, 0);
        image(tower2, tile.getCenter().x - 7.5, tile.getCenter().y - 7.5, 15, 15);
        noFill();
        stroke(255, 255, 255, 100);        
        circle(tile.getCenter().x, tile.getCenter().y, 175);
      } else {
        noStroke();
        fill(0, 255, 0);
        circle(mouseX, mouseY, 15);
      }
    } else if (towerSelector == 3) {
      if (tile != null) {
        noStroke();
        fill(0, 0, 255);
        image(spaceship, tile.getCenter().x - 7.5, tile.getCenter().y - 7.5, 15, 15);
        noFill();
        stroke(255, 255, 255, 100);        
        circle(tile.getCenter().x, tile.getCenter().y, 400);
      } else {
        noStroke();
        fill(0, 0, 255);
        circle(mouseX, mouseY, 15);
      }
    }

    // Animates currency shown on screen
    if (currencyAmount > currency) currencyAmount--;
    else if (currencyAmount < currency) currencyAmount++;
    else currencyAmount = currency;

    //    if (roundTimer <= 0) {
    //      startRound();
    //      roundTimer = 30;
    //    } else {
    //      roundTimer--;
    //    }
    updateParticles();
    drawParticles();
    fill(150, 28, 36);
    noStroke();
    rect(width/2, 74.5, width, 149);    
    strokeWeight(2);
    stroke(0);
    line(0, 149, width, 149);
    line(0, 74.5, width, 74.5);
    drawButtons();
    updateButtons();
    fill(255);
    textFont(moneyFont, 24);
    text("Wave " + wave, width/20, 120.5);
    textFont(moneyFont, 18);
    text("Remaining Enemies:  " + totalEnemiesSpawned, width/10.2, 15.5);
    text("Base Health: " + floor(baseHealth), 100, 140.5); 

    // Draw Text Near Mouse
    textFont(moneyFont, 54);
    text("$" + currencyAmount, width/8, 73.5);
    textFont(moneyFont, 24);
    text(priceToPay, mouseX + 20, mouseY - 20);
    textFont(font, 32);

    noFill();
    strokeWeight(2);
    stroke(0);
    polygon(m.x, m.y, 12, 6);    

    // NO DOUBLE CLICKING ALLOWED
    prevMousePressed = rightMouse;
    prevMousePressed = leftMouse;
  }

  void draw() {
  }

  boolean detectCollision(Bullet a, Enemies b) {
    float dx = b.pixlP.x - a.x; 
    float dy = b.pixlP.y - a.y; 
    float dis = sqrt(dx * dx + dy * dy);
    if (dis <=a.radius +b.radius) return true;  
    return false;
  }

  void spawnEnemies() {
    if (basicEnemiesToSpawn > 0 && spawnValue == 1) {
      Enemies e = new Enemies(TileHelper.pixelToGrid(TileHelper.gridToPixel(level.enemySpawn.X, level.enemySpawn.Y)), TileHelper.pixelToGrid(TileHelper.gridToPixel(level.enemyGoal.X, level.enemyGoal.Y)), 1);
      enemies.add(e);
      totalEnemiesToSpawn--;
      basicEnemiesToSpawn--;
      spawnTimer = int(random(lowSpawnValue, highSpawnValue));
      return;
    }
    if (fastEnemiesToSpawn > 0 && spawnValue == 2) {
      Enemies e = new Enemies(TileHelper.pixelToGrid(TileHelper.gridToPixel(level.enemySpawn.X, level.enemySpawn.Y)), TileHelper.pixelToGrid(TileHelper.gridToPixel(level.enemyGoal.X, level.enemyGoal.Y)), 2);
      enemies.add(e);
      totalEnemiesToSpawn--;
      fastEnemiesToSpawn--;
      spawnTimer = int(random(lowSpawnValue, highSpawnValue));
      return;
    }
    if (tankEnemiesToSpawn > 0 && spawnValue == 3) {
      Enemies e = new Enemies(TileHelper.pixelToGrid(TileHelper.gridToPixel(level.enemySpawn.X, level.enemySpawn.Y)), TileHelper.pixelToGrid(TileHelper.gridToPixel(level.enemyGoal.X, level.enemyGoal.Y)), 3);
      enemies.add(e);
      totalEnemiesToSpawn--;
      tankEnemiesToSpawn--;
      spawnTimer = int(random(lowSpawnValue, highSpawnValue));
      return;
    }
    if (flyingEnemiesToSpawn > 0 && spawnValue == 4) {
      Enemies e = new Enemies(TileHelper.pixelToGrid(TileHelper.gridToPixel(level.enemySpawn.X, level.enemySpawn.Y)), TileHelper.pixelToGrid(TileHelper.gridToPixel(level.enemyGoal.X, level.enemyGoal.Y)), 4);
      enemies.add(e);
      totalEnemiesToSpawn--;
      flyingEnemiesToSpawn--;
      spawnTimer = int(random(lowSpawnValue, highSpawnValue));
      return;
    }
    return;
  }

  void updateWaves() {    
    if (!isInWave) {
      waveTimer--;
      if (waveTimer <= 0) {
        isInWave = true;
        wave++;
      }
    }    
    if (isInWave) {
      if (!isSpawningEnemies) {
        if (wave == 1) {         
          // set the amount of enemies to spawn this wave
          lowSpawnValue = int(40 / mult);
          highSpawnValue = int(100/ mult);
          basicEnemiesToSpawn = 10;
          fastEnemiesToSpawn = 0;
          tankEnemiesToSpawn = 0;
          flyingEnemiesToSpawn = 0;
          totalEnemiesToSpawn = basicEnemiesToSpawn + fastEnemiesToSpawn + tankEnemiesToSpawn + flyingEnemiesToSpawn;
        } else if (wave == 2) {
          // set the amount of enemies to spawn this wave
          lowSpawnValue = int(40/ mult);
          highSpawnValue = int(95/ mult);
          basicEnemiesToSpawn = 20;
          fastEnemiesToSpawn = 0;
          tankEnemiesToSpawn = 0;
          flyingEnemiesToSpawn = 0;
          totalEnemiesToSpawn = basicEnemiesToSpawn + fastEnemiesToSpawn + tankEnemiesToSpawn + flyingEnemiesToSpawn;
        } else if (wave == 3) {
          // set the amount of enemies to spawn this wave
          lowSpawnValue = int(40/ mult);
          highSpawnValue = int(90/ mult);
          basicEnemiesToSpawn = 20;
          fastEnemiesToSpawn = 5;
          tankEnemiesToSpawn = 0;
          flyingEnemiesToSpawn = 0;
          totalEnemiesToSpawn = basicEnemiesToSpawn + fastEnemiesToSpawn + tankEnemiesToSpawn + flyingEnemiesToSpawn;
        } else if (wave == 4) {
          // set the amount of enemies to spawn this wave
          lowSpawnValue = int(40/ mult);
          highSpawnValue = int(85/ mult);
          basicEnemiesToSpawn = 20;
          fastEnemiesToSpawn = 10;
          tankEnemiesToSpawn = 0;
          flyingEnemiesToSpawn = 0;
          totalEnemiesToSpawn = basicEnemiesToSpawn + fastEnemiesToSpawn + tankEnemiesToSpawn + flyingEnemiesToSpawn;
          setButtonsToTrue();
          try {
            for (int k = buttons.size(); k >= 0; k--) {
              if (buttons.get(k).name == "Tower1" || buttons.get(k).name == "Tower2") {
                buttons.get(k).canBePressed = true;
              }
            }
          }
          catch(IndexOutOfBoundsException e) {
          }
        } else if (wave == 5) {
          // set the amount of enemies to spawn this wave
          lowSpawnValue = int(35/ mult);
          highSpawnValue = int(80/ mult);
          basicEnemiesToSpawn = 20;
          fastEnemiesToSpawn = 10;
          tankEnemiesToSpawn = 10;
          flyingEnemiesToSpawn = 5;
          totalEnemiesToSpawn = basicEnemiesToSpawn + fastEnemiesToSpawn + tankEnemiesToSpawn + flyingEnemiesToSpawn;
        } else if (wave == 6) {
          // set the amount of enemies to spawn this wave
          lowSpawnValue = int(30/ mult);
          highSpawnValue = int(75/ mult);
          basicEnemiesToSpawn = 25;
          fastEnemiesToSpawn = 15;
          tankEnemiesToSpawn = 10;
          flyingEnemiesToSpawn = 10;
          totalEnemiesToSpawn = basicEnemiesToSpawn + fastEnemiesToSpawn + tankEnemiesToSpawn + flyingEnemiesToSpawn;
        } else if (wave == 7) {
          // set the amount of enemies to spawn this wave
          lowSpawnValue = int(25/ mult);
          highSpawnValue = int(70/ mult);
          basicEnemiesToSpawn = 15;
          fastEnemiesToSpawn = 40;
          tankEnemiesToSpawn = 5;
          flyingEnemiesToSpawn = 5;
          totalEnemiesToSpawn = basicEnemiesToSpawn + fastEnemiesToSpawn + tankEnemiesToSpawn + flyingEnemiesToSpawn;
        } else if (wave == 8) {
          // set the amount of enemies to spawn this wave
          lowSpawnValue = int(15/ mult);
          highSpawnValue = int(60/ mult);
          basicEnemiesToSpawn = 15;
          fastEnemiesToSpawn = 15;
          tankEnemiesToSpawn = 30;
          flyingEnemiesToSpawn = 5;
          totalEnemiesToSpawn = basicEnemiesToSpawn + fastEnemiesToSpawn + tankEnemiesToSpawn + flyingEnemiesToSpawn;
        } else if (wave == 9) {
          // set the amount of enemies to spawn this wave
          lowSpawnValue = int(5/ mult);
          highSpawnValue = int(40/ mult);
          basicEnemiesToSpawn = 15;
          fastEnemiesToSpawn = 15;
          tankEnemiesToSpawn = 10;
          flyingEnemiesToSpawn = 40;
          totalEnemiesToSpawn = basicEnemiesToSpawn + fastEnemiesToSpawn + tankEnemiesToSpawn + flyingEnemiesToSpawn;
        } else if (wave == 10) {
          // set the amount of enemies to spawn this wave
          lowSpawnValue = int(2/ mult);
          highSpawnValue = int(20/ mult);
          basicEnemiesToSpawn = 30;
          fastEnemiesToSpawn = 40;
          tankEnemiesToSpawn = 20;
          flyingEnemiesToSpawn = 40;
          totalEnemiesToSpawn = basicEnemiesToSpawn + fastEnemiesToSpawn + tankEnemiesToSpawn + flyingEnemiesToSpawn;
        } else if (wave == 11) {//EXIT THE GAME
          fuckThoseButtons();
          fuckThoseParticles();
          switchToWin();
        }
        totalEnemiesSpawned = totalEnemiesToSpawn;
        isSpawningEnemies = true;
      } else if (isSpawningEnemies && totalEnemiesToSpawn > 0) {
        spawnValue = int(random(0, 5));
        if (spawnTimer <= 0) {

          spawnEnemies();
        }
        spawnTimer--;
      }
      if (enemies.size() <= 0 && totalEnemiesToSpawn <= 0 && isSpawningEnemies) {
        isSpawningEnemies = false;
        isInWave = false;
        waveTimer = int(500 / mult);
      }
    }
  }

  void spawnSmokeEmitter(float x, float y) {
    Emitter e = new Emitter(x, y, "smonk", 3, 32);
    emitters.add(e);
  }

  void updateEmitters() {
    for (int i = 0; i < emitters.size(); i++) {
      emitters.get(i).update();
      if (emitters.get(i).isDead) emitters.remove(i);
    }
  }
}
