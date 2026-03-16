// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day12.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = List<String>;

InputType parseInput(String input) {
  return input.splitNewLine();
}

(int, int) fillPlot(
  List<String> gardens,
  List<List<bool>> claimed,
  Point position,
  String char,
) {
  Point farCorner = Point(gardens[0].length, gardens.length);
  Point upPlot = position + Point.up;
  Point downPlot = position + Point.down;
  Point leftPlot = position + Point.left;
  Point rightPlot = position + Point.right;
  claimed[position.y][position.x] = true;

  int area = 1; // Start with the area for this position
  int perimeter = 0;

  for (var plot in [upPlot, downPlot, leftPlot, rightPlot]) {
    // If the plot is in the garden
    if (plot.isInBounds(farCorner)) {
      // and it is part of the same region
      if (gardens[plot.y][plot.x] == char) {
        if (claimed[plot.y][plot.x])
          continue;
        // and hasn't been seen
        else {
          // flood it and add on it's results
          var (addArea, addPerimeter) = fillPlot(gardens, claimed, plot, char);
          area += addArea;
          perimeter += addPerimeter;
        }
      } else {
        // otherwise it's an edge
        perimeter++;
      }
    } else {
      perimeter++;
    }
  }
  return (area, perimeter);
}

String solvePart1(InputType input) {
  List<List<bool>> claimed = List.generate(
    input.length,
    (i) => List.generate(input[0].length, (j) => false),
  );
  int price = 0;
  for (int row = 0; row < input.length; row++) {
    for (int col = 0; col < input[0].length; col++) {
      if (claimed[row][col]) continue;
      var (area, perimeter) = fillPlot(
        input,
        claimed,
        Point(col, row),
        input[row][col],
      );
      // print('${input[row][col]}: area:$area perimeter:$perimeter');
      price += area * perimeter;
    }
  }
  return price.toString();
}

String solvePart2(InputType input) {
  return "";
}
