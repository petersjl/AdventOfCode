// ignore_for_file: dead_code

import 'dart:math';

import 'package:utils/DartUtils.dart';
// Removed unused DataStructures export; using UnionFindInt directly
import 'package:utils/DataStructures/UnionFindInt.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/Day08.txt");
  Utils.runWithTiming(parseInput, null, solvePart2, rawInput);
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
  var distances = getDistances(input);
  print('got distances');
  List<(int, (Junction, Junction))> reversed = distances.entries
      .map((e) => (e.value, e.key))
      .toList();
  reversed.sort((a, b) => a.$1.compareTo(b.$1));
  print('enqueued all pairs');
  var successfulPairs = 0;
  var circuitCount = 0;
  var circuits = Map<int, List<Junction>>();
  while (successfulPairs < pairs) {
    var (first, second) = reversed.removeAt(0).$2;
    if ((first.circuit != 0 || second.circuit != 0) &&
        first.circuit == second.circuit) {
      successfulPairs++;
      continue;
    } else if (first.circuit == 0 && second.circuit == 0) {
      var circuit = ++circuitCount;
      first.circuit = circuit;
      second.circuit = circuit;
      circuits[circuit] = [first, second];
    } else if (first.circuit == 0) {
      first.circuit = second.circuit;
      circuits[second.circuit]!.add(first);
    } else if (second.circuit == 0) {
      second.circuit = first.circuit;
      circuits[first.circuit]!.add(second);
    } else {
      var lesser = min(first.circuit, second.circuit);
      var greater = max(first.circuit, second.circuit);
      for (var junction in circuits[greater]!) {
        junction.circuit = lesser;
      }
      circuits[lesser]!.addAll(circuits[greater]!);
      circuits.remove(greater);
    }
    successfulPairs++;
  }
  print('made all pairs');
  var lengths = circuits.values.map((circuit) => circuit.length).toList();
  print('got lengths');
  lengths.sort((a, b) => b.compareTo(a));
  print('sorted lengths $lengths');
  return (lengths[0] * lengths[1] * lengths[2]).toString();
}

Map<(Junction, Junction), int> getDistances(InputType input) {
  Map<(Junction, Junction), int> distances = {};
  for (int i = 0; i < input.length - 1; i++) {
    for (int j = i + 1; j < input.length; j++) {
      Junction first, second;
      if (input[i].compareTo(input[j]) <= 0) {
        first = input[i];
        second = input[j];
      } else {
        first = input[j];
        second = input[i];
      }
      distances[(first, second)] = first.distance(second);
    }
  }
  return distances;
}

String solvePart2(InputType input) {
  print(input.length);
  final uf = UnionFindInt(input.length);
  final distances = getDistancesIds(input);
  print('got distances: ${distances.length}');
  distances.sort((a, b) => a.$1.compareTo(b.$1));
  print('enqueued all pairs: ${distances.length}');
  for (var i = 0; i < distances.length; i++) {
    var (dist, ids) = distances[i];
    final a = ids.$1;
    final b = ids.$2;
    int size = uf.union(a, b);
    if (size == input.length) {
      return (input[a].x * input[b].x).toString();
    }
  }
  return "";
}

/// Compute squared distances between all unique pairs and return
/// a list of (distance, (idA, idB)) with ids in ascending order.
List<(int, (int, int))> getDistancesIds(InputType input) {
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
  int circuit = 0;
  int _hashcode;

  @override
  int get hashCode => _hashcode;

  Junction(this.x, this.y, this.z) : _hashcode = Object.hash(x, y, z);

  Junction.fromList(List<int> coords)
    : x = coords[0],
      y = coords[1],
      z = coords[2],
      _hashcode = Object.hash(coords[0], coords[1], coords[2]);

  int distance(Junction other) {
    return (pow((this.x - other.x), 2) +
            pow((this.y - other.y), 2) +
            pow((this.z - other.z), 2))
        .toInt();
  }

  int compareTo(Junction other) {
    if (x != other.x) return x.compareTo(other.x);
    if (y != other.y) return y.compareTo(other.y);
    return z.compareTo(other.z);
  }
}
