// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day01.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

List<Pair<int, int>> parseInput(String input) {
  return input.splitNewLine().map((line) {
    var parts = line.splitWhitespace();
    return new Pair(int.parse(parts[0]), int.parse(parts[1]));
  }).toList();
}

String solvePart1(List<Pair<int, int>> input) {
  var left_nums = input.map((element) => element.first).toList();
  var right_nums = input.map((element) => element.second).toList();
  left_nums.sort();
  right_nums.sort();
  int dist = 0;
  for (int i = 0; i < left_nums.length; i++) {
    dist += (right_nums[i] - left_nums[i]).abs();
  }
  return dist.toString();
}

String solvePart2(List<Pair<int, int>> input) {
  var left_nums = input.map((element) => element.first).toList();
  var right_nums = input.map((element) => element.second).toList();
  var counts = new Map<int, int>();
  right_nums.forEach((number) => counts.increment(number));
  var score = left_nums.fold(0, (soFar, number) {
    return soFar + (number * (counts[number] ?? 0));
  });
  return score.toString();
}
