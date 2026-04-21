import 'package:utils/data_structures.dart';
import 'package:utils/data_structures/grid_base.dart';

import '../dart_utils.dart' show Point;

List<Point>? aStar(
  GridBase<bool> grid,
  Point start,
  Point goal,
  int Function(Point) heuristic,
) {
  var visited = <Point>{};
  var pathLength = <Point, int>{start: 0};
  var previous = <Point, Point?>{start: null};
  var heuristicCache = <Point, int>{start: heuristic(start)};
  var expectedCost = <Point, int>{start: heuristicCache[start]!};
  var queue = PriorityQueue((Point a, Point b) {
    return expectedCost[a]!.compareTo(expectedCost[b]!);
  });
  queue.enqueue(start);

  while (!queue.isEmpty) {
    var current = queue.dequeue();

    if (current == goal) {
      var reversed = <Point>[];
      Point? step = current;
      while (step != null) {
        reversed.add(step);
        step = previous[step];
      }
      return reversed.reversed.toList();
    }

    visited.add(current);

    for (var direction in Point.cardinals) {
      var neighbor = current + direction;
      late bool isWall;
      try {
        isWall = grid.get(neighbor.x, neighbor.y);
      } catch (e) {
        continue; // Out of bounds
      }
      if (isWall || visited.contains(neighbor)) {
        continue;
      }

      var newPathLength = pathLength[current]! + 1;

      if (queue.contains(neighbor) && newPathLength >= pathLength[neighbor]!) {
        continue;
      }

      pathLength[neighbor] = newPathLength;
      previous[neighbor] = current;
      heuristicCache[neighbor] ??= heuristic(neighbor);
      expectedCost[neighbor] = newPathLength + heuristicCache[neighbor]!;
      queue.enqueue(neighbor);
    }
  }
  return null; // No solution found
}
