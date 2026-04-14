// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';
import 'assembunny.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day23.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = List<Instruction>;

InputType parseInput(String input) {
  List<Instruction> instructions = [];
  for (var line in input.splitNewLine()) {
    instructions.add(parseAssembunnyInstruction(line, instructions));
  }
  return instructions;
}

String solvePart1(InputType input) {
  final registers = {'a': 7, 'b': 0, 'c': 0, 'd': 0};
  int i = 0;
  while (i < input.length) {
    i += input[i].run(registers, i);
  }
  return registers['a'].toString();
}

String solvePart2(InputType input) {
  return "";
}
