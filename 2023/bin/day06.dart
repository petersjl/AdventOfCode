// ignore_for_file: dead_code

import 'package:utils/algorithms.dart';
import 'package:utils/dart_utils.dart';
import 'package:utils/data_structures.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day06.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = ({List<int> times, List<int> distances});

InputType parseInput(String input) {
  var lines = input.splitNewLine();
  final timeStrings = lines[0].splitWhitespace()..removeAt(0);
  final times = timeStrings.map((str) => int.parse(str)).toList();
  final distanceStrings = lines[1].splitWhitespace()..removeAt(0);
  final distances = distanceStrings.map((str) => int.parse(str)).toList();
  return (times: times, distances: distances);
}

String solvePart1(InputType input) {
  final times = input.times;
  final distances = input.distances;
  if (times.length != distances.length) {
    throw Exception("Times and distances must have the same length");
  }
  List<int> winCounts = [];
  for (int i = 0; i < times.length; i++) {
    winCounts.add(getWinCount(times[i], distances[i]));
  }
  return winCounts.reduce((a, b) => a * b).toString();
}

String solvePart2(InputType input) {
  final times = input.times;
  final distances = input.distances;
  final time = int.parse(times.map((ele) => ele.toString()).join());
  final distance = int.parse(distances.map((ele) => ele.toString()).join());
  return getWinCount(time, distance).toString();
}

int getWinCount(int time, int distance) {
  final someWin = getSomeWin(time, distance);
  final firstWin = binarySearchInt((index) {
    var traveled = index * (time - index);
    var lessTraveled = (index - 1) * (time - (index - 1));
    if (traveled > distance && lessTraveled <= distance) {
      return 0;
    } else if (traveled > distance && lessTraveled > distance) {
      return 1;
    } else {
      return -1;
    }
  }, end: someWin);
  final lastWin = binarySearchInt((index) {
    var traveled = index * (time - index);
    var moreTraveled = (index + 1) * (time - (index + 1));
    if (traveled > distance && (moreTraveled <= distance || index == time)) {
      return 0;
    } else if (traveled > distance && moreTraveled > distance) {
      return -1;
    } else {
      return 1;
    }
  }, start: someWin);
  return lastWin - firstWin + 1;
}

int getSomeWin(int time, int distance) {
  Queue<int> queue = Queue();
  queue.push(time ~/ 2);
  while (!queue.isEmpty) {
    final current = queue.pop();
    final traveled = current * (time - current); // speed * time traveling
    if (traveled >= distance) {
      return current;
    }
    if (current == 0 || current == time) {
      continue;
    }
    queue.push(current ~/ 2);
    queue.push(current + (time - current) ~/ 2);
  }
  throw Exception("No wins found for time $time and distance $distance");
}
