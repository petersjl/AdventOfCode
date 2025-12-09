import 'dart:math';

import 'package:utils/DartUtils.dart';

class AxisLine {
  final Point start;
  final Point end;
  final bool isHorizontal;
  bool get isVertical => !isHorizontal;
  int get left => min(start.x, end.x);
  int get right => max(start.x, end.x);
  int get top => min(start.y, end.y);
  int get bottom => max(start.y, end.y);

  AxisLine(this.start, this.end) : isHorizontal = start.y == end.y {
    if (!isHorizontal && start.x != end.x) {
      throw Exception("AxisLine must be horizontal or vertical");
    }
  }

  bool crosses(AxisLine other) {
    if (isHorizontal == other.isHorizontal) {
      return false;
    } else if (isHorizontal) {
      // my top == my bottom
      return (left <= other.left &&
          other.left <= right &&
          other.top <= top &&
          top <= other.bottom);
    } else if (isVertical) {
      // my left == my right
      return (top <= other.top &&
          other.top <= bottom &&
          other.left <= left &&
          left <= other.right);
    }
    return false;
  }
}
