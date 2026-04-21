// ignore_for_file: dead_code

import 'dart:math';

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day04.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = List<Card>;

InputType parseInput(String input) {
  return input.splitNewLine().map((line) {
    var parts = line.split(new RegExp(r'[:|]'));
    var winningNumbers = parts[1]
        .trim()
        .splitWhitespace()
        .map(int.parse)
        .toList();
    var myNumbers = parts[2].trim().splitWhitespace().map(int.parse).toList();
    return Card(winningNumbers, myNumbers);
  }).toList();
}

String solvePart1(InputType input) {
  num total = 0;
  for (var card in input) {
    var wins = card.getWins();
    if (wins.isEmpty) continue;
    total += pow(2, wins.length - 1);
  }
  return total.toString();
}

String solvePart2(InputType input) {
  List<int> cardCounts = List.generate(input.length, (num) => 1);
  for (int i = 0; i < input.length; i++) {
    var wins = input[i].getWins();
    if (wins.isEmpty) continue;
    for (int j = 0; j < wins.length; j++) {
      cardCounts[i + j + 1] += cardCounts[i];
    }
  }
  return cardCounts.reduce((a, b) => a + b).toString();
}

class Card {
  final List<int> winningNumbers;
  final List<int> myNumbers;
  Card(this.winningNumbers, this.myNumbers);

  List<int> getWins() {
    return myNumbers.where((num) => winningNumbers.contains(num)).toList();
  }
}
