// ignore_for_file: dead_code

import 'package:utils/DartUtils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/Day07.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = (List<String>, Point);

InputType parseInput(String input) {
  var lines = input.splitNewLine();
  var point = Point(lines[0].indexOf('S'), 0);
  return (lines, point);
}

String solvePart1(InputType input) {
  var (lines, start) = input;
  var queue = Queue<Point>()..push(start);
  var seen = Set<Point>()..add(start);
  var splits = 0;
  while (!queue.isEmpty) {
    var current = queue.pop();
    if (lines[current.y][current.x] == '^') {
      splits++;
      var left = current + Point.left;
      var right = current + Point.right;
      if (!seen.contains(left)) {
        seen.add(left);
        queue.push(left);
      }
      if (!seen.contains(right)) {
        seen.add(right);
        queue.push(right);
      }
    } else {
      var down = current + Point.down;
      if (down.y < lines.length && !seen.contains(down)) {
        seen.add(down);
        queue.push(down);
      }
    }
  }
  return splits.toString();
}

String solvePart2(InputType input) {
  return "";
}
