// ignore_for_file: dead_code

import 'dart:math';

import 'package:utils/algorithms.dart';
import 'package:utils/dart_utils.dart';
import 'package:utils/data_structures.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day22.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = List<DataNode>;

InputType parseInput(String input) {
  var lines = input.splitNewLine().sublist(2);
  return lines.map((line) {
    var data = RegExp(r".*x(\d+)-y(\d+)\s+(\d+)T\s+(\d+)T.*").firstMatch(line);
    if (data == null) {
      throw Exception("Invalid line: $line");
    }
    return DataNode(
      int.parse(data.group(1)!),
      int.parse(data.group(2)!),
      int.parse(data.group(3)!),
      int.parse(data.group(4)!),
    );
  }).toList();
}

String solvePart1(InputType input) {
  return input.indexed.fold(0, (cur, entry) {
    var (index, node) = entry;
    int count = 0;
    for (int i = index + 1; i < input.length; i++) {
      final aFitsB = input[i].used > 0 && node.available >= input[i].used;
      final bFitsA = node.used > 0 && input[i].available >= node.used;
      if (aFitsB || bFitsA) {
        count++;
      }
    }
    return cur + count;
  }).toString();
}

String solvePart2(InputType input) {
  int maxX = 0;
  int maxY = 0;
  DataNode? emptyNode;
  // Find the dimensions of the grid and the empty node
  for (var node in input) {
    if (node.y == 0) {
      maxX = max(maxX, node.x);
    }
    if (node.x == 0) {
      maxY = max(maxY, node.y);
    }
    if (node.used == 0) {
      emptyNode = node;
    }
  }
  if (emptyNode == null) {
    throw Exception("No empty node found");
  }
  var walls = Grid<bool>((x, y) => false, maxX + 1, maxY + 1);
  for (var node in input) {
    if (node.used > 200) {
      walls.set(node.x, node.y, true);
    }
  }
  // Put a hole right in front of the goal data, then move it left until it's in the top left corner
  Point holeDestination = Point(maxX - 1, 0);
  // Get the steps to place the hole while dodging walls
  List<Point>? toHole = aStar(
    walls,
    Point(emptyNode.x, emptyNode.y),
    holeDestination,
    (a) => Utils.ManhattanDist(a, holeDestination),
  );
  // If there is no path to the hole, then there is no solution
  if (toHole == null) {
    throw Exception("No path found to hole destination");
  }
  int steps = toHole.length - 1;
  // Move the goal data into the hole
  steps++;
  // Move the goal data left until it's in the top left corner
  // which takes 5 steps per move of the goal data
  steps += 5 * (maxX - 1);
  return steps.toString();
}

class DataNode {
  int x, y;
  int size, used, available;

  DataNode(this.x, this.y, this.size, this.used) : available = size - used;
}
