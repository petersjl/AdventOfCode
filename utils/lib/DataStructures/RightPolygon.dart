import 'package:utils/DartUtils.dart';
import 'package:utils/DataStructures/AxisLine.dart';

class RightPolygon {
  List<Point> points;
  List<AxisLine> _lines;
  List<AxisLine> _doubledLines;
  int maxX = 0;
  int maxY = 0;
  int minX = 0x7FFFFFFFFFFFFFFF;
  int minY = 0x7FFFFFFFFFFFFFFF;

  RightPolygon(List<Point> points)
    : this.points = List.unmodifiable(points),
      _lines = [],
      _doubledLines = [] {
    if (points.length < 3) {
      throw Exception('A polygon must have at least 3 points');
    }
    for (int i = 0; i < points.length; i++) {
      final a = points[i];
      final b = points[(i + 1) % points.length];
      if (a.x > maxX) maxX = a.x;
      if (a.y > maxY) maxY = a.y;
      if (a.x < minX) minX = a.x;
      if (a.y < minY) minY = a.y;
      _lines.add(AxisLine(a, b));
      _doubledLines.add(AxisLine(a * 2, b * 2));
    }
    for (final p in points) {
      if (p.x > maxX) maxX = p.x;
      if (p.y > maxY) maxY = p.y;
    }
  }

  List<AxisLine> get edges {
    return List.unmodifiable(_lines);
  }

  bool containsPoint(Point p) {
    var upRay = AxisLine(
      Point((p.x * 2) + 1, (p.y * 2)),
      Point((p.x * 2) + 1, (maxY * 2) + 1),
    );
    var upCollisions = 0;
    for (var line in _doubledLines) {
      if (line.containsPoint(p * 2)) return true;
      if (line.isHorizontal && upRay.crosses(line)) {
        upCollisions++;
      }
    }
    return (upCollisions % 2 == 1);
  }

  bool contains(RightPolygon other) {
    for (var point in other.points) {
      if (!containsPoint(point)) {
        return false;
      }
    }
    return !intersects(other);
  }

  bool intersects(RightPolygon other) {
    for (var myEdge in this.edges) {
      int crosses = 0;
      for (var theirEdge in other.edges) {
        if (myEdge.crosses(theirEdge)) {
          crosses++;
        } else if (myEdge.overlaps(theirEdge)) {
          // Deal with touching edges
          if (myEdge.contains(theirEdge) || theirEdge.contains(myEdge)) {
            crosses -= 2;
          } else {
            crosses--;
          }
        }
      }
      if (crosses > 0) {
        return true;
      }
    }
    return false;
  }
}
