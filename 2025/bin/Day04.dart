// ignore_for_file: dead_code

import 'package:utils/ComonFunctions.dart';
import 'package:utils/DartUtils.dart';

void main() {
  bool runP1 = true;
  bool runP2 = true;
  String solutionP1 = "", solutionP2 = "";

  var rawInput = Utils.readToString("../inputs/Day04.txt");

  Stopwatch stopwatch = new Stopwatch()..start();
  var inputP1 = parseInput(rawInput);
  var timeParse = stopwatch.elapsed;
  // Parse again for part 2 to allow any mutations,
  // but don't count that time
  stopwatch.stop();
  var inputP2 = parseInput(rawInput);

  stopwatch.start();
  if (runP1) solutionP1 = solvePart1(inputP1);
  var timeP1 = stopwatch.elapsed;
  if (runP2) solutionP2 = solvePart2(inputP2);
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
  var grid = Utils.cloneGrid(input);
  var lastMoveable = -1;
  var moveable = 0;
  while (moveable != lastMoveable) {
    lastMoveable = moveable;
    for (int y = 0; y < grid.length; y++) {
      for (int x = 0; x < grid[y].length; x++) {
        if (grid[y][x] == 0) continue;
        var surrounding = checkSurroundingPoints(
          grid,
          Point(x, y),
          (val) => val > 0,
        );
        if (surrounding.length < 4) {
          grid[y][x] = 0;
          moveable++;
        }
      }
    }
  }
  return moveable.toString();
}
