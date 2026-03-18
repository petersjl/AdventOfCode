// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day{day_num}.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

enum Direction { North, South, East, West }

typedef InputType = List<String>;

InputType parseInput(String input) {
  return input.split(', ');
}

String solvePart1(InputType input) {
  Direction currentDirection = Direction.North;
  Point location = Point(0, 0);
  for (String str in input) {
    bool turnDir = str[0] == 'R';
    int dist = int.parse(str.substring(1));
    currentDirection = turn(currentDirection, turnDir);
    progress(location, dist, currentDirection);
  }
  return (location.x.abs() + location.y.abs()).toString();
}

void progress(Point point, int distance, Direction direction) {
  switch (direction) {
    case Direction.North:
      point.y += distance;
      break;
    case Direction.South:
      point.y -= distance;
      break;
    case Direction.East:
      point.x += distance;
      break;
    case Direction.West:
      point.x -= distance;
      break;
  }
}

Direction turn(Direction current, bool isRightTurn) {
  switch (current) {
    case Direction.North:
      return isRightTurn ? Direction.East : Direction.West;
    case Direction.South:
      return isRightTurn ? Direction.West : Direction.East;
    case Direction.East:
      return isRightTurn ? Direction.South : Direction.North;
    case Direction.West:
      return isRightTurn ? Direction.North : Direction.South;
  }
}

String solvePart2(InputType input) {
  return "";
}
