// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day06.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = (Point, List<List<int>>);

class MapItem {
  static int NONE = 0, BARREL = 1, GUARD = 2, NEWOBS = 3;
  static int get(String item) {
    switch (item) {
      case ('#'):
        return BARREL;
      case ('^'):
        return GUARD;
      default:
        return NONE;
    }
  }
}

InputType parseInput(String input) {
  var strGrid = input.splitNewLine();
  Point? guard = null;
  var grid = List<List<int>>.generate(
    strGrid.length,
    (i) => List<int>.generate(strGrid[0].length, (j) => 0),
  );
  for (int row = 0; row < strGrid.length; row++) {
    for (int col = 0; col < strGrid[0].length; col++) {
      if (strGrid[row][col] == '^') guard = new Point(col, row);
      grid[row][col] = MapItem.get(strGrid[row][col]);
    }
  }
  if (guard == null) throw Exception("No guard found while parsing");
  return (guard, grid); // should never get here
}

Point rotateClockwise(Point p) {
  return new Point(p.y * -1, p.x);
}

bool doesHeStay(
  Point guard,
  Point dir,
  List<List<int>> grid, {
  Set<Pair<Point, Point>>? path = null,
}) {
  path = path ?? {};
  while (true) {
    var newPos = guard + dir;
    if (newPos.y < 0 ||
        grid.length <= newPos.y ||
        newPos.x < 0 ||
        grid[0].length <= newPos.x)
      return false;
    if (grid[newPos.y][newPos.x] % 2 == 1) {
      dir = rotateClockwise(dir);
      continue;
    }
    if (!path.add(Pair(newPos, dir))) return true;
    guard = newPos;
  }
}

String solvePart1(InputType input) {
  var (guard, grid) = input;
  var dir = new Point(0, -1);
  Set<Pair<Point, Point>> path = {Pair(guard, dir)};
  doesHeStay(guard, dir, grid, path: path);
  int count = path
      .fold(Set<Point>(), (run, element) => run..add(element.first))
      .length;
  return count.toString();
}

String solvePart2(InputType input) {
  var (guard, grid) = input;
  var initDir = new Point(0, -1);
  int count = 0;
  Set<Pair<Point, Point>> path = {Pair(guard, initDir)};
  doesHeStay(guard, initDir, grid, path: path);
  Set<Point> possibilities = {};
  path.forEach((spot) => possibilities.add(spot.first));
  for (var pos in possibilities) {
    if (grid[pos.y][pos.x] != MapItem.NONE) continue;

    grid[pos.y][pos.x] = MapItem.NEWOBS;
    if (doesHeStay(guard, initDir, grid)) count++;
    grid[pos.y][pos.x] = MapItem.NONE;
  }
  return count.toString();
}
