import 'dart:math';

import 'package:utils/DartUtils.dart';

class AxisLine {
  final Point start;
  final Point end;
  final bool isHorizontal;
  bool get isVertical => !isHorizontal;
  int get left => min(start.x, end.x);
  int get right => max(start.x, end.x);
  int get top => max(start.y, end.y);
  int get bottom => min(start.y, end.y);

  AxisLine(this.start, this.end) : isHorizontal = start.y == end.y {
    if (!isHorizontal && start.x != end.x) {
      throw Exception(
        "AxisLine must be horizontal or vertical: ($start, $end)",
      );
    }
  }

  bool crosses(AxisLine other) {
    if (isHorizontal == other.isHorizontal) {
      return false;
    } else if (isHorizontal) {
      // my top == my bottom
      return (left < other.left &&
          other.left < right &&
          other.bottom < top &&
          top < other.top);
    } else if (isVertical) {
      // my left == my right
      return (bottom < other.top &&
          other.top < top &&
          other.left < left &&
          left < other.right);
    }
    return false;
  }

  bool contains(AxisLine other) {
    if (isHorizontal != other.isHorizontal) return false;
    if (isHorizontal) {
      return top == other.top && left <= other.left && other.right <= right;
    } else {
      return left == other.left && bottom <= other.bottom && other.top <= top;
    }
  }

  bool overlaps(AxisLine other) {
    if (isHorizontal != other.isHorizontal) return false;
    if (isHorizontal) {
      if (top != other.top) return false;
      return !(other.right < left || right < other.left);
    } else {
      if (left != other.left) return false;
      return !(other.top < bottom || top < other.bottom);
    }
  }

  bool containsPoint(Point p) {
    if (isHorizontal) {
      return p.y == start.y && left <= p.x && p.x <= right;
    } else {
      return p.x == start.x && bottom <= p.y && p.y <= top;
    }
  }

  @override
  String toString() {
    return "[($start), ($end)]";
  }

  @override
  bool operator ==(Object other) {
    if (!(other is AxisLine)) return false;
    return this.left == other.left &&
        this.right == other.right &&
        this.top == other.top &&
        this.bottom == other.bottom;
  }

  @override
  int get hashCode => Object.hash(left, right, top, bottom);
}
