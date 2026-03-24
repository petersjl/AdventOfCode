// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day21.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = List<Command>;

InputType parseInput(String input) {
  return input.splitNewLine().map((line) => parseCommand(line)).toList();
}

Command parseCommand(String line) {
  final parts = line.split(" ");
  switch (parts[0]) {
    case "swap":
      if (parts[1] == "position") {
        return SwapPosition(int.parse(parts[2]), int.parse(parts[5]));
      } else {
        return SwapLetter(parts[2], parts[5]);
      }
    case "rotate":
      if (parts[1] == "left") {
        return RotateCount(true, int.parse(parts[2]));
      } else if (parts[1] == "right") {
        return RotateCount(false, int.parse(parts[2]));
      } else {
        return RotateLetter(parts[6]);
      }
    case "reverse":
      return ReversePositions(int.parse(parts[2]), int.parse(parts[4]));
    case "move":
      return MovePosition(int.parse(parts[2]), int.parse(parts[5]));
    default:
      throw Exception("Unknown command: ${parts[0]}");
  }
}

String solvePart1(InputType input, [String initial = "abcdefgh"]) {
  final password = initial.split("");
  for (final command in input) {
    command.apply(password);
  }
  return password.join();
}

String solvePart2(InputType input) {
  return "";
}

abstract class Command {
  void apply(List<String> password);
}

class SwapPosition implements Command {
  final int x;
  final int y;

  SwapPosition(this.x, this.y);

  @override
  void apply(List<String> password) {
    final temp = password[x];
    password[x] = password[y];
    password[y] = temp;
  }
}

class SwapLetter implements Command {
  final String x;
  final String y;

  SwapLetter(this.x, this.y);

  @override
  void apply(List<String> password) {
    for (int i = 0; i < password.length; i++) {
      if (password[i] == x) {
        password[i] = y;
      } else if (password[i] == y) {
        password[i] = x;
      }
    }
  }
}

class RotateCount extends Command {
  final bool left;
  final int count;

  RotateCount(this.left, this.count);

  @override
  void apply(List<String> password) {
    final effectiveCount = count % password.length;
    List<String> rotated;
    if (left) {
      rotated =
          password.sublist(effectiveCount) +
          password.sublist(0, effectiveCount);
    } else {
      rotated =
          password.sublist(password.length - effectiveCount) +
          password.sublist(0, password.length - effectiveCount);
    }
    for (int i = 0; i < password.length; i++) {
      password[i] = rotated[i];
    }
  }
}

class RotateLetter extends Command {
  final String x;

  RotateLetter(this.x);

  @override
  void apply(List<String> password) {
    final index = password.indexOf(x);
    int count = 1 + index;
    if (index >= 4) count++;
    final effectiveCount = count % password.length;
    List<String> rotated =
        password.sublist(password.length - effectiveCount) +
        password.sublist(0, password.length - effectiveCount);
    for (int i = 0; i < password.length; i++) {
      password[i] = rotated[i];
    }
  }
}

class ReversePositions extends Command {
  final int x;
  final int y;

  ReversePositions(this.x, this.y);

  @override
  void apply(List<String> password) {
    final sublist = password.sublist(x, y + 1).reversed.toList();
    for (int i = x; i <= y; i++) {
      password[i] = sublist[i - x];
    }
  }
}

class MovePosition extends Command {
  final int x;
  final int y;

  MovePosition(this.x, this.y);

  @override
  void apply(List<String> password) {
    final char = password.removeAt(x);
    password.insert(y, char);
  }
}
