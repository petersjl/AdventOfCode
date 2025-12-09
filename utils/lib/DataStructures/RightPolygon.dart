import 'package:utils/DartUtils.dart';

class RightPolygon {
  List<Point> points;
  int maxX = 0;
  int maxY = 0;
  RightPolygon(List<Point> points) : this.points = List.unmodifiable(points) {
    for (final p in points) {
      if (p.x > maxX) maxX = p.x;
      if (p.y > maxY) maxY = p.y;
    }
  }

  Iterable<(Point, Point)> edges() sync* {
    for (int i = 0; i < points.length; i++) {
      final a = points[i];
      final b = points[(i + 1) % points.length];
      yield (a, b);
    }
  }

  bool isInside(Point p) {
    var inside = false;
    for (var (a, b) in edges()) {
      if (((a.y > p.y) != (b.y > p.y)) &&
          (p.x < (b.x - a.x) * (p.y - a.y) / (b.y - a.y) + a.x)) {
        inside = !inside;
      }
    }
    return inside;
  }
}
