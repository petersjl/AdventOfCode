import 'package:utils/DartUtils.dart';
import 'package:utils/DataStructures/AxisLine.dart';

class RightPolygon {
  List<Point> points;
  List<AxisLine> _lines;
  int maxX = 0;
  int maxY = 0;

  RightPolygon(List<Point> points)
    : this.points = List.unmodifiable(points),
      _lines = [] {
    for (int i = 0; i < points.length; i++) {
      final a = points[i];
      final b = points[(i + 1) % points.length];
      if (a.x > maxX) maxX = a.x;
      if (a.y > maxY) maxY = a.y;
      _lines.add(AxisLine(a, b));
    }
    for (final p in points) {
      if (p.x > maxX) maxX = p.x;
      if (p.y > maxY) maxY = p.y;
    }
  }

  List<AxisLine> edges() {
    return List.unmodifiable(_lines);
  }

  bool containsPoint(Point p) {
    var ray = AxisLine(Point(p.x, maxY + 1), p);
    var collisions = 0;
    for (var line in edges()) {
      if (ray.crosses(line)) collisions++;
    }
    return collisions % 2 == 1;
  }

  bool contains(RightPolygon other) {
    for (var point in other.points) {
      if (!containsPoint(point)) return false;
    }
    for (var myEdge in this.edges()) {
      for (var theirEdge in other.edges()) {
        if (myEdge.crosses(theirEdge)) return false;
      }
    }
    return true;
  }
}
