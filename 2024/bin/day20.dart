// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day20.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = (List<List<int>>, Point, Point);

InputType parseInput(String input) {
  Point? start, end = null;
  var lines = input.splitNewLine();
  List<List<int>> map = Utils.getGrid(0, lines.length, lines[0].length);
  for (int row = 0; row < lines.length; row++) {
    for (int col = 0; col < lines[0].length; col++) {
      switch (lines[row][col]) {
        case '.':
          continue;
        case 'S':
          start = Point(col, row);
        case 'E':
          end = Point(col, row);
        default:
          map[row][col] = -1;
      }
    }
  }
  if (start == null) throw Exception("Start pos not found");
  if (end == null) throw Exception("End pos not found");
  return (map, start, end);
}

class PathNode {
  Point pos, direction;
  int score;
  PathNode? prev;
  PathNode(this.pos, this.direction, this.score, [this.prev]);
}

Point getStartDirection(List<List<int>> map, Point start) {
  Point farCorner = Point(map[0].length, map.length);
  for (var dir in Point.cardinals) {
    var check = start + dir;
    if (check.isInBounds(farCorner) && map[check.y][check.x] > -1) return dir;
  }
  throw Exception("Start pos is surrounded by walls");
}

PathNode populatePath(
  List<List<int>> map,
  Point start,
  Point startDir,
  Point end,
) {
  PathNode currentNode = PathNode(start, startDir, 0);
  Point currentPos = start;
  Point currentDir = startDir;
  int seconds = 0;
  while (currentPos != end) {
    seconds++;
    var forward = currentPos + currentDir;
    var left = currentPos + currentDir.rotateCounterClockwise();
    var right = currentPos + currentDir.rotateClockwise();
    if (map[forward.y][forward.x] > -1) {
      currentPos = forward;
    } else if (map[left.y][left.x] > -1) {
      currentPos = left;
      currentDir = currentDir.rotateCounterClockwise();
    } else if (map[right.y][right.x] > -1) {
      currentPos = right;
      currentDir = currentDir.rotateClockwise();
    } else
      throw Exception("Ran into dead end at $currentPos going $currentDir");
    map[currentPos.y][currentPos.x] = seconds;
    currentNode = PathNode(currentPos, currentDir, seconds, currentNode);
  }
  return currentNode;
}

Map<int, int> findCheats(List<List<int>> map, PathNode end) {
  Map<int, int> cheatCounts = {};
  Point farCorner = Point(map[0].length, map.length);
  PathNode? currentNode = end;
  do {
    currentNode = currentNode!; // Stop nullability checks
    List<Point> jumps = [
      currentNode.pos + currentNode.direction * 2,
      currentNode.pos + currentNode.direction.rotateClockwise() * 2,
      currentNode.pos + currentNode.direction.rotateCounterClockwise() * 2,
    ];
    for (var jump in jumps) {
      if (jump.isInBounds(farCorner) && map[jump.y][jump.x] > -1) {
        var score =
            map[currentNode.pos.y][currentNode.pos.x] -
            map[jump.y][jump.x] -
            2; // subtract 2 extra for the time to run the cheat
        if (score > 0) {
          cheatCounts.increment(score);
        }
      }
    }
    currentNode = currentNode.prev;
  } while (currentNode != null);
  return cheatCounts;
}

String solvePart1(InputType input, [int minTimeSave = 100]) {
  var (map, start, end) = input;
  var dir = getStartDirection(map, start);
  var pathEnd = populatePath(map, start, dir, end);
  var cheatCounts = findCheats(map, pathEnd);
  var cheatsOverLimit = 0;
  for (var key in cheatCounts.keys) {
    if (key >= minTimeSave) cheatsOverLimit += cheatCounts[key]!;
  }
  return cheatsOverLimit.toString();
}

Map<int, int> findBigCheats(PathNode end) {
  Map<int, int> cheats = {};
  PathNode? lead = end.prev;
  while (lead != null) {
    PathNode follow = end;
    while (follow.pos != lead.pos) {
      var distCheck = Utils.ManhattanDist(lead.pos, follow.pos);
      if (distCheck < 21) {
        var scoreCheck = follow.score - lead.score - distCheck;
        if (scoreCheck > 0) cheats.increment(scoreCheck);
      }
      follow = follow.prev!;
    }
    lead = lead.prev;
  }
  return cheats;
}

String solvePart2(InputType input, [int minTimeSave = 100]) {
  var (map, start, end) = input;
  var dir = getStartDirection(map, start);
  var pathEnd = populatePath(map, start, dir, end);
  var cheatCounts = findBigCheats(pathEnd);
  var cheatsOverLimit = 0;
  for (var key in cheatCounts.keys) {
    if (key >= minTimeSave) cheatsOverLimit += cheatCounts[key]!;
  }
  return cheatsOverLimit.toString();
}
