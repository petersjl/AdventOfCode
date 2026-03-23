// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day15.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = List<Disc>;

InputType parseInput(String input) {
  return input.splitNewLine().map((line) {
    var match = RegExp(r".* \#(\d+).* (\d+) .* (\d+)\.").firstMatch(line);
    if (match == null) {
      throw Exception("Invalid input line: $line");
    }
    return Disc(
      int.parse(match.group(1)!),
      int.parse(match.group(2)!),
      int.parse(match.group(3)!),
    );
  }).toList();
}

String solvePart1(InputType input) {
  for (int i = 0; i < 100000000; i++) {
    if (input.every((disc) => disc.isAligned(i))) {
      return i.toString();
    }
  }
  throw Exception("Did not find solution within search limit");
}

String solvePart2(InputType input) {
  return "";
}

class Disc {
  final int order;
  final int positions;
  final int start;

  Disc(this.order, this.positions, this.start);

  bool isAligned(int time) {
    return (order + start + time) % positions == 0;
  }
}
