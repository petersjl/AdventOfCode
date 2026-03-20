// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';
import 'package:utils/data_structures.dart' show Grid;

void main() {
  var rawInput = Utils.readToString("../inputs/day08.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = List<Command>;

InputType parseInput(String input) {
  return input.splitNewLine().map((line) {
    var parts = line.trim().splitWhitespace();
    if (parts[0] == "rect") {
      var sizeParts = parts[1].split("x");
      return RectCommand(int.parse(sizeParts[0]), int.parse(sizeParts[1]));
    } else if (parts[0] == "rotate") {
      var indexParts = parts[2].split("=");
      if (parts[1] == "row") {
        return RotateRowCommand(int.parse(indexParts[1]), int.parse(parts[4]));
      } else if (parts[1] == "column") {
        return RotateColumnCommand(
          int.parse(indexParts[1]),
          int.parse(parts[4]),
        );
      } else {
        throw Exception("Unknown rotate command: $line");
      }
    } else {
      throw Exception("Unknown command: $line");
    }
  }).toList();
}

String solvePart1(InputType input, {int x = 50, int y = 6}) {
  var display = Grid<bool>((x, y) => false, x, y);
  for (var command in input) {
    command.run(display);
  }
  return display.count((cell, _) => cell).toString();
}

String solvePart2(
  InputType input, {
  int charCount = 10,
  int charWidth = 5,
  int charHeight = 6,
}) {
  var display = Grid<bool>((x, y) => false, charCount * charWidth, charHeight);
  for (var command in input) {
    command.run(display);
  }
  return getDisplayMessage(display);
}

abstract class Command {
  void run(Grid<bool> display);
}

class RectCommand implements Command {
  final int width;
  final int height;

  RectCommand(this.width, this.height);

  @override
  void run(Grid<bool> display) {
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        display.set(x, y, true);
      }
    }
  }
}

class RotateRowCommand implements Command {
  final int row;
  final int amount;

  RotateRowCommand(this.row, this.amount);

  @override
  void run(Grid<bool> display) {
    var newRow = List.generate(display.width, (i) => display.get(i, row));
    for (int x = 0; x < display.width; x++) {
      newRow[(x + amount) % display.width] = display.get(x, row);
    }
    for (int x = 0; x < display.width; x++) {
      display.set(x, row, newRow[x]);
    }
  }
}

class RotateColumnCommand implements Command {
  final int column;
  final int amount;

  RotateColumnCommand(this.column, this.amount);

  @override
  void run(Grid<bool> display) {
    var newCol = List.generate(display.height, (i) => display.get(column, i));
    for (int y = 0; y < display.height; y++) {
      newCol[(y + amount) % display.height] = display.get(column, y);
    }
    for (int y = 0; y < display.height; y++) {
      display.set(column, y, newCol[y]);
    }
  }
}

String getDisplayMessage(Grid<bool> display) {
  var message = "";
  for (int i = 0; i < display.width ~/ 5; i++) {
    message += getCharacterFromDisplay(display, i);
  }
  return message;
}

String getCharacterFromDisplay(Grid<bool> display, int charIndex) {
  var pixelLetter = display.printPartial(
    charIndex * 5,
    0,
    charIndex * 5 + 5,
    6,
    (cell) => cell ? "#" : ".",
  );
  var char = _pixelStringToChar[pixelLetter];
  if (char == null) {
    throw Exception("Unknown character for pixels:\n$pixelLetter");
  }
  return char;
}

// This is all the letters in my input, so this is all we can add for now
final Map<String, String> _pixelStringToChar = {
  // dart format off
  // The extra string in each letter guarantees a newline at the end
  [
  ".##..",
  "#..#.",
  "#....",
  "#....",
  "#..#.",
  ".##..",
  ""
  ].join('\n'): "C",
  [
  "####.",
  "#....",
  "###..",
  "#....",
  "#....",
  "####.",
  ""
  ].join('\n'): "E",
  [
  "####.",
  "#....",
  "###..",
  "#....",
  "#....",
  "#....",
  ""
  ].join('\n'): "F",
  [
  "#....",
  "#....",
  "#....",
  "#....",
  "#....",
  "####.",
  ""
  ].join('\n'): "L",
  [
  ".##..",
  "#..#.",
  "#..#.",
  "#..#.",
  "#..#.",
  ".##..",
  ""
  ].join('\n'): "O",
  [
  ".###.",
  "#....",
  "#....",
  ".##..",
  "...#.",
  "###..",
  ""
  ].join('\n'): "S",
  [
  "#...#",
  "#...#",
  ".#.#.",
  "..#..",
  "..#..",
  "..#..",
  ""
  ].join('\n'): "Y",
  // dart format on
};
