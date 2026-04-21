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
      var number = int.tryParse(char);
      if (number != null) {
        var end = line.indexOf(new RegExp(r'[^0-9]'), x);
        if (end == -1) end = line.length;
        var strNum = line.substring(x, end);
        var num = int.parse(strNum);
        for (int i = x; i < end; i++) {
          grid.set(i, y, num);
        }
        x += strNum.length - 1;
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
  return "";
}
