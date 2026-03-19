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
  Point num = new Point(2, 0);
  String code = '';
  for (String line in input) {
    num = getCrossButton(num, line);
    code += getButtonVal(num)!;
  }
  return code;
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

Point getCrossButton(Point startButton, String instructions) {
  int row = startButton.x;
  int col = startButton.y;

  for (String s in instructions.characters) {
    int newRow = row;
    int newCol = col;
    switch (s) {
      case 'U':
        newRow--;
        break;
      case 'D':
        newRow++;
        break;
      case 'L':
        newCol--;
        break;
      case 'R':
        newCol++;
        break;
      case '\n':
        continue;
      default:
        print('Invalid character in getButton: $s');
        continue;
    }
    if (getButtonVal(new Point(newRow, newCol)) != null) {
      row = newRow;
      col = newCol;
    }
  }
  return new Point(row, col);
}

String? getButtonVal(Point button) {
  switch (button.x) {
    case 0:
      return button.y == 2 ? '1' : null;
    case 1:
      return button.y > 0 && button.y < 4 ? (button.y + 1).toString() : null;
    case 2:
      return button.y > -1 && button.y < 5 ? (button.y + 5).toString() : null;
    case 3:
      switch (button.y) {
        case 1:
          return 'A';
        case 2:
          return 'B';
        case 3:
          return 'C';
        default:
          return null;
      }
    case 4:
      return button.y == 2 ? 'D' : null;
    default:
      return null;
  }
}
