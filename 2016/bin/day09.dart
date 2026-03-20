// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day09.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = String;

InputType parseInput(String input) {
  return input;
}

String solvePart1(InputType input) {
  return decompressLength(input).toString();
}

String solvePart2(InputType input) {
  return decompressLength(input, recursive: true).toString();
}

int decompressLength(String line, {bool recursive = false}) {
  int length = 0;
  String current = line;
  while (current.isNotEmpty) {
    var match = RegExp(r'\((\d+)x(\d+)\)').firstMatch(current);
    if (match == null) {
      length += current.length;
      break;
    }
    int numChars = int.parse(match.group(1)!);
    int repeat = int.parse(match.group(2)!);
    length += match.start;
    var toRepeat = current.substring(match.end, match.end + numChars);
    length +=
        repeat *
        (recursive
            ? decompressLength(toRepeat, recursive: true)
            : toRepeat.length);
    current = current.substring(match.end + numChars);
  }
  return length;
}
