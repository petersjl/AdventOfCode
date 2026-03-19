// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day07.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = List<({List<String> inside, List<String> outside})>;

InputType parseInput(String input) {
  return input.splitNewLine().map((line) {
    var parts = line.split(RegExp(r'[\[\]]'));
    List<String> inside = [];
    List<String> outside = [];
    for (int i = 0; i < parts.length; i++) {
      if (i % 2 == 0) {
        outside.add(parts[i]);
      } else {
        inside.add(parts[i]);
      }
    }
    return (inside: inside, outside: outside);
  }).toList();
}

String solvePart1(InputType input) {
  int count = 0;
  for (var line in input) {
    if (hasAbba(line.outside) && !hasAbba(line.inside)) {
      count++;
    }
  }
  return count.toString();
}

String solvePart2(InputType input) {
  return "";
}

bool hasAbba(List<String> parts) {
  return parts.any(
    (part) => part.contains(RegExp(r'([a-z])((?!\1)[a-z])\2\1')),
  );
}
