// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';
import 'package:utils/data_structures.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day01.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = List<String>;

InputType parseInput(String input) {
  return input.split(', ');
}

String solvePart1(InputType input) {
  Point currentDirection = Point.up;
  Point location = Point(0, 0);
  for (String str in input) {
    currentDirection = str[0] == 'R'
        ? currentDirection.rotateClockwise()
        : currentDirection.rotateCounterClockwise();
    int dist = int.parse(str.substring(1));
    location = location + (currentDirection * dist);
  }
  return (location.x.abs() + location.y.abs()).toString();
}

String solvePart2(InputType input) {
  Point currentDirection = Point.up;
  Point location = Point(0, 0);
  List<AxisLine> lines = [];
  for (String str in input) {
    currentDirection = str[0] == 'R'
        ? currentDirection.rotateClockwise()
        : currentDirection.rotateCounterClockwise();
    int dist = int.parse(str.substring(1));
    var dest = location + (currentDirection * dist);
    var line = AxisLine(location, dest);
    for (var prevLine in lines) {
      var intersection = line.intersect(prevLine);
      if (intersection != null) {
        return (intersection.x.abs() + intersection.y.abs()).toString();
      }
    }
    lines.add(line);
    location = dest;
  }
  throw Exception("No location visited twice");
}
