// ignore_for_file: dead_code

import 'dart:math';

import 'package:utils/DartUtils.dart';

void main() {
  bool runP1 = true;
  bool runP2 = true;
  String solutionP1 = "", solutionP2 = "";

  var rawInput = Utils.readToString("../inputs/Day02.txt");

  Stopwatch stopwatch = new Stopwatch()..start();
  var input = parseInput(rawInput);
  var timeParse = stopwatch.elapsed;

  if (runP1) solutionP1 = solvePart1(input);
  var timeP1 = stopwatch.elapsed;
  if (runP2) solutionP2 = solvePart2(input);
  var timeP2 = stopwatch.elapsed;
  stopwatch.stop();

  print('Parse time: ${Utils.timingString(timeParse)}');
  if (runP1)
    print('Part 1 (${Utils.timingString(timeP1 - timeParse)}): ${solutionP1}');
  if (runP2)
    print('Part 2 (${Utils.timingString(timeP2 - timeP1)}): ${solutionP2}');
  print('Ran in ${Utils.timingString(timeP2)}');
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
  return "";
}
