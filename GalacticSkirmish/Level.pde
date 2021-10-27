class Level {

  int[][] level;
  Tile[][] tiles;
  boolean useDiagonals = false;

  Tile enemySpawn;
  Tile enemyGoal;

  Level() {
    if (levelToLoad == 1) {
      loadLevel(LevelDefs.LEVEL1);
      mult = 1;
    } else if (levelToLoad == 2) {
      loadLevel(LevelDefs.LEVEL2);
      mult = 1;
    } else if (levelToLoad == 3) {
      loadLevel(LevelDefs.LEVEL3);
      mult = 1;
    } else if (levelToLoad == 4) {
      loadLevel(LevelDefs.LEVEL4);
      mult = 1.3;
    } else {
      loadLevel(LevelDefs.LEVEL5);
      mult = 1.8;
    }
  }

  void draw() {
    noStroke();
    for (int Y = 0; Y < tiles.length; Y++) {
      for (int X = 0; X < tiles[Y].length; X++) {
        tiles[Y][X].draw();
        if (tiles[Y][X].TERRAIN == 3) enemyGoal = tiles[Y][X];
        if (tiles[Y][X].TERRAIN == 6) enemySpawn = tiles[Y][X];
      }
    }

    fill(0);
  }

  // return the tile at grid position (X, Y)
  Tile getTile(int X, int Y) {
    // TODO: implement method. check for potential run-time errors.
    if (X < 0 || Y < 0) return null;
    if (Y >= tiles.length || X >= tiles[0].length) return null;
    return tiles[Y][X];
  }

  // convenience method
  Tile getTile(Point p) {
    return getTile(p.x, p.y);
  }

  // return the pixel coordinates of the center
  // of the tile at specified grid position
  PVector getTileCenterAt(Point p) {
    // TODO: implement method. check for potential run-time errors.
    Tile tile = getTile(p);
    if (tile == null) return new PVector();
    return tile.getCenter();
  } 

  // returns true if the tile at the specified
  // grid position is passable
  boolean isPassable(Point p) {
    // TODO: implement method. check for potential run-time errors.
    Tile tile = getTile(p);
    if (tile == null) return false;
    return tile.isPassable();
  }

  // reload the level. useful for re-establishing
  // neighbor relationships between the tiles
  void reloadLevel() {
    loadLevel(level);
  }

  void loadLevel(int[][] layout) {

    level = layout; // cache the layout (to enable reloading levels)

    // build our multidimensional array of tiles:
    int ROWS = layout.length;
    int COLS = layout[0].length;
    tiles = new Tile[ROWS][COLS];
    for (int Y = 0; Y < ROWS; Y++) {
      for (int X = 0; X < COLS; X++) {
        Tile tile = new Tile(X, Y);
        tile.TERRAIN = layout[Y][X];
        tiles[Y][X] = tile;
      }
    }
    // TODO: set each tile's neighboring nodes
    for (int Y = 0; Y < ROWS; Y++) {
      for (int X = 0; X < COLS; X++) {
        if (TileHelper.isHex) {
          if (X % 2 == 0) {
            tiles[Y][X].addNeighbors(new Tile[] {
              getTile(X - 1, Y), 
              getTile(X - 1, Y + 1), 
              getTile(X, Y - 1), 
              getTile(X, Y + 1), 
              getTile(X + 1, Y), 
              getTile(X + 1, Y + 1)
              });
          } else {
            tiles[Y][X].addNeighbors(new Tile[] {
              getTile(X - 1, Y - 1), 
              getTile(X - 1, Y), 
              getTile(X, Y - 1), 
              getTile(X, Y + 1), 
              getTile(X + 1, Y - 1), 
              getTile(X + 1, Y)
              });
          }
        } else {
          tiles[Y][X].addNeighbors(new Tile[] {
            getTile(X - 1, Y), 
            getTile(X + 1, Y), 
            getTile(X, Y - 1), 
            getTile(X, Y + 1), 
            });
          if (useDiagonals) {
            tiles[Y][X].addNeighbors(new Tile[] {
              getTile(X - 1, Y - 1), 
              getTile(X + 1, Y + 1), 
              getTile(X + 1, Y - 1), 
              getTile(X - 1, Y + 1), 
              });
          } //end if diagonals
        } //end else for isHex
      } //end X for loop
    } //end Y for loop
  } //end loadLevel()

  // toggle the use of diagonals
  void toggleDiagonals() {
    useDiagonals = !useDiagonals;
    reloadLevel();
  }
}
