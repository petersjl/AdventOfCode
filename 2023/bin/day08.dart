// ignore_for_file: dead_code

import 'package:utils/algorithms.dart';
import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day08.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = ({List<int> directions, Map<String, List<String>> nodes});

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
  final nodes = parts[1]
      .splitNewLine()
      .map((line) {
        final matches = RegExp(r'(\w\w\w)').allMatches(line);
        if (matches.isEmpty) {
          throw Exception('Invalid node line: $line');
        }
        final name = matches.elementAt(0).group(0)!;
        final connections = matches.skip(1).map((m) => m.group(0)!).toList();
        return (name, connections);
      })
      .fold(<String, List<String>>{}, (acc, pair) {
        acc[pair.$1] = pair.$2;
        return acc;
      });
  return (directions: directions, nodes: nodes);
}

String solvePart1(InputType input) {
  return findStepsTo(
    input.nodes,
    input.directions,
    'AAA',
    (node) => node == 'ZZZ',
  ).toString();
}

String solvePart2(InputType input) {
  final nodes = input.nodes;
  final directions = input.directions;
  final stepsToZ = nodes.keys
      .where((node) => node[2] == 'A')
      .map((node) => findStepsTo(nodes, directions, node, (n) => n[2] == 'Z'))
      .toList();
  return leastCommonMultiple(stepsToZ).toString();
}

int findStepsTo(
  Map<String, List<String>> nodes,
  List<int> directions,
  String start,
  bool Function(String) isTarget,
) {
  String current = start;
  int steps = 0;
  final int max = 1 << 30;
  while (steps < max) {
    if (isTarget(current)) return steps;
    final node = nodes[current]!;
    current = node[directions[steps++ % directions.length]];
  }

  throw Exception('No path found from $start to target');
}
