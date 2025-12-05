import 'package:utils/DartUtils.dart';

List<Point> checkSurroundingPoints<T>(
  List<List<T>> grid,
  Point p,
  bool Function(T) condition,
) {
  var points = <Point>[];
  for (var dx = -1; dx <= 1; dx++) {
    for (var dy = -1; dy <= 1; dy++) {
      if (dx == 0 && dy == 0) continue;
      var newX = p.x + dx;
      var newY = p.y + dy;
      if (newX >= 0 &&
          newX < grid[0].length &&
          newY >= 0 &&
          newY < grid.length &&
          condition(grid[newY][newX])) {
        points.add(Point(newX, newY));
      }
    }
  }
  return points;
}
