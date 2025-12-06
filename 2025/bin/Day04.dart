// ignore_for_file: dead_code

// import 'package:utils/ComonFunctions.dart';
import 'package:utils/DartUtils.dart';
import 'package:utils/Grid.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/Day04.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
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
