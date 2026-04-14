import '../dart_utils.dart' show Point;

({List<Point> path, int totalDistance}) travelingSalesman(
  Map<Point, Map<Point, int>> distances,
  Point start, {
  bool returnToStart = false,
}) {
  var bestDistance = 1 << 62;
  var bestPath = <Point>[];

  void visit(
    Point current,
    Set<Point> remaining,
    List<Point> pathSoFar,
    int distanceSoFar,
  ) {
    if (remaining.isEmpty) {
      if (distanceSoFar < bestDistance) {
        bestDistance = distanceSoFar;
        bestPath = [...pathSoFar];
      }
      return;
    }

    for (var next in remaining) {
      final nextDistance = distances[current]![next]!;
      if (distanceSoFar + nextDistance >= bestDistance) {
        continue; // Prune paths that are already too long
      }
      visit(next, {...remaining}..remove(next), [
        ...pathSoFar,
        next,
      ], distanceSoFar + nextDistance);
    }
  }

  visit(start, distances.keys.toSet()..remove(start), [start], 0);
  if (returnToStart && bestPath.isNotEmpty && bestPath.last != start) {
    final returnDistance = distances[bestPath.last]![start]!;
    bestDistance += returnDistance;
    bestPath.add(start);
  }
  return (path: bestPath, totalDistance: bestDistance);
}
