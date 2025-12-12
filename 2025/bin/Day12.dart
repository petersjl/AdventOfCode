// ignore_for_file: dead_code

import 'package:utils/DartUtils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/Day12.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef Placement = ((int, int), List<int>);
typedef InputType = (List<int>, List<Placement>);

InputType parseInput(String input) {
  final groups = input.splitDoubleNewLine();
  var presents = <int>[];
  for (int i = 0; i < 6; i++) {
    presents.add(getPresentArea(groups[i]));
  }
  final rows = groups[6].splitNewLine();
  List<((int, int), List<int>)> placements = [];
  for (var row in rows) {
    placements.add(parsePlacement(row));
  }
  return (presents, placements);
}

int getPresentArea(String shape) {
  final rows = shape.splitNewLine();
  rows.removeAt(0); // remove header
  return rows.fold<int>(0, (sum, row) {
    return sum + row.characters.count((c) => c == '#');
  });
}

Placement parsePlacement(String line) {
  final parts = line.split(': ');
  final coords = parts[0].split('x');
  final x = int.parse(coords[0]);
  final y = int.parse(coords[1]);
  final presentCounts = parts[1]
      .split(' ')
      .map((count) => int.parse(count))
      .toList();
  return ((x, y), presentCounts);
}

String solvePart1(InputType input) {
  final (presents, placements) = input;
  var fittingPlacements = 0;
  for (var placement in placements) {
    if (doPresentsFit(presents, placement)) {
      fittingPlacements++;
    }
  }
  return fittingPlacements.toString();
}

bool doPresentsFit(List<int> presents, Placement placement) {
  final ((x, y), presentCounts) = placement;
  var usedArea = 0;
  for (int i = 0; i < presents.length; i++) {
    usedArea += presentCounts[i] * presents[i];
  }
  return usedArea <= x * y;
}

String solvePart2(InputType input) {
  return "";
}
