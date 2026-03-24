// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day20.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = List<Point>;

InputType parseInput(String input) {
  return input.splitNewLine().map((line) {
    final parts = line.split("-");
    return Point(int.parse(parts[0]), int.parse(parts[1]));
  }).toList();
}

String solvePart1(InputType input) {
  var ranges = input;
  ranges.sort((a, b) {
    final cmp = a.x.compareTo(b.x);
    return cmp != 0 ? cmp : b.y.compareTo(a.y);
  });
  int current = 0;
  for (var range in ranges) {
    if (range.x > current) {
      return current.toString();
    }
    if (range.y > current) {
      current = range.y + 1;
    }
  }
  return current.toString();
}

String solvePart2(InputType input) {
  return "";
}
