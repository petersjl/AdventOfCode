import 'package:utils/dart_utils.dart';

Instruction parseAssembunnyInstruction(
  String line, [
  List<Instruction>? instructions,
]) {
  var parts = line.split(' ');
  switch (parts[0]) {
    case 'cpy':
      return cpy(parts[1], parts[2]);
    case 'inc':
      return inc(parts[1]);
    case 'dec':
      return dec(parts[1]);
    case 'jnz':
      return jnz(parts[1], parts[2]);
    case 'tgl':
      if (instructions == null) {
        throw Exception(
          "tgl instruction requires the full instruction list to be passed in",
        );
      }
      return tgl(parts[1], instructions);
    default:
      throw Exception("Unknown instruction: ${parts[0]}");
  }
}

abstract class Instruction {
  int run(Map<String, int> registers, [int currentIndex = 0]);
}

class cpy extends Instruction {
  final String strFrom;
  final int? intFrom;
  final String to;
  cpy(String from, this.to) : strFrom = from, intFrom = int.tryParse(from);

  @override
  int run(Map<String, int> registers, [int currentIndex = 0]) {
    registers[to] = intFrom ?? registers[strFrom]!;
    return 1;
  }
}

class inc extends Instruction {
  final String register;
  inc(this.register);

  @override
  int run(Map<String, int> registers, [int currentIndex = 0]) {
    registers.increment(register);
    return 1;
  }
}

class dec extends Instruction {
  final String register;
  dec(this.register);

  @override
  int run(Map<String, int> registers, [int currentIndex = 0]) {
    registers.increment(register, -1);
    return 1;
  }
}

class jnz extends Instruction {
  final int? intCheck;
  final String strCheck;
  final int? intOffset;
  final String strOffset;
  jnz(String check, String offset)
    : intCheck = int.tryParse(check),
      strCheck = check,
      intOffset = int.tryParse(offset),
      strOffset = offset;

  @override
  int run(Map<String, int> registers, [int currentIndex = 0]) {
    if (intCheck != null) {
      if (intCheck == 0) {
        return 1;
      }
    } else {
      if (registers[strCheck] == 0) {
        return 1;
      }
    }
    return intOffset ?? registers[strOffset]!;
  }
}

class skip extends Instruction {
  final String first;
  final String second;
  skip(this.first, this.second);

  @override
  int run(Map<String, int> registers, [int currentIndex = 0]) {
    return 1;
  }
}

class tgl extends Instruction {
  final String register;
  final List<Instruction> instructions;
  tgl(this.register, this.instructions);

  @override
  int run(Map<String, int> registers, [int currentIndex = 0]) {
    var targetIndex = currentIndex + registers[register]!;
    if (targetIndex < 0 || targetIndex >= instructions.length) {
      return 1; // No instruction to toggle, just move to the next one
    }
    var ins = instructions[targetIndex];
    switch (ins.runtimeType) {
      case cpy:
        instructions[targetIndex] = jnz((ins as cpy).strFrom, ins.to);
        break;
      case inc:
        instructions[targetIndex] = dec((ins as inc).register);
        break;
      case dec:
        instructions[targetIndex] = inc((ins as dec).register);
        break;
      case jnz:
        (ins as jnz);
        if (ins.intOffset == null) {
          instructions[targetIndex] = cpy(ins.strCheck, ins.strOffset);
        } else {
          instructions[targetIndex] = skip(ins.strCheck, ins.strOffset);
        }
        break;
      case tgl:
        instructions[targetIndex] = inc((ins as tgl).register);
        break;
      case skip:
        (ins as skip);
        instructions[targetIndex] = jnz(ins.first, ins.second);
        break;
      default:
        throw Exception("Unknown instruction type: ${ins.runtimeType}");
    }
    return 1;
  }
}
