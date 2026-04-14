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
  final registers = {'a': 12, 'b': 0, 'c': 0, 'd': 0};
  int i = 0;
  while (i < input.length) {
    i += tryOptimizeAt(i, input, registers) ?? input[i].run(registers, i);
  }
  return registers['a'].toString();
}

// Returns the number of instructions to advance if a loop was optimized away,
// or null if no known pattern matched at this index.
int? tryOptimizeAt(
  int index,
  List<Instruction> instructions,
  Map<String, int> registers,
) {
  if (index + 3 <= instructions.length) {
    final a = instructions[index];
    final b = instructions[index + 1];
    final c = instructions[index + 2];
    // Add loop:
    //   inc X
    //   dec Y
    //   jnz Y -2
    // => X += Y; Y = 0
    if (a is inc &&
        b is dec &&
        c is jnz &&
        c.intCheck == null &&
        c.strCheck == b.register &&
        c.intOffset == -2) {
      registers[a.register] =
          (registers[a.register] ?? 0) + (registers[b.register] ?? 0);
      registers[b.register] = 0;
      return 3;
    }
  }

  if (index + 6 <= instructions.length) {
    final a = instructions[index];
    final b = instructions[index + 1];
    final c = instructions[index + 2];
    final d = instructions[index + 3];
    final e = instructions[index + 4];
    final f = instructions[index + 5];
    // Multiply loop:
    //   cpy A B
    //   inc C
    //   dec B
    //   jnz B -2
    //   dec D
    //   jnz D -5
    // => C += A * D; B = 0; D = 0
    if (a is cpy &&
        b is inc &&
        c is dec &&
        d is jnz &&
        e is dec &&
        f is jnz &&
        c.register == a.to &&
        d.intCheck == null &&
        d.strCheck == c.register &&
        d.intOffset == -2 &&
        f.intCheck == null &&
        f.strCheck == e.register &&
        f.intOffset == -5) {
      final aValue = a.intFrom ?? registers[a.strFrom] ?? 0;
      final dValue = registers[e.register] ?? 0;
      registers[b.register] = (registers[b.register] ?? 0) + aValue * dValue;
      registers[a.to] = 0;
      registers[e.register] = 0;
      return 6;
    }
  }

  return null;
}
