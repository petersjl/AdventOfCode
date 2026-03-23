// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day18.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = List<bool>;

InputType parseInput(String input) {
  return input.trim().characters.map((line) => line == "^").toList();
}

String solvePart1(InputType input, [int rows = 40]) {
  var currentRow = input;
  var safeCount = currentRow.where((tile) => !tile).length;
  for (int i = 1; i < rows; i++) {
    var nextRow = List<bool>.generate(currentRow.length, (index) {
      var left = index > 0 ? currentRow[index - 1] : false;
      var center = currentRow[index];
      var right = index < currentRow.length - 1 ? currentRow[index + 1] : false;
      return (left && center && !right) ||
          (!left && center && right) ||
          (left && !center && !right) ||
          (!left && !center && right);
    });
    safeCount += nextRow.where((tile) => !tile).length;
    currentRow = nextRow;
  }
  return safeCount.toString();
}

String solvePart2(InputType input) {
  return "";
}
