// ignore_for_file: dead_code

import 'package:utils/DartUtils.dart';

void main() {
  bool runP1 = true;
  bool runP2 = true;
  String solutionP1 = "", solutionP2 = "";

  var rawInput = Utils.readToString("../inputs/Day03.txt");

  Stopwatch stopwatch = new Stopwatch()..start();
  var input = parseInput(rawInput);
  var timeParse = stopwatch.elapsed;

  if (runP1) solutionP1 = solvePart1(input);
  var timeP1 = stopwatch.elapsed;
  if (runP2) solutionP2 = solvePart2(input);
  var timeP2 = stopwatch.elapsed;
  stopwatch.stop();

  print('Parse time: ${Utils.timingString(timeParse)}');
  if (runP1)
    print('Part 1 (${Utils.timingString(timeP1 - timeParse)}): ${solutionP1}');
  if (runP2)
    print('Part 2 (${Utils.timingString(timeP2 - timeP1)}): ${solutionP2}');
  print('Ran in ${Utils.timingString(timeP2)}');
}

typedef InputType = List<List<int>>;

InputType parseInput(String input) {
  return input.splitNewLine().listMap(
    (line) => line.split('').listMap((e) => int.parse(e)),
  );
}

String solvePart1(InputType input) {
  var joltage = 0;
  for (var row in input) {
    var leftBig = getBigLeft(row);
    var rightBig = getBigRight(row, leftBig);
    joltage += (leftBig.second * 10) + rightBig;
  }
  return joltage.toString();
}

Pair<int, int> getBigLeft(List<int> numbers) {
  var largest = new Pair(0, numbers[0]);
  for (int i = 1; i < numbers.length - 1; i++) {
    if (numbers[i] > largest.second) {
      largest = new Pair(i, numbers[i]);
    }
    if (largest.second == 9) break;
  }
  return largest;
}

int getBigRight(List<int> numbers, Pair<int, int> leftBig) {
  var largest = numbers[leftBig.first + 1];
  for (int i = leftBig.first + 2; i < numbers.length; i++) {
    if (numbers[i] > largest) {
      largest = numbers[i];
    }
    if (largest == 9) break;
  }
  return largest;
}

String solvePart2(InputType input) {
  var joltage = 0;
  for (var row in input) {
    joltage += getPackJoltage(row);
  }
  return joltage.toString();
}

const int NUM_BATTERIES = 12;
int getPackJoltage(List<int> pack) {
  List<int> digits = [];
  var largest = Pair(-1, -1);
  for (int remBatteries = NUM_BATTERIES; remBatteries >= 1; remBatteries--) {
    largest = getBiggestFromStart(pack, largest.first + 1, remBatteries);
    digits.add(largest.second);
    if (remBatteries > 0 && largest.first + remBatteries == pack.length) {
      digits.addAll(pack.sublist(largest.first + 1));
      break;
    }
  }
  var joltage = int.parse(digits.map((e) => e.toString()).join());
  return joltage;
}

Pair<int, int> getBiggestFromStart(List<int> numbers, int start, int fromEnd) {
  var largest = new Pair(start, numbers[start]);
  for (int i = start; i <= numbers.length - fromEnd; i++) {
    if (numbers[i] > largest.second) {
      largest = new Pair(i, numbers[i]);
    }
    if (largest.second == 9) break;
  }
  return largest;
}
