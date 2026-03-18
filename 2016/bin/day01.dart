// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

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
  Set<Point> visited = new Set();
  Point location = Point(0, 0);
  visited.add(location);
  for (String str in input) {
    currentDirection = str[0] == 'R'
        ? currentDirection.rotateClockwise()
        : currentDirection.rotateCounterClockwise();
    int dist = int.parse(str.substring(1));
    for (int i = 0; i < dist; i++) {
      location += currentDirection;
      if (!visited.add(location)) {
        return (location.x.abs() + location.y.abs()).toString();
      }
    }
  }
  return (location.x.abs() + location.y.abs()).toString();
}
