// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day06.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = List<String>;

InputType parseInput(String input) {
  return input.splitNewLine();
}

String solvePart1(InputType input) {
  int runs = input[0].length;
  String message = '';
  for (int i = 0; i < runs; i++) {
    message += findCommonAtPosition(input, i);
  }
  return message;
}

String solvePart2(InputType input) {
  int runs = input[0].length;
  String message = '';
  for (int i = 0; i < runs; i++) {
    message += findCommonAtPosition(input, i, true);
  }
  return message;
}

String findCommonAtPosition(
  List<String> input,
  int index, [
  bool least = false,
]) {
  Map<String, int> map = {};
  for (String s in input) {
    String char = s[index];
    map.increment(char);
  }
  var pairs = map.entries.toList()
    ..sort(
      (a, b) => least ? a.value.compareTo(b.value) : b.value.compareTo(a.value),
    );
  return pairs.first.key;
}
