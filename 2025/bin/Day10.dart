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
  return "";
}

int getMinJoltPresses(Machine machine) {
  final empty = List.generate(machine.joltages.length, (i) => 0);
  return getJoltPresses(machine.buttons, empty, machine.joltages, {});
  final q = Queue<(int, List<int>, List<int>)>()
    ..push((
      0,
      List.generate(machine.joltages.length, (i) => 0),
      machine.joltages,
    ));
  while (!q.isEmpty) {
    var (presses, jolts, target) = q.pop();
    for (final button in machine.buttons) {
      final newJolts = getNewJoltages(button, jolts);
      var check = compare(newJolts, target);
      if (check == 0) return presses + 1;
      if (check == 1) {
        print('jolts too big');
        continue;
      }
      if (shareParity(newJolts, target)) {
        final newTargets = getNewTargets(newJolts, target);
      }
      q.push((presses + 1, newJolts, target));
    }
  }
  throw Exception('Presses not found');
}

int getJoltPresses(
  List<int> buttons,
  List<int> current,
  List<int> target,
  Map<(int, int), int> memo,
) {
  print('$current : $target');
  final check = compare(current, target);
  if (check == 0) return 1;
  if (check == 1) return -1;
  final key = (hashIntList(current), hashIntList(target));
  if (memo.containsKey(key)) return memo[key]!;
  var lowest = 0x7FFFFFFFFFFFFFF; // MAX_INT
  for (final button in buttons) {
    final newJoltages = getNewJoltages(button, current);
    if (shareParity(newJoltages, target)) {
      final newTargets = getNewTargets(button, target);
      var result = getJoltPresses(buttons, newJoltages, newTargets, memo);
      if (result == -1) continue;
      result = (result * 2) + 1;
      lowest = min(result, lowest);
    } else {
      var result = getJoltPresses(buttons, newJoltages, target, memo);
      if (result == -1) continue;
      lowest = min(result + 1, lowest);
    }
  }
  memo[key] = lowest;
  print(lowest);
  return lowest;
}

int compare(List<int> a, List<int> b) {
  var allEqual = true;
  for (int i = 0; i < a.length; i++) {
    if (a[i] > b[i]) return 1;
    if (a[i] != b[i]) {
      allEqual = false;
    }
  }
  return allEqual ? 0 : -1;
}

bool shareParity(List<int> current, List<int> target) {
  for (int i = 0; i < current.length; i++) {
    if ((current[i] % 2) != (target[i] % 2)) {
      return false;
    }
  }
  return true;
}

List<int> getNewTargets(int button, List<int> target) {
  final newJolts = List<int>.from(target);
  var i = 0;
  while (button >> i != 0) {
    if (button >> i & 1 == 1) {
      newJolts[i] = (newJolts[i] - 1) ~/ 2;
    }
    i++;
  }
  return newJolts;
}

List<int> getNewJoltages(int button, List<int> jolts) {
  final newJolts = List<int>.from(jolts);
  var i = 0;
  while (button >> i != 0) {
    newJolts[i] += (button >> i & 1);
    i++;
  }
  return newJolts;
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
