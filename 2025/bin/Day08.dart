// ignore_for_file: dead_code

import 'dart:math';

import 'package:utils/DartUtils.dart';
import 'package:utils/DataStructures.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/Day08.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = List<Junction>;

InputType parseInput(String input) {
  return input
      .splitNewLine()
      .map((line) => line.split(',').map(int.parse).toList())
      .map(Junction.fromList)
      .toList();
}

String solvePart1(InputType input, [int pairs = 1000]) {
  final uf = UnionFindInt(input.length);
  final distances = getDistances(input);
  distances.sort((a, b) => a.$1.compareTo(b.$1));
  for (var i = 0; i < pairs; i++) {
    var (dist, ids) = distances[i];
    final a = ids.$1;
    final b = ids.$2;
    uf.union(a, b);
  }
  var roots = uf.roots;
  var sizes = <int>[];
  for (var i = 0; i < roots.length; i++) {
    int size = uf.setSize(roots[i]);
    if (size > 1) {
      sizes.add(size);
    }
  }
  sizes.sort();
  return (sizes.removeLast() * sizes.removeLast() * sizes.removeLast())
      .toString();
}

String solvePart2(InputType input) {
  final uf = UnionFindInt(input.length);
  final distances = getDistances(input);
  distances.sort((a, b) => a.$1.compareTo(b.$1));
  for (var i = 0; i < distances.length; i++) {
    var (dist, ids) = distances[i];
    final a = ids.$1;
    final b = ids.$2;
    int size = uf.union(a, b);
    if (size == input.length) {
      return (input[a].x * input[b].x).toString();
    }
  }
  return "Not found";
}

/// Compute squared distances between all unique pairs and return
/// a list of (distance, (idA, idB)) with ids in ascending order.
List<(int, (int, int))> getDistances(InputType input) {
  final out = <(int, (int, int))>[];
  for (int i = 0; i < input.length - 1; i++) {
    for (int j = i + 1; j < input.length; j++) {
      final d = input[i].distance(input[j]);
      out.add((d, (i, j)));
    }
  }
  return out;
}

class Junction {
  int x;
  int y;
  int z;

  Junction(this.x, this.y, this.z);

  Junction.fromList(List<int> coords)
    : x = coords[0],
      y = coords[1],
      z = coords[2];

  int distance(Junction other) {
    return (pow((this.x - other.x), 2) +
            pow((this.y - other.y), 2) +
            pow((this.z - other.z), 2))
        .toInt();
  }
}
