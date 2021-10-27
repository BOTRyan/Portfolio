
class Pathfinder {

  boolean useManhattan = false;
  boolean useDiagonals = false;
  ArrayList<Tile> open = new ArrayList<Tile>(); // collection of tiles we can use to solve the algorithm
  ArrayList<Tile> closed = new ArrayList<Tile>(); // collection of tiles that we've already checked and should not check again

  Pathfinder() {
  }

  ArrayList<Tile> findPath(Tile start, Tile end) {
    open.clear(); // empty array
    closed.clear(); // empty array

    // TODO: starting tile's "parent" property should be null
    start.resetParent();

    // STEP 1: CONNECT START TO END
    connectStartToEnd(start, end);

    // STEP 2: BUILD PATH BACK TO BEGINNING
    ArrayList<Tile> path = new ArrayList<Tile>();
    Tile pathNode = end;
    while (pathNode != null) {
      path.add(pathNode);
      pathNode = pathNode.parent;
    }

    // STEP 3: REVERSE THE PATH (FOR CONVENIENCE)
    ArrayList<Tile> rev = new ArrayList<Tile>();
    int maxIndex = path.size() - 1;
    for (int i = maxIndex; i >= 0; i--) {
      rev.add(path.get(i));
    }

    return rev;
  }

  // CONNECT THE START TO THE END
  void connectStartToEnd(Tile start, Tile end) {

    open.add(start); // ADD start TILE TO open ARRAY

    // WHILE WE STILL HAVE TILES IN THE OPEN ARRAY
    while (open.size () > 0) {

      // FIND THE OPEN TILE WITH THE LOWEST F VALUE
      float F = 9999;
      int index = -1;

      for (int i = 0; i < open.size(); i++) {
        Tile temp = open.get(i);
        if (temp.F < F) {
          F = temp.F;
          index = i;
        }
      }

      // REMOVE THE TILE FROM THE OPEN ARRAY
      Tile current = open.remove(index);

      // ADD THE TILE FROM THE CLOSED ARRAY
      closed.add(current);

      // IF WE'VE CONNECTED THE START TO THE END, BREAK OUT OF WHILE, RETURN OUT OF FUNCTION
      if (current == end) {
        // Path was found!
        break;
      }

      // LOOP THROUGH ALL OF current's NEIGHBORS
      for (int i = 0; i < current.neighbors.size(); i++) {
        Tile neighbor = current.neighbors.get(i);
        //// IF THE NEIGHBOR ISN'T IN CLOSED ARRAY:
        if (!tileInArray(closed, neighbor)) {
          //// IF THE NEIGHBOR ISN'T IN OPEN ARRAY:
          if (!tileInArray(open, neighbor)) {
            ////// ADD IT TO THE OPEN ARRAY
            open.add(neighbor);
            ////// SET IT'S PARENT
            neighbor.setParent(current);
            ////// CALCULATE IT'S H VALUE
            neighbor.toggleHeuristics(end, useManhattan);
          } else {      //// ELSE
            ////// IF IT WOULD BE CHEAPER TO MOVE TO THAT TILE FROM current
            if (neighbor.G > current.G + neighbor.getTerrainCost()) {
              //////// SET IT'S PARENT TO current
              neighbor.setParent(current);
              //////// RECALCULATE IT'S H VALUE
              neighbor.toggleHeuristics(end, useManhattan);
            } // end if
          } //end else for !tileInArray
        } // end if
      } // end for loop
    } // end while loop
  } // end method

  // returns true if the specified tile is contained
  // within the specified ArrayList
  boolean tileInArray(ArrayList<Tile> a, Tile t) {
    // TODO: implement the method
    for (int i = 0; i < a.size(); i++) {
      if (a.get(i) == t) return true;
    }
    return false;
  }

  // toggle the heuristic that we're using
  void toggleHeuristic() {
    useManhattan = !useManhattan;
  }
}
