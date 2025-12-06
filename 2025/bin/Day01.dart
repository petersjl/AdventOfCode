// ignore_for_file: dead_code

import 'package:utils/DartUtils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/Day01.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

class Rotation {
  bool clockwise;
  int distance;
  Rotation(this.clockwise, this.distance) {}
}

typedef InputType = List<Rotation>;

InputType parseInput(String input) {
  return input.splitNewLine().listMap(
    (line) => new Rotation(line[0] == 'R', int.parse(line.substring(1))),
  );
}

const int DIAL_SIZE = 100;
const int START_POS = 50;

String solvePart1(InputType input) {
  var count = 0;
  var position = START_POS;
  for (var rotation in input) {
    position = rotation.clockwise
        ? position + rotation.distance
        : position - rotation.distance;
    position %= DIAL_SIZE;
    if (position == 0) count += 1;
  }

  return count.toString();
}

String solvePart2(InputType input) {
  var count = 0;
  var position = START_POS;
  for (var rotation in input) {
    var startsOnZero = position == 0;
    position = rotation.clockwise
        ? position + rotation.distance
        : position - rotation.distance;
    count += (position ~/ DIAL_SIZE).abs();
    if (position.remainder(DIAL_SIZE) < 0 && !startsOnZero) count += 1;
    if (position < 0 && position.remainder(DIAL_SIZE) == 0 && !startsOnZero)
      count += 1;
    if (position == 0) count += 1;
    position %= DIAL_SIZE;
  }

  return count.toString();
}
