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
  var inputP2 = parseInputPart2(rawInput);

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

typedef InputType = (List<List<int>> numberLines, List<String> operations);

InputType parseInput(String input) {
  var lines = input.splitNewLine();
  var numberLines = <List<int>>[];
  var operations = <String>[];
  for (var line in lines) {
    var trimmed = line.trim();
    if (['+', '*'].contains(trimmed[0])) {
      operations = trimmed.splitWhitespace();
    } else {
      var strNums = trimmed.splitWhitespace();
      numberLines.add(strNums.map(int.parse).toList());
    }
  }
  return (numberLines, operations);
}

InputType parseInputPart2(String input) {
  var lines = input.splitNewLine();
  var operations = lines.removeLast().splitWhitespace();
  var numberLines = <List<int>>[];
  var currentNums = <int>[];
  for (int col = 0; col < lines[0].length; col++) {
    var str = new StringBuffer();
    for (int row = 0; row < lines.length; row++) {
      str.write(lines[row][col]);
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
  return (numberLines, operations);
}

String solvePart1(InputType input) {
  var (numberLines, operations) = input;
  var total = 0;
  //col
  for (int i = 0; i < numberLines[0].length; i++) {
    var local = numberLines[0][i];
    var op = operations[i];
    // row
    for (int j = 1; j < numberLines.length; j++) {
      if (op == '+') {
        local += numberLines[j][i];
      } else if (operations[i] == '*') {
        local *= numberLines[j][i];
      }
    }
    total += local;
  }
  return total.toString();
}

String solvePart2(InputType input) {
  var (numberLines, operations) = input;
  var total = 0;

  for (int i = 0; i < numberLines.length; i++) {
    var mult = operations[i] == '*';
    total += numberLines[i].fold(
      mult ? 1 : 0,
      (mult ? (a, b) => a * b : (a, b) => a + b),
    );
  }
  return total.toString();
}
