// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';
import 'package:utils/data_structures.dart' show Queue;

void main() {
  var rawInput = Utils.readToString("../inputs/day17.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = String;

InputType parseInput(String input) {
  return input;
}

final openChars = 'bcdef';

String solvePart1(InputType input) {
  Queue<({String path, Point position})> toVisit = Queue();
  toVisit.push((path: "", position: Point(0, 0)));
  while (!toVisit.isEmpty) {
    var current = toVisit.pop();
    if (current.position == Point(3, 3)) {
      return current.path;
    }
    var hash = Utils.generateMd5("$input${current.path}");
    if (openChars.contains(hash[0]) && current.position.y > 0) {
      toVisit.push((
        path: "${current.path}U",
        position: current.position + Point.up,
      ));
    }
    if (openChars.contains(hash[1]) && current.position.y < 3) {
      toVisit.push((
        path: "${current.path}D",
        position: current.position + Point.down,
      ));
    }
    if (openChars.contains(hash[2]) && current.position.x > 0) {
      toVisit.push((
        path: "${current.path}L",
        position: current.position + Point.left,
      ));
    }
    if (openChars.contains(hash[3]) && current.position.x < 3) {
      toVisit.push((
        path: "${current.path}R",
        position: current.position + Point.right,
      ));
    }
  }
  throw Exception("No path found to target");
}

String solvePart2(InputType input) {
  return "";
}
