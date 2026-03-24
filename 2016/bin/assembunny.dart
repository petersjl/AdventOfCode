import 'package:utils/dart_utils.dart';

Instruction parseAssembunnyInstruction(String line) {
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
    default:
      throw Exception("Unknown instruction: ${parts[0]}");
  }
}

abstract class Instruction {
  int run(Map<String, int> registers);
}

class cpy extends Instruction {
  final String strFrom;
  final int? intFrom;
  final String to;
  cpy(String from, this.to) : strFrom = from, intFrom = int.tryParse(from);

  @override
  int run(Map<String, int> registers) {
    registers[to] = intFrom ?? registers[strFrom]!;
    return 1;
  }
}

class inc extends Instruction {
  final String register;
  inc(this.register);

  @override
  int run(Map<String, int> registers) {
    registers.increment(register);
    return 1;
  }
}

class dec extends Instruction {
  final String register;
  dec(this.register);

  @override
  int run(Map<String, int> registers) {
    registers.increment(register, -1);
    return 1;
  }
}

class jnz extends Instruction {
  final int? intCheck;
  final String strCheck;
  final int intOffset;
  jnz(String check, String offset)
    : intCheck = int.tryParse(check),
      strCheck = check,
      intOffset = int.parse(offset);

  @override
  int run(Map<String, int> registers) {
    if (intCheck != null) {
      return (intCheck != 0) ? intOffset : 1;
    } else {
      return registers[strCheck]! != 0 ? intOffset : 1;
    }
  }
}
