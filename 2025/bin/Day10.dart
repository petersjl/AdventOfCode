// ignore_for_file: dead_code

import 'dart:collection';
import 'dart:math';

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
  final seen = HashSet<int>()..add(0);
  while (!q.isEmpty) {
    final (state, presses) = q.pop();
    for (final button in machine.buttons) {
      var pressed = state ^ button;
      if (pressed == machine.expected) {
        return presses + 1;
      } else if (seen.add(pressed)) {
        q.push((pressed, presses + 1));
      }
    }
  }
  throw Exception('Presses not found');
}

String solvePart2(InputType input) {
  var total = 0;
  for (final machine in input) {
    final presses = getMinJoltPresses(machine);
    total += presses;
  }
  return total.toString();
}

int getMinJoltPresses(Machine machine) {
  return getJoltPresses(machine.buttons, machine.joltages, {});
}

const BIG_INT = 1000000;

int getJoltPresses(List<int> buttons, List<int> target, Map<int, int> memo) {
  // Matched
  if (target.every((val) => val == 0)) return 0;
  // Missed
  if (target.any((val) => val < 0)) return BIG_INT;
  // Check cache
  final key = hashIntList(target);
  if (memo.containsKey(key)) return memo[key]!;

  // Find next step
  var lowest = BIG_INT;
  for (final pressed in getPressesWithParity(buttons, target)) {
    final addedJolts = pressButtons(pressed, target.length);
    final newTarget = getNewTargets(addedJolts, target);
    var presses =
        pressed.length + (2 * getJoltPresses(buttons, newTarget, memo));
    lowest = min(lowest, presses);
  }
  memo[key] = lowest;
  return lowest;
}

List<List<int>> getPressesWithParity(List<int> buttons, List<int> targets) {
  return _getPressesWithParity(buttons, targets, []);
}

List<List<int>> _getPressesWithParity(
  List<int> buttons,
  List<int> targets,
  List<int> current,
) {
  if (buttons.length == 0) {
    final jolts = pressButtons(current, targets.length);
    if (shareParity(jolts, targets)) {
      return [current];
    } else {
      return [];
    }
  }
  final List<List<int>> allPresses = [];
  allPresses.addAll(
    _getPressesWithParity(buttons.sublist(1), targets, current),
  );
  allPresses.addAll(
    _getPressesWithParity(
      buttons.sublist(1),
      targets,
      List.from(current)..add(buttons[0]),
    ),
  );
  return allPresses;
}

List<int> pressButtons(List<int> buttons, int size) {
  final jolts = List.generate(size, (i) => 0);
  for (final button in buttons) {
    var i = 0;
    while (button >> i != 0) {
      jolts[i] += (button >> i & 1);
      i++;
    }
  }
  return jolts;
}

bool shareParity(List<int> current, List<int> target) {
  for (int i = 0; i < current.length; i++) {
    if ((current[i] % 2) != (target[i] % 2)) {
      return false;
    }
  }
  return true;
}

List<int> getNewTargets(List<int> jolts, List<int> target) {
  final newTargets = List<int>.from(target);
  for (int i = 0; i < target.length; i++) {
    newTargets[i] = (target[i] - jolts[i]) ~/ 2;
  }
  return newTargets;
}

int hashIntList(List<int> list) {
  const int fnvOffset = 0x811C9DC5; // 2166136261
  const int fnvPrime = 0x01000193; // 16777619
  var h = fnvOffset;
  for (var x in list) {
    if (x < 0) {
      x = 0;
    } else if (x > 1000) {
      x = 1000;
    }
    h ^= x; // FNV-1a xor with clamped value
    h = (h * fnvPrime) & 0xFFFFFFFF; // 32-bit wrap
  }
  return h & 0x7FFFFFFF; // keep positive
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
