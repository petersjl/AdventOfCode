// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day01.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

List<List<int>> parseInput(String input) {
  return input
      .splitNewLine()
      .map(
        (line) =>
            line.splitWhitespace().map((number) => int.parse(number)).toList(),
      )
      .toList();
}

bool checkLineSafety(List<int> line) {
  int comparator = line[0].compareTo(line[1]);
  for (int i = 0; i < line.length - 1; i++) {
    if (line[i].compareTo(line[i + 1]) != comparator) return false;
    int diff = (line[i] - line[i + 1]).abs();
    if (diff < 1 || 3 < diff) return false;
  }
  return true;
}

bool checkLineSafetyWithFail(List<int> line) {
  if (checkLineSafety(line)) return true;
  for (int i = 0; i < line.length; i++) {
    if (checkLineSafety(List.of(line)..removeAt(i))) return true;
  }
  return false;
}

String solvePart1(List<List<int>> input) {
  int safeLines = 0;
  input.forEach((line) {
    if (checkLineSafety(line)) safeLines += 1;
  });
  return safeLines.toString();
}

String solvePart2(List<List<int>> input) {
  int safeLines = 0;
  input.forEach((line) {
    if (checkLineSafetyWithFail(line)) safeLines += 1;
  });
  return safeLines.toString();
}
