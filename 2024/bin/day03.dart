// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day03.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

List<String> parseInput(String input) {
  return input.splitNewLine();
}

final RegExp mulExp = new RegExp(r"mul\(\d{1,3},\d{1,3}\)");
final RegExp cutParens = new RegExp(r"\(|\)");

int getLineMultiplication(String line) {
  int total = 0;
  var matches = mulExp.allMatches(line);
  for (var match in matches) {
    var numbers = match[0]!.split(cutParens)[1];
    var pair = numbers.split(',');
    total += (int.parse(pair[0]) * int.parse(pair[1]));
  }
  return total;
}

List<String> getAllDoBlocks(String line) {
  // First split on the do() command
  var doSplits = line.split("do()");
  // If we start with a do remove the empty starting element
  if (doSplits[0].length == 0) doSplits.removeAt(0);
  // Split on don't() and take the left part so it's after
  // a do and before a don't
  return doSplits.listMap((part) => part.split("don't()")[0]);
}

String solvePart1(List<String> input) {
  int total = input.collect(
    0,
    (run, line) => run + getLineMultiplication(line),
  );
  return total.toString();
}

String solvePart2(List<String> input) {
  String allInput = input.collect("", (run, line) => run + line);
  List<String> allDoBlocks = getAllDoBlocks(allInput);
  int total = allDoBlocks.collect(
    0,
    (run, line) => run + getLineMultiplication(line),
  );
  return total.toString();
}
