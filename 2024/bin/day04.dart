// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day04.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

List<String> parseInput(String input) {
  return input.splitNewLine();
}

const dir_range = [-1, 0, 1];

int checkSpot(List<String> grid, String term, Point position) {
  if (grid[position.y][position.x] != term[0]) return 0;
  int matches = 0;
  for (int row_dir in dir_range) {
    for (int col_dir in dir_range) {
      Point direction = new Point(col_dir, row_dir);
      matches += checkDirection(grid, term, 1, position + direction, direction)
          ? 1
          : 0;
    }
  }
  return matches;
}

bool checkDirection(
  List<String> grid,
  String term,
  int index,
  Point position,
  Point direction,
) {
  if (index == term.length) return true;
  if (position.y < 0 || grid.length <= position.y) return false;
  if (position.x < 0 || grid[0].length <= position.x) return false;
  if (grid[position.y][position.x] != term[index]) return false;
  return checkDirection(grid, term, index + 1, position + direction, direction);
}

String solvePart1(List<String> input) {
  int count = 0;
  for (int row = 0; row < input.length; row++) {
    for (int col = 0; col < input.length; col++) {
      count += checkSpot(input, "XMAS", new Point(col, row));
    }
  }
  return count.toString();
}

bool checkXSpot(List<String> grid, Point position) {
  if (grid[position.y][position.x] != "A") return false;
  var corners = [
    grid[position.y - 1][position.x - 1],
    grid[position.y + 1][position.x - 1],
    grid[position.y + 1][position.x + 1],
    grid[position.y - 1][position.x + 1],
  ];
  if (corners.whereFirst((char) => !(char == "M" || char == "S")) != null)
    return false;
  return corners[0] != corners[2] && corners[1] != corners[3];
}

String solvePart2(List<String> input) {
  int count = 0;
  for (int row = 1; row < input.length - 1; row++) {
    for (int col = 1; col < input.length - 1; col++) {
      count += checkXSpot(input, new Point(col, row)) ? 1 : 0;
    }
  }
  return count.toString();
}
