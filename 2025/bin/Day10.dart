// ignore_for_file: dead_code

import 'package:utils/DartUtils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/Day10.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = List<Machine>;

InputType parseInput(String input) {
  return input.splitNewLine().map((line) {
    var parts = line.splitWhitespace();
    var expectedString = parts.removeAt(0);
    var expected = expectedString
        .substring(1, expectedString.length - 1)
        .split('')
        .map((c) => c == '#')
        .toList();
    var mask = List.generate(
      expected.length,
      (i) => expected[i] ? (1 << i) : 0,
    ).fold(0, (a, b) => a | b);
    List<int> buttons = [];
    while (parts[0][0] == '(') {
      var buttonStr = parts.removeAt(0);
      buttons.add(
        buttonStr
            .substring(1, buttonStr.length - 1)
            .split(',')
            .map(int.parse)
            .fold(0, (a, b) => a | (1 << b)),
      );
    }
    var joltString = parts.removeAt(0);
    var jolts = joltString
        .substring(1, joltString.length - 1)
        .split(',')
        .map(int.parse)
        .toList();

    return Machine(mask, buttons, jolts);
  }).toList();
}

String solvePart1(InputType input) {
  var presses = 0;
  for (final machine in input) {
    presses += getMinPresses(machine);
  }
  return presses.toString();
}

int getMinPresses(Machine machine) {
  // state, presses
  final q = Queue<(int, int)>()..push((0, 0));
  while (!q.isEmpty) {
    final (state, presses) = q.pop();
    for (final button in machine.buttons) {
      var pressed = state ^ button;
      if (pressed == machine.expected) {
        return presses + 1;
      } else {
        q.push((pressed, presses + 1));
      }
    }
  }
  throw Exception('Presses not found');
}

String solvePart2(InputType input) {
  return "";
}

class Machine {
  int expected;
  List<int> buttons;
  List<int> joltages;

  Machine(this.expected, List<int> buttons, List<int> joltages)
    : this.buttons = List.unmodifiable(buttons),
      this.joltages = List.unmodifiable(joltages);
}

class Button {
  List<int> connections;

  Button(this.connections);
}
