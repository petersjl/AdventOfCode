// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day19.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = (Map<String, List<String>>, List<String>);

InputType parseInput(String input) {
  Map<String, List<String>> towels = {};
  var parts = input.splitDoubleNewLine();
  parts[0]
      .split(', ')
      .forEach(
        (towel) => towels.update(
          towel[0],
          (group) => group..add(towel),
          ifAbsent: () => [towel],
        ),
      );
  return (towels, parts[1].splitNewLine());
}

int findViablePatterns(
  Map<String, List<String>> towels,
  List<String> patterns,
) {
  int count = 0;
  for (var pattern in patterns) {
    if (makeAllPatterns(towels, pattern) > 0) count++;
  }
  return count;
}

int findAllPatterns(Map<String, List<String>> towels, List<String> patterns) {
  int count = 0;
  for (var pattern in patterns) {
    count += makeAllPatterns(towels, pattern);
  }
  return count;
}

int makeAllPatterns(
  Map<String, List<String>> towels,
  String pattern, [
  int pos = 0,
  Map<int, int>? seen,
]) {
  if (pos == pattern.length) return 1;

  seen = seen ?? {};
  var check = seen[pos];
  if (check != null) return check;

  int count = 0;
  var possibilites = getAllPossibilities(towels, pattern, pos);
  for (var possibility in possibilites) {
    count += makeAllPatterns(towels, pattern, possibility, seen);
  }
  seen[pos] = count;
  return count;
}

List<int> getAllPossibilities(
  Map<String, List<String>> towels,
  String pattern,
  int pos,
) {
  if (towels[pattern[pos]] == null) return [];
  List<int> newFinds = [];
  for (var towel in towels[pattern[pos]]!) {
    if (pos + towel.length > pattern.length) continue;
    var subs = pattern.substring(pos, pos + towel.length);
    if (subs == towel) newFinds.add(pos + towel.length);
  }
  return newFinds;
}

String solvePart1(InputType input) {
  var (towels, patterns) = input;
  return findViablePatterns(towels, patterns).toString();
}

String solvePart2(InputType input) {
  var (towels, patterns) = input;
  return findAllPatterns(towels, patterns).toString();
}
