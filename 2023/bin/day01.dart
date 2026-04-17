// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day01.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = List<String>;

InputType parseInput(String input) {
  return input.splitNewLine();
}

String solvePart1(InputType input) {
  return "";
}

String solvePart2(InputType input) {
  return "";
}
