// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day23.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = Map<String, List<String>>;

InputType parseInput(String input) {
  Map<String, List<String>> connections = {};
  input.splitNewLine().forEach((pair) {
    var computers = pair.split("-");
    connections.update(
      computers[0],
      (l) => l..add(computers[1]),
      ifAbsent: () => [computers[1]],
    );
    connections.update(
      computers[1],
      (l) => l..add(computers[0]),
      ifAbsent: () => [computers[0]],
    );
  });
  return connections;
}

String solvePart1(InputType input) {
  Set<(String, String, String)> tripples = {};
  for (var entry in input.entries) {
    if (entry.key[0] != "t") continue;
    if (entry.value.length < 2) continue;
    for (int i = 0; i < entry.value.length - 1; i++) {
      var first = entry.value[i];
      for (int j = i + 1; j < entry.value.length; j++) {
        var second = entry.value[j];
        if (input[first]!.contains(second)) {
          var l = [entry.key, first, second]..sort();
          tripples.add((l[0], l[1], l[2]));
        }
      }
    }
  }
  return tripples.length.toString();
}

List<String> getGroup(String key, Map<String, List<String>> connections) {
  var local = connections[key]!;
  for (int i = 0; i < connections[key]!.length; i++) {
    var clone = List<String>.from(local)
      ..remove(local[i])
      ..add(key);
    bool containsAll = true;
    members:
    for (var member in clone) {
      var localConnections = connections[member]!;
      for (var localMember in clone) {
        if (member == localMember) continue;
        if (!localConnections.contains(localMember)) {
          containsAll = false;
          break members;
        }
      }
    }
    if (containsAll) return clone;
  }
  return [];
}

String solvePart2(InputType input, [int largeGroupSize = 13]) {
  List<String> largeGroup = [];
  for (var key in input.keys) {
    var group = getGroup(key, input);
    if (group.length == largeGroupSize) {
      largeGroup = group;
      break;
    }
  }
  largeGroup.sort();
  return largeGroup.join(',');
}
