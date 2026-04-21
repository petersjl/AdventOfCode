import '../dart_utils.dart' show Point;
import '../data_structures.dart' show Queue;
import '../data_structures/grid_base.dart';

/// Performs a breadth first search on the grid from the start point to find the shortest distance to each of the target points.
/// Returns a map of each target point to its distance from the start point. If a target is unreachable, it will not be included in the result.
Map<Point, int> bfs(GridBase<bool> grid, Point start, Set<Point> targets) {
  var result = <Point, int>{};
  var remaining = {...targets}..remove(start);
  if (remaining.isEmpty) {
    return result;
  }

  var visited = <Point>{start};
  var queue = Queue<Point>();
  var distances = <Point, int>{start: 0};
  queue.push(start);

  while (!queue.isEmpty && remaining.isNotEmpty) {
    var current = queue.pop();

    if (remaining.remove(current)) {
      result[current] = distances[current]!;
    }

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

      visited.add(neighbor);
      distances[neighbor] = distances[current]! + 1;
      queue.push(neighbor);
    }
  }

  return result;
}

/// Performs a breadth first search on the grid from each point in the targets set to find the shortest distance between each pair of target points.
/// Returns a map of each target point to a map of other target points and their distance from the key point. If a pair of targets are unreachable from each other, they will not be included in the result.
Map<Point, Map<Point, int>> bfsAllPairs(
  GridBase<bool> grid,
  Set<Point> targets,
) {
  var result = <Point, Map<Point, int>>{};
  final targetList = targets.toList();
  // Shorten the target list each loop since BFS results are symmetric and we don't need to repeat pairs.
  for (var i = 0; i < targetList.length; i++) {
    final start = targetList[i];
    final remainingTargets = targetList.sublist(i + 1).toSet();
    if (remainingTargets.isEmpty) {
      result[start] ??= {};
      continue;
    }

    var distances = bfs(grid, start, remainingTargets);
    result[start] ??= {};
    // Store both directions since the graph is undirected.
    // i.e. a -> b and b -> a
    for (var entry in distances.entries) {
      var destination = entry.key;
      var distance = entry.value;
      result[start]![destination] = distance;
      result[destination] ??= {};
      result[destination]![start] = distance;
    }
  }
  return result;
}
