// ignore_for_file: dead_code

import 'dart:math';

import 'package:utils/DartUtils.dart';
import 'package:utils/DataStructures/RightPolygon.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/Day09.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = List<Point>;

InputType parseInput(String input) {
  return input.splitNewLine().map((line) {
    var parts = line.split(',');
    return Point(int.parse(parts[0]), int.parse(parts[1]));
  }).toList();
}

String solvePart1(InputType input) {
  var biggest = 0;
  for (int i = 0; i < input.length; i++) {
    for (int j = i + 1; j < input.length; j++) {
      var left = input[i];
      var right = input[j];
      final minX = min(left.x, right.x);
      final maxX = max(left.x, right.x);
      final minY = min(left.y, right.y);
      final maxY = max(left.y, right.y);
      final area = (maxX - minX + 1) * (maxY - minY + 1);
      biggest = max(biggest, area);
    }
  }
  return biggest.toString();
}

String solvePart2(InputType input) {
  var polygon = RightPolygon(input);
  var maxArea = 0;
  for (int i = 0; i < input.length; i++) {
    for (int j = i + 1; j < input.length; j++) {
      final left = input[i];
      final right = input[j];
      final area = getArea(left, right);
      if (area <= maxArea) {
        continue;
      }
      final rect = RightPolygon([
        left,
        Point(left.x, right.y),
        right,
        Point(right.x, left.y),
      ]);
      if (polygon.contains(rect)) {
        maxArea = area;
      }
    }
  }
  return maxArea.toString();
}

int getArea(Point left, Point right) {
  final minX = min(left.x, right.x);
  final maxX = max(left.x, right.x);
  final minY = min(left.y, right.y);
  final maxY = max(left.y, right.y);
  return (maxX - minX + 1) * (maxY - minY + 1);
}
