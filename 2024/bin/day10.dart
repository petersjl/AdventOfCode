// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';
import 'package:utils/data_structures.dart' show Queue;

void main() {
  var rawInput = Utils.readToString("../inputs/day10.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = (List<List<int>>, List<Point>);

InputType parseInput(String input) {
  List<List<int>> map = input
      .splitNewLine()
      .map((line) => line.split('').map((str) => int.parse(str)).toList())
      .toList();
  List<Point> trailheads = [];
  for (int row = 0; row < map.length; row++) {
    for (int col = 0; col < map[0].length; col++) {
      if (map[row][col] == 0) trailheads.add(Point(col, row));
    }
  }
  return (map, trailheads);
}

bool checkPoint(List<List<int>> map, Point point, int currentStepValue) {
  return 0 <= point.x &&
      point.x < map[0].length &&
      0 <= point.y &&
      point.y < map.length &&
      map[point.y][point.x] - currentStepValue == 1;
}

int getTrailheadScore(
  List<List<int>> map,
  Point head, {
  bool getAllTrails = false,
}) {
  List<Point> heads = [];
  Queue<Point> queue = new Queue();
  queue.push(head);
  while (!queue.isEmpty) {
    var current = queue.pop();
    var currentVal = map[current.y][current.x];
    if (currentVal == 9) {
      heads.add(current);
      continue;
    }
    Point up = current + Point(0, -1);
    Point down = current + Point(0, 1);
    Point left = current + Point(-1, 0);
    Point right = current + Point(1, 0);
    if (checkPoint(map, up, currentVal)) queue.push(up);
    if (checkPoint(map, down, currentVal)) queue.push(down);
    if (checkPoint(map, left, currentVal)) queue.push(left);
    if (checkPoint(map, right, currentVal)) queue.push(right);
  }
  if (getAllTrails)
    return heads.length;
  else
    return Set.from(heads).length;
}

String solvePart1(InputType input) {
  var (map, trailheads) = input;
  int score = 0;
  for (var head in trailheads) {
    score += getTrailheadScore(map, head);
  }
  return score.toString();
}

String solvePart2(InputType input) {
  var (map, trailheads) = input;
  int score = 0;
  for (var head in trailheads) {
    score += getTrailheadScore(map, head, getAllTrails: true);
  }
  return score.toString();
}
