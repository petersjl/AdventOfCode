// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day22.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = List<int>;

InputType parseInput(String input) {
  return input.splitNewLine().map((line) => int.parse(line)).toList();
}

int getNextSecret(int current) {
  current ^= current * 64;
  current = current & 16777215;
  current ^= current ~/ 32;
  current = current & 16777215;
  current ^= current * 2048;
  current = current & 16777215;
  return current;
}

int getNthSecret(int start, int n) {
  for (int i = 0; i < n; i++) {
    start = getNextSecret(start);
  }
  return start;
}

String solvePart1(InputType input) {
  int total = 0;
  for (var number in input) {
    total += getNthSecret(number, 2000);
  }
  return total.toString();
}

class Profit {
  (int, int, int, int) changes;
  int count;

  Profit(List<int> listChanges, this.count)
    : changes = (
        listChanges[0],
        listChanges[1],
        listChanges[2],
        listChanges[3],
      );

  @override
  int get hashCode => changes.hashCode;

  @override
  operator ==(Object other) {
    if (other is! Profit) return false;
    return hashCode == other.hashCode;
  }
}

Set<Profit> getProfits(int start, int n) {
  int secret = start;
  Set<Profit> profits = {};
  List<int> changes = [];
  int previousPrice = secret % 10;
  int i = 0;
  for (; i < 4; i++) {
    secret = getNextSecret(secret);
    var newPrice = secret % 10;
    changes.add(newPrice - previousPrice);
    previousPrice = newPrice;
  }
  profits.add(Profit(changes, previousPrice));
  for (; i < n; i++) {
    secret = getNextSecret(secret);
    var newPrice = secret % 10;
    changes.add(newPrice - previousPrice);
    changes.removeAt(0);
    profits.add(Profit(changes, newPrice));
    previousPrice = newPrice;
  }
  return profits;
}

String solvePart2(InputType input) {
  Map<(int, int, int, int), int> allProfits = {};
  for (var start in input) {
    var profits = getProfits(start, 2000);
    for (var profit in profits) {
      if (profit.count > 0) allProfits.increment(profit.changes, profit.count);
    }
  }
  int maxCount = 0;
  for (var count in allProfits.values) {
    if (count > maxCount) maxCount = count;
  }
  return maxCount.toString();
}
