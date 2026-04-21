// ignore_for_file: dead_code

import 'package:utils/algorithms.dart';
import 'package:utils/dart_utils.dart';
import 'package:utils/data_structures.dart';
import 'package:utils/data_structures/grid_base.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day13.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = int;

InputType parseInput(String input) {
  return int.parse(input);
}

String solvePart1(InputType input, [int targetX = 31, int targetY = 39]) {
  var grid = GrowableGrid(
    (x, y) => isWall(x, y, input),
    0,
    targetX,
    0,
    targetY,
    false,
  );
  var path = aStar(
    grid,
    Point(1, 1),
    Point(targetX, targetY),
    (p) => Utils.ManhattanDist(p, Point(targetX, targetY)),
  );
  if (path == null) {
    throw Exception("No path found to target");
  }
  return (path.length - 1).toString();
}

String solvePart2(InputType input) {
  return flood(
    GrowableGrid((x, y) => isWall(x, y, input), 0, 1, 0, 1, false),
    Point(1, 1),
    50,
  ).toString();
}

bool isWall(int x, int y, int input) {
  var value = (x * x) + (3 * x) + (2 * x * y) + y + (y * y) + input;
  var countOnes = intCountOnes(value);
  return countOnes.isOdd;
}

int intCountOnes(int n) {
  var count = 0;
  while (n != 0) {
    n &= (n - 1); // clears lowest set bit
    count++;
  }
  return count;
}

int flood(GridBase<bool> grid, Point start, int maxSteps) {
  var distance = <Point, int>{};
  var toVisit = Queue<Point>();
  toVisit.push(start);
  distance[start] = 0;

  while (!toVisit.isEmpty) {
    var current = toVisit.pop();
    var currentDist = distance[current]!;

    for (var direction in Point.cardinals) {
      var neighbor = current + direction;
      if (distance.containsKey(neighbor)) continue;

      bool isWall;
      try {
        isWall = grid.get(neighbor.x, neighbor.y);
      } catch (e) {
        continue;
      }

      if (!isWall) {
        var neighborDist = currentDist + 1;
        distance[neighbor] = neighborDist;
        if (neighborDist <= maxSteps) {
          toVisit.push(neighbor);
        }
      }
    }
  }
  return distance.values.where((d) => d > 0).length;
}
