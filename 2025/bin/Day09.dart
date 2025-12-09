// ignore_for_file: dead_code

import 'dart:math';

import 'package:utils/DartUtils.dart';

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
  return "";
}
