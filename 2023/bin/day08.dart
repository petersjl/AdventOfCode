// ignore_for_file: dead_code

import 'package:utils/algorithms.dart';
import 'package:utils/dart_utils.dart';

const int _aChar = 65;
const int _zChar = 90;

void main() {
  var rawInput = Utils.readToString("../inputs/day08.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = ({
  List<int> directions,
  List<int> nodes,
  List<int> left,
  List<int> right,
});

InputType parseInput(String input) {
  final parts = input.splitDoubleNewLine();
  final directions = parts[0].split('').map((char) {
    switch (char) {
      case 'L':
        return 0;
      case 'R':
        return 1;
      default:
        throw Exception('Invalid direction character: $char');
    }
  }).toList();

  final rawEdges = <(int from, int left, int right)>[];
  final indexByCode = <int, int>{};
  final nodes = <int>[];

  int indexFor(int code) {
    final existing = indexByCode[code];
    if (existing != null) return existing;
    final next = nodes.length;
    indexByCode[code] = next;
    nodes.add(code);
    return next;
  }

  for (final line in parts[1].splitNewLine()) {
    final fromCode = charsToCode(line.substring(0, 3));
    final leftCode = charsToCode(line.substring(7, 10));
    final rightCode = charsToCode(line.substring(12, 15));
    final from = indexFor(fromCode);
    final leftNode = indexFor(leftCode);
    final rightNode = indexFor(rightCode);
    rawEdges.add((from, leftNode, rightNode));
  }

  final nodeCount = nodes.length;
  final left = List<int>.filled(nodeCount, -1);
  final right = List<int>.filled(nodeCount, -1);

  for (final edge in rawEdges) {
    left[edge.$1] = edge.$2;
    right[edge.$1] = edge.$3;
  }

  return (directions: directions, nodes: nodes, left: left, right: right);
}

int charsToCode(String chars) {
  int code = 0;
  for (int i = 0; i < chars.length; i++) {
    code = code * 100 + chars.codeUnitAt(i);
  }
  return code;
}

// Check if a node code ends with a character
bool endsWithChar(int nodeCode, int charCode) {
  return nodeCode % 100 == charCode;
}

String solvePart1(InputType input) {
  return findSteps(
    input.nodes,
    input.left,
    input.right,
    input.directions,
    input.nodes.indexOf(charsToCode('AAA')),
    targetCode: charsToCode('ZZZ'),
  ).toString();
}

String solvePart2(InputType input) {
  final stepsToZ = input.nodes.indexed
      .where((entry) => endsWithChar(entry.$2, _aChar))
      .map((entry) {
        return findSteps(
          input.nodes,
          input.left,
          input.right,
          input.directions,
          entry.$1,
          suffixChar: _zChar,
        );
      })
      .toList();
  return leastCommonMultiple(stepsToZ).toString();
}

int findSteps(
  List<int> nodes,
  List<int> left,
  List<int> right,
  List<int> directions,
  int startIdx, {
  int? targetCode,
  int? suffixChar,
}) {
  if ((targetCode == null) == (suffixChar == null)) {
    throw ArgumentError('Provide exactly one of targetCode or suffixChar.');
  }

  final bool checkSuffix = suffixChar != null;
  int currentIdx = startIdx;
  int steps = 0;
  int directionIndex = 0;
  final int max = 1 << 30;

  while (steps < max) {
    final node = nodes[currentIdx];
    if (checkSuffix) {
      if (endsWithChar(node, suffixChar)) return steps;
    } else {
      if (node == targetCode) return steps;
    }

    currentIdx = directions[directionIndex] == 0
        ? left[currentIdx]
        : right[currentIdx];

    directionIndex++;
    if (directionIndex == directions.length) directionIndex = 0;
    steps++;
  }

  throw Exception('No path found from start to target');
}
