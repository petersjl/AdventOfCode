// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day01.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = List<String>;

InputType parseInput(String input) {
  return input.splitNewLine();
}

String solvePart1(InputType input) {
  var count = 0;
  for (var line in input) {
    count += findLeftNumber(line) * 10 + findRightNumber(line);
  }
  return count.toString();
}

String solvePart2(InputType input) {
  return "";
}

int findLeftNumber(String line) {
  for (int i = 0; i < line.length; i++) {
    if (numToDigit.containsKey(line[i])) {
      return numToDigit[line[i]]!;
    }
  }
  throw Exception("No digit found in line: $line");
}

int findRightNumber(String line) {
  for (int i = line.length - 1; i >= 0; i--) {
    if (numToDigit.containsKey(line[i])) {
      return numToDigit[line[i]]!;
    }
  }
  throw Exception("No digit found in line: $line");
}

Map<String, int> strToDigit = {
  "one": 1,
  "two": 2,
  "three": 3,
  "four": 4,
  "five": 5,
  "six": 6,
  "seven": 7,
  "eight": 8,
  "nine": 9,
};

Map<String, int> numToDigit = {
  '1': 1,
  '2': 2,
  '3': 3,
  '4': 4,
  '5': 5,
  '6': 6,
  '7': 7,
  '8': 8,
  '9': 9,
};
