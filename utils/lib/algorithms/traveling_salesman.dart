({List<T> path, int totalDistance}) travelingSalesman<T>(
  Map<T, Map<T, int>> distances,
  T start, {
  bool returnToStart = false,
}) {
  var bestDistance = 1 << 62;
  var bestPath = <T>[];

  void visit(
    T current,
    Set<T> remaining,
    List<T> pathSoFar,
    int distanceSoFar,
  ) {
    if (remaining.isEmpty) {
      final totalDistance = returnToStart && current != start
          ? distanceSoFar + distances[current]![start]!
          : distanceSoFar;
      if (totalDistance < bestDistance) {
        bestDistance = totalDistance;
        bestPath = returnToStart && current != start
            ? [...pathSoFar, start]
            : [...pathSoFar];
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
  return (path: bestPath, totalDistance: bestDistance);
}
