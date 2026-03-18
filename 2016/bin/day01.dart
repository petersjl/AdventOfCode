// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day01.txt");
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

bool progressVisits(
  Point point,
  int distance,
  Point direction,
  Set<Point> visited,
) {
  var func = () => 1;
  switch (direction) {
    case Direction.North:
      func = () => point.y += 1;
      break;
    case Direction.South:
      func = () => point.y -= 1;
      break;
    case Direction.East:
      func = () => point.x += 1;
      break;
    case Direction.West:
      func = () => point.x -= 1;
      break;
  }
  for (int i = 0; i < distance; i++) {
    func();
    print('Visiting $point, seen: $visited');
    if (!visited.add(point)) return true;
  }
  return false;
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
