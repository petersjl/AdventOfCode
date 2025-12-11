// ignore_for_file: dead_code

import 'package:utils/DartUtils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/Day11.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = Map<String, List<String>>;

InputType parseInput(String input) {
  return Map.fromEntries(
    input.splitNewLine().map((line) {
      final parts = line.split(': ');
      return MapEntry(parts[0], parts[1].split(' '));
    }),
  );
}

String solvePart1(InputType input) {
  return countPaths('you', input, {}, {}).toString();
}

int countPaths(
  String currentMachine,
  InputType map,
  Set<String> seen,
  Map<String, int> memo,
) {
  var paths = 0;
  for (final nextMachine in map[currentMachine]!) {
    if (nextMachine == 'out') {
      memo[currentMachine] = 1;
      return 1;
    }
    if (seen.add(nextMachine)) {
      final subPaths = countPaths(nextMachine, map, seen, memo);
      paths += subPaths;
    } else {
      paths += memo[nextMachine] ?? 0;
    }
  }
  memo[currentMachine] = paths;
  return paths;
}

String solvePart2(InputType input) {
  return "";
}
