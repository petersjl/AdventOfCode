// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';
import 'assembunny.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day25.txt");
  Utils.runWithTiming(parseInput, solvePart1, null, rawInput);
}

typedef InputType = List<Instruction>;

InputType parseInput(String input) {
  return input
      .splitNewLine()
      .map((line) => parseAssembunnyInstruction(line))
      .toList();
}

String solvePart1(InputType input) {
  int check = 0;
  while (check < 1000) {
    final registers = {'a': check, 'b': 0, 'c': 0, 'd': 0};
    int i = 0;
    int passCount = 0;
    int output = -1;
    while (i < input.length) {
      if (input[i] is out) {
        final out = input[i].run(registers, i);
        if ((out != 0 && out != 1) || out == output) break;
        output = out;
        passCount++;
        if (passCount >= 20) {
          return check.toString();
        }
        i++;
      }
      i += input[i].run(registers, i);
    }
    check++;
  }
  throw Exception("No solution found");
}
