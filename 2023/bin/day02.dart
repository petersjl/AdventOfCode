// ignore_for_file: dead_code

import 'dart:math';

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day02.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = List<Game>;

InputType parseInput(String input) {
  return input.splitNewLine().map((line) {
    var parts = line.trim().split(': ');
    var id = int.parse(parts[0].split(' ')[1]);
    var hands = parts[1].split('; ').map((newHand) {
      var cubeCounts = newHand.split(', ');
      var hand = Hand();
      for (var cubeCount in cubeCounts) {
        var cubeParts = cubeCount.split(' ');
        var count = int.parse(cubeParts[0]);
        switch (cubeParts[1]) {
          case 'red':
            hand.red = count;
          case 'green':
            hand.green = count;
          case 'blue':
            hand.blue = count;
          default:
            throw Exception('Unknown color found: ${cubeParts[1]}');
        }
      }
      return hand;
    }).toList();
    return Game(id, hands);
  }).toList();
}

class Hand {
  int red, green, blue;
  Hand() : this.red = 0, this.green = 0, this.blue = 0;
}

class Game {
  int id;
  List<Hand> hands;
  Game(this.id, this.hands);
}

String solvePart1(InputType input) {
  var maxCubes = (red: 12, green: 13, blue: 14);
  int idSum = 0;
  for (var game in input) {
    if (game.hands.any(
      (hand) =>
          hand.red > maxCubes.red ||
          hand.green > maxCubes.green ||
          hand.blue > maxCubes.blue,
    ))
      continue;
    idSum += game.id;
  }
  return idSum.toString();
}

String solvePart2(InputType input) {
  return "";
}
