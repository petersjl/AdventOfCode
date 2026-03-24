// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';
import './assembunny.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day12.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = List<Instruction>;

InputType parseInput(String input) {
  return input.splitNewLine().map((line) {
    return parseAssembunnyInstruction(line);
  }).toList();
}

String solvePart1(InputType input) {
  final registers = {'a': 0, 'b': 0, 'c': 0, 'd': 0};
  runProgram(input, registers);
  return registers['a'].toString();
}

String solvePart2(InputType input) {
  final registers = {'a': 0, 'b': 0, 'c': 1, 'd': 0};
  runProgram(input, registers);
  return registers['a'].toString();
}

void runProgram(List<Instruction> instructions, Map<String, int> registers) {
  int i = 0;
  while (i < instructions.length) {
    i += instructions[i].run(registers);
  }
}
