static class TileHelper {

  static GalacticSkirmish app;
  static boolean isHex = true;
  final static int W = 20;
  final static int H = 20;
  final static int halfW = W / 2;
  final static int halfH = H / 2;

  //PImage img;  


  // converts from grid coordinates to pixel coordinates
  static PVector gridToPixel(Point p) {
    // TODO: implement
    return gridToPixel(p.x, p.y);
  }

  static PVector gridToPixel(int X, int Y) {
    PVector v = new PVector(X * W, Y * H);
    if (isHex && X % 2 == 0)v.y += 10;
    return v;
  }

  // converts from pixel coordinates to grid coordinates
  static Point pixelToGrid(PVector p) {
    // TODO: implement
    int x = (int)(p.x / W);
    if (isHex && x % 2 == 0) p.y -= halfH;
    int y = (int)(p.y / H);
    return app.new Point(x, y);
  }
}

class Tile {

  int X;
  int Y;
  int TERRAIN = 0;
  boolean isHovered = false;
  boolean hasATower = false;


  Tile(int X, int Y) {
    this.X = X;
    this.Y = Y;
  }

  void draw() {
    // TODO: draw rectangle
    //Fills Color of Shape Based on Terrain Type
    pushMatrix();
    stroke(0);
    strokeWeight(1.5);
    if (TERRAIN == 0) {
      if (TileHelper.isHex) fill(198, 123, 92);
      else return;
    }
    if (TERRAIN == 2) {
      PVector p = getCenter(); 
      if (hasATower == false) {
        image(rock, p.x - 10, p.y - 10, 20, 20);
      }
    }

    if ( TERRAIN == 3) {
      PVector p = getCenter();
      image(homeBase, p.x - 25, p.y - 25, 45, 45);
    }
    if (TERRAIN == 5) {
    }
    if (TERRAIN == 6) {
      PVector p = getCenter();
      image(enemyBase, p.x - 25, p.y - 25, 45, 45);
      noFill();
      stroke(255, 255, 255, 100);        
      circle(getCenter().x, getCenter().y, 300);
    }
    //if (isHovered) fill(255, 255, 0);

    //Draw Circles
    if (TileHelper.isHex) {
      PVector p = getCenter();
      //ellipse(p.x, p.y, TileHelper.W, TileHelper.H);
      noStroke();
      //fill(255);
      //polygon(p.x, p.y, (TileHelper.W/2), 6);
    } else {//Draw Rectangles
      PVector p = TileHelper.gridToPixel(X, Y);
      rect(p.x, p.y, TileHelper.W, TileHelper.H);
    }
    popMatrix();

    isHovered = false;
  }

  // returns the center of the tile in pixel coordinates
  PVector getCenter() {
    // TODO: implement method
    PVector p = TileHelper.gridToPixel(new Point(X, Y));
    p.x += TileHelper.halfW;
    p.y += TileHelper.halfH + 150;
    return p;
  }

  Boolean isDestructable() {
    return (TERRAIN != 5);
  }

  Boolean isPassable() {
    if (TERRAIN == 2) return false;
    else if (TERRAIN == 5) return false;
    else return true;
  }

  ///////////////////////////////////////////////////
  /////////////// PATHFINDING STUFF: ////////////////
  ///////////////////////////////////////////////////

  // TODO: add pathfinding properties
  ArrayList<Tile> neighbors = new ArrayList<Tile>(); // LIST OF NEIGHBORING TILES
  Tile parent; // PARENT TILE (previous tile in the path)
  float G; // COST TO TRAVEL TO TILE
  float F; // TOTAL COST OF THIS TILE

  // TODO: add pathfinding methods
  // ADD THE SUPPLIED TILES TO THIS TILE'S LIST OF NEIGHBORS
  void addNeighbors(Tile[] tiles) {
    for (Tile t : tiles) {
      if ( t != null) neighbors.add(t);
    }
  }

  // SET PARENT OF THIS TILE
  // This is used during path finding to remember where the path originated
  void setParent(Tile n) {
    parent = n;
    G = parent.G + getTerrainCost();
  }

  // RESET THE PARENT OF THIS TILE
  // This is used when starting pathfinding. When reversing back through the path, we know we've arrived once we reach a tile without a parent tile
  void resetParent() {
    parent = null;
    G = 0;
    F = 0;
  }

  // RETURN THE COST OF MOVING INTO THIS TILE
  // This is used during pathfinding to find the cost of the tile it's moving to
  float getTerrainCost() {
    if (TERRAIN >= 0 && TERRAIN < LevelDefs.moveCost.length) return LevelDefs.moveCost[TERRAIN];
    return 0;
  }

  // MANHATTAN HEURISTIC CALCULATION
  float distanceManhattan(Tile n) {
    return abs(n.X -X) + abs(n.Y - Y);
  }

  // EUCLIDEAN HEURISTIC CALCULATION
  float distanceEuclidean(Tile n) {
    if (n != null) {
      float dx = n.X - X;
      float dy = n.Y - Y;
      return sqrt(dx * dx + dy * dy);
    } else return 0;
  }

  // TOGGLE HEURISTIC USED
  void toggleHeuristics(Tile n, boolean useManhattan) {
    if (useManhattan) F = G + distanceManhattan(n);
    if (!useManhattan) F = G + distanceEuclidean(n);
  }
}
