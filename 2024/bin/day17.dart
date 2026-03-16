// ignore_for_file: dead_code

import 'dart:math';

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day17.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = (int, int, int, List<int>);

InputType parseInput(String input) {
  var lines = input.splitNewLine();
  var getRegister = (String line) {
    var parts = line.splitWhitespace();
    return int.parse(parts[2]);
  };
  int a = getRegister(lines[0]);
  int b = getRegister(lines[1]);
  int c = getRegister(lines[2]);

  List<int> instructions = lines[4]
      .splitWhitespace()[1]
      .split(',')
      .listMap((str) => int.parse(str));
  return (a, b, c, instructions);
}

typedef int? opFunc(int operand);

class Machine {
  int _A, _B, _C, A, B, C, iPointer = 0;
  List<int> instructions;
  Machine(int a, int b, int c, List<int> instructions)
    : A = a,
      B = b,
      C = c,
      _A = a,
      _B = b,
      _C = c,
      instructions = instructions {
    _ops.add(adv);
    _ops.add(bxl);
    _ops.add(bst);
    _ops.add(jnz);
    _ops.add(bxc);
    _ops.add(out);
    _ops.add(bdv);
    _ops.add(cdv);
    _ops.add(adv);
  }

  void reset({int? a}) {
    A = a ?? _A;
    B = _B;
    C = _C;
    iPointer = 0;
  }

  List<opFunc> _ops = [];

  int? getNextValue() {
    int? val;
    while (true) {
      if (iPointer >= instructions.length - 1) return null;
      val = _ops[instructions[iPointer]](instructions[iPointer + 1]);
      iPointer += 2;
      if (val != null) return val;
    }
  }

  int getComboOperand(int operand) {
    return switch (operand) {
      4 => A,
      5 => B,
      6 => C,
      7 => throw Exception("Invalid combo operand"),
      _ => operand,
    };
  }

  int? adv(int operand) {
    int p = getComboOperand(operand);
    A = A ~/ pow(2, p);
    return null;
  }

  int? bxl(int operand) {
    B = B ^ operand;
    return null;
  }

  int? bst(int operand) {
    int mod = getComboOperand(operand);
    B = mod & 7; // Shorter % 8
    return null;
  }

  int? jnz(int operand) {
    if (A == 0) return null;
    iPointer = operand - 2;
    return null;
  }

  int? bxc(int operand) {
    B = B ^ C;
    return null;
  }

  int? out(int operand) {
    int mod = getComboOperand(operand);
    return mod & 7;
  }

  int? bdv(int operand) {
    int p = getComboOperand(operand);
    B = A ~/ pow(2, p);
    return null;
  }

  int? cdv(int operand) {
    int p = getComboOperand(operand);
    C = A ~/ pow(2, p);
    return null;
  }
}

String solvePart1(InputType input, [int? A]) {
  var (a, b, c, instructions) = input;
  a = A ?? a;
  var machine = Machine(a, b, c, instructions);
  int? val = null;
  List<int> output = [];
  while (true) {
    val = machine.getNextValue();
    if (val == null) break;
    output.add(val);
  }
  return output.join(',');
}

void checkInstructions(List<int> instructions) {
  // Checks two assumptions
  // - There is only one adv and it's operand is 3
  // - The last instruction is a jump to 0
  if (instructions[instructions.length - 1] != 0 ||
      instructions[instructions.length - 2] != 3)
    throw Exception(
      "Program does not end in 3,0 meaning it won't skip back to the start\nThis program won't work",
    );
  int jumpCount = 0;
  for (int i = 0; i < instructions.length; i += 2) {
    if (instructions[i] == 3) {
      jumpCount++;
      if (jumpCount > 1)
        throw Exception("More than one adv. This program won't work");
      if (instructions[i + 1] != 0)
        throw Exception("Does not jump to start. This program won't work");
    }
  }
}

String solvePart2(InputType input) {
  var (_, b, c, instructions) = input;
  checkInstructions(instructions);
  int a = 0;
  var machine = Machine(a, b, c, instructions);
  for (int i = instructions.length - 1; i >= 0; i--) {
    var target = instructions[i];
    int? val = null;
    while (true) {
      machine.reset(a: a);
      val = machine.getNextValue();
      if (val == target) break;
      a++;
    }
    a = a << 3;
  }
  a = a >> 3;
  machine.reset(a: 0);
  var result = solvePart1(input, a);
  if (result != instructions.join(','))
    throw Exception("Got the wrong answer $a: $result");
  return a.toString();
}
