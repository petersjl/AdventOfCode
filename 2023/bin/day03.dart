// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';
import 'package:utils/data_structures.dart' show SparseGrid;

void main() {
  var rawInput = Utils.readToString("../inputs/day03.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = ({
  SparseGrid<int> grid,
  List<({String symbol, Point position})> symbols,
});

InputType parseInput(String input) {
  var lines = input.splitNewLine();
  var grid = SparseGrid(0);
  var symbols = <({String symbol, Point position})>[];
  for (var y = 0; y < lines.length; y++) {
    var line = lines[y];
    for (var x = 0; x < line.length; x++) {
      var char = line[x];
      if (char == '.') {
        continue;
      }
      if (char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57) {
        // ASCII: '0'=48, '9'=57
        int num = 0;
        int start = x;
        while (x < line.length) {
          int cu = line[x].codeUnitAt(0);
          if (cu < 48 || cu > 57) break;
          num = num * 10 + (cu - 48);
          x++;
        }
        for (int i = start; i < x; i++) {
          grid.set(i, y, num);
        }
        x--;
      } else {
        symbols.add((symbol: char, position: Point(x, y)));
      }
    }
  }
  return (grid: grid, symbols: symbols);
}

String solvePart1(InputType input) {
  int total = 0;
  var grid = input.grid;
  for (var symbol in input.symbols) {
    Set<int> values = {};
    for (var dir in Point.directions) {
      var pos = symbol.position + dir;
      values.add(grid.get(pos.x, pos.y));
    }
    values.forEach((ele) => total += ele);
  }
  return total.toString();
}

String solvePart2(InputType input) {
  int total = 0;
  var grid = input.grid;
  for (var symbol in input.symbols) {
    Set<int> values = {};
    for (var dir in Point.directions) {
      var pos = symbol.position + dir;
      values.add(grid.get(pos.x, pos.y));
    }
    values.remove(0);
    if (values.length != 2) continue;
    total += values.reduce((a, b) => a * b);
  }
  return total.toString();
}
