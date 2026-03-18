// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day02.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = List<String>;

InputType parseInput(String input) {
  return input.splitNewLine();
}

String solvePart1(InputType input) {
  int num = 5;
  String code = '';
  for (String line in input) {
    num = getButton(num, line);
    if (num == -1) return "";
    code += num.toString();
  }
  return code;
}

String solvePart2(InputType input) {
  return "";
}

int getButton(int startButton, String instructions) {
  int col = (startButton - 1) % 3;
  int row = (startButton - 1) ~/ 3;
  for (String s in instructions.characters) {
    switch (s) {
      case 'U':
        row--;
        break;
      case 'D':
        row++;
        break;
      case 'L':
        col--;
        break;
      case 'R':
        col++;
        break;
      case '\n':
        continue;
      default:
        print('Invalid character in getButton: $s');
        continue;
    }
    if (row < 0)
      row = 0;
    else if (row > 2)
      row = 2;
    if (col < 0)
      col = 0;
    else if (col > 2)
      col = 2;
  }
  return row * 3 + col + 1;
}
