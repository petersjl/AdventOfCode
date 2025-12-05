// ignore_for_file: dead_code

// import 'package:utils/ComonFunctions.dart';
import 'package:utils/DartUtils.dart';
import 'package:utils/Grid.dart';

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

typedef InputType = Grid<int>;

InputType parseInput(String input) {
  return Grid<int>.fromStringGrid(
    input,
    (line) => line.split(''),
    (c) => c == '.' ? 0 : 1,
  );
}

String solvePart1(InputType input) {
  var moveable = input.count((cell, point) {
    if (cell == 0) return false;
    if (input.surroundingLessThan(point, 4, (val) => val > 0)) {
      return true;
    }
    return false;
  });
  return moveable.toString();
}

String solvePart2(InputType input) {
  var lastMoveable = -1;
  var moveable = 0;
  while (moveable != lastMoveable) {
    lastMoveable = moveable;
    input.map((cell, point) {
      if (cell == 0) return cell;
      if (input.surroundingLessThan(point, 4, (val) => val > 0)) {
        moveable++;
        return 0;
      }
      return cell;
    });
  }
  return moveable.toString();
}
