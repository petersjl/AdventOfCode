// ignore_for_file: dead_code

import 'package:utils/algorithms/bfs.dart' show bfsAllPairs;
import 'package:utils/algorithms/traveling_salesman.dart'
    show travelingSalesman;
import 'package:utils/dart_utils.dart';
import 'package:utils/data_structures.dart' show Grid;

void main() {
  var rawInput = Utils.readToString("../inputs/day24.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = (Point, Set<Point>, Grid<bool>);

InputType parseInput(String input) {
  var lines = input.splitNewLine();
  Set<Point> points = {};
  Grid<bool> grid = Grid((x, y) => false, lines[0].length, lines.length);
  Point? start;
  for (int i = 0; i < lines.length; i++) {
    for (int j = 0; j < lines[i].length; j++) {
      if (lines[i][j] == '#') {
        grid.set(j, i, true);
      } else {
        var num = int.tryParse(lines[i][j]);
        if (num != null) {
          var point = Point(j, i);
          points.add(point);
          if (num == 0) {
            start = point;
          }
        }
      }
    }
  }
  if (start == null) {
    throw Exception("No starting point (0) found in input.");
  }
  return (start, points, grid);
}

String solvePart1(InputType input) {
  var (start, points, grid) = input;
  var distances = bfsAllPairs(grid, points);
  var result = travelingSalesman(distances, start);
  return result.totalDistance.toString();
}

String solvePart2(InputType input) {
  var (start, points, grid) = input;
  var distances = bfsAllPairs(grid, points);
  var result = travelingSalesman(distances, start, returnToStart: true);
  return result.totalDistance.toString();
}
