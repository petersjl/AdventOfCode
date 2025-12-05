// ignore_for_file: dead_code

import 'package:utils/ComonFunctions.dart';
import 'package:utils/DartUtils.dart';

void main() {
  bool runP1 = true;
  bool runP2 = true;
  String solutionP1 = "", solutionP2 = "";

  var rawInput = Utils.readToString("../inputs/Day04.txt");

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

typedef InputType = List<List<int>>;

InputType parseInput(String input) {
  return input
      .splitNewLine()
      .map((line) => line.split('').map((c) => c == '.' ? 0 : 1).toList())
      .toList();
}

String solvePart1(InputType input) {
  int moveable = 0;
  for (int y = 0; y < input.length; y++) {
    for (int x = 0; x < input[y].length; x++) {
      if (input[y][x] == 0) continue;
      var surrounding = checkSurroundingPoints(
        input,
        Point(x, y),
        (val) => val == 1,
      );
      if (surrounding.length < 4) {
        moveable++;
      }
    }
  }
  return moveable.toString();
}

String solvePart2(InputType input) {
  return "";
}
