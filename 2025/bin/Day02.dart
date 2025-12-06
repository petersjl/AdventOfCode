// ignore_for_file: dead_code

import 'dart:math';

import 'package:utils/DartUtils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/Day02.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = List<(int, int)>;

InputType parseInput(String input) {
  return input.split(',').listMap((line) {
    var parts = line.split('-');
    return (int.parse(parts[0]), int.parse(parts[1]));
  });
}

int getDigitCount(int number) {
  if (number == 0) return 1;
  int n = number.abs();
  int digits = 0;
  while (n > 0) {
    n ~/= 10;
    digits++;
  }
  return digits == 0 ? 1 : digits;
}

String solvePart1(InputType input) {
  var invalidSum = 0;
  for (var (start, end) in input) {
    for (var check = start; check <= end; check++) {
      var digits = getDigitCount(check);
      if (digits % 2 != 0) {
        continue;
      }
      int factor = pow(10, digits ~/ 2).toInt();
      var lower = check % factor;
      var upper = check ~/ factor;
      if (upper == lower) {
        invalidSum += check;
      }
    }
  }
  return invalidSum.toString();
}

String solvePart2(InputType input) {
  var invalidSum = 0;
  for (var (start, end) in input) {
    for (var check = start; check <= end; check++) {
      if (checkNumForRepeats(check) != 0) {
        invalidSum += check;
      }
    }
  }
  return invalidSum.toString();
}

int checkNumForRepeats(int number) {
  var digits = getDigitCount(number);
  for (int group = 1; group <= digits ~/ 2; group++) {
    if (matchesForGroup(number, group)) {
      return group;
    }
  }
  return 0;
}

bool matchesForGroup(int number, int group) {
  int factor = pow(10, group).toInt();
  var lower = number % factor;
  if (getDigitCount(lower) != group) {
    return false;
  }
  var upper = number ~/ factor;
  while (upper > 0) {
    if (upper % factor != lower) {
      return false;
    }
    upper = (upper ~/ factor);
  }
  return true;
}
