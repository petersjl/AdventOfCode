// ignore_for_file: dead_code

import 'package:utils/DartUtils.dart';

void main() {
  bool runP1 = true;
  bool runP2 = true;
  String solutionP1 = "", solutionP2 = "";

  var rawInput = Utils.readToString("../inputs/Day06.txt");

  Stopwatch stopwatch = new Stopwatch()..start();
  var inputP1 = parseInput(rawInput);
  var timeParse = stopwatch.elapsed;
  // Parse again for part 2 to allow any mutations,
  // but don't count that time
  stopwatch.stop();
  var inputP2 = parseInput(rawInput);

  stopwatch.start();
  if (runP1) solutionP1 = solvePart1(inputP1);
  var timeP1 = stopwatch.elapsed;
  if (runP2) solutionP2 = solvePart2(inputP2);
  var timeP2 = stopwatch.elapsed;
  stopwatch.stop();

  print('Parse time: ${Utils.timingString(timeParse)}');
  if (runP1)
    print('Part 1 (${Utils.timingString(timeP1 - timeParse)}): ${solutionP1}');
  if (runP2)
    print('Part 2 (${Utils.timingString(timeP2 - timeP1)}): ${solutionP2}');
  print('Ran in ${Utils.timingString(timeP2)}');
}

typedef InputType = (List<String> numberLines, List<String> operations);

InputType parseInput(String input) {
  var lines = input.splitNewLine();
  var operations = (lines.removeLast().trim()).splitWhitespace();
  return (lines, operations);
}

String solvePart1(InputType input) {
  var (numberLines, operations) = input;
  var groups = parsePart1Groups(numberLines);

  return mathGroups(groups, operations).toString();
}

List<List<int>> parsePart1Groups(List<String> input) {
  var groups = <List<int>>[];
  var parsedLines = input
      .map((line) => (line.trim()).splitWhitespace().map(int.parse).toList())
      .toList();
  for (var i = 0; i < parsedLines[0].length; i++) {
    var currentGroup = <int>[];
    for (var line in parsedLines) {
      currentGroup.add(line[i]);
    }
    groups.add(currentGroup);
  }
  return groups;
}

String solvePart2(InputType input) {
  var (numberLines, operations) = input;
  var groups = parsePart2Groups(numberLines);

  return mathGroups(groups, operations).toString();
}

int mathGroups(List<List<int>> groups, List<String> operations) {
  int total = 0;
  for (int i = 0; i < operations.length; i++) {
    var mult = operations[i] == '*';
    total += groups[i].fold(
      mult ? 1 : 0,
      (mult ? (a, b) => a * b : (a, b) => a + b),
    );
  }
  return total;
}

List<List<int>> parsePart2Groups(List<String> input) {
  var numberLines = <List<int>>[];
  var currentNums = <int>[];
  for (int col = 0; col < input[0].length; col++) {
    var str = new StringBuffer();
    for (int row = 0; row < input.length; row++) {
      str.write(input[row][col]);
    }
    var result = str.toString().trim();
    if (result.isEmpty) {
      numberLines.add(currentNums);
      currentNums = <int>[];
    } else {
      currentNums.add(int.parse(result));
    }
  }
  if (currentNums.isNotEmpty) {
    numberLines.add(currentNums);
  }
  input;
  return numberLines;
}
