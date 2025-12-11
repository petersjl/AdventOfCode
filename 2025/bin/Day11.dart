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
      paths += countPaths(nextMachine, map, seen, memo);
    } else {
      paths += memo[nextMachine] ?? 0;
    }
  }
  memo[currentMachine] = paths;
  return paths;
}

String solvePart2(InputType input) {
  return countSpecificPaths('svr', input, {}, {}).toString();
}

int countSpecificPaths(
  String currentMachine,
  InputType map,
  Set<(String, bool, bool)> seen,
  Map<(String, bool, bool), int> memo, [
  bool seenFFT = false,
  bool seenDAC = false,
]) {
  var paths = 0;
  for (final nextMachine in map[currentMachine]!) {
    if (nextMachine == 'out') {
      memo[(currentMachine, seenFFT, seenDAC)] = (seenFFT && seenDAC) ? 1 : 0;
      return memo[(currentMachine, seenFFT, seenDAC)]!;
    }
    if (seen.add((
      nextMachine,
      seenFFT || nextMachine == 'fft',
      seenDAC || nextMachine == 'dac',
    ))) {
      if (nextMachine == 'fft') print('Seen fft${seenDAC ? " and dac" : ""}');
      if (nextMachine == 'dac') print('Seen dac${seenFFT ? " and fft" : ""}');
      paths += countSpecificPaths(
        nextMachine,
        map,
        seen,
        memo,
        seenFFT || nextMachine == 'fft',
        seenDAC || nextMachine == 'dac',
      );
    } else {
      paths += memo[(nextMachine, seenFFT, seenDAC)] ?? 0;
    }
  }
  memo[(currentMachine, seenFFT, seenDAC)] = paths;
  return paths;
}
