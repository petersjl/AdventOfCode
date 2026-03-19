// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day03.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = List<List<int>>;

InputType parseInput(String input) {
  return input
      .splitNewLine()
      .map(
        (str) =>
            str.trim().splitWhitespace().map((ele) => int.parse(ele)).toList(),
      )
      .toList();
}

String solvePart1(InputType input) {
  int validCount = 0;
  for (var row in input) {
    if (checkHorizontalTriangle(row)) validCount++;
  }
  return validCount.toString();
}

String solvePart2(InputType input) {
  return "";
}

bool checkHorizontalTriangle(List<int> sides) {
  sides.sort();
  return sides[0] + sides[1] > sides[2];
}
