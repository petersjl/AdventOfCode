// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day04.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

class Room {
  List<String> name;
  int sectorId;
  String checksum;

  Room(this.name, this.sectorId, this.checksum);
}

typedef InputType = List<Room>;

InputType parseInput(String input) {
  return input.splitNewLine().map((line) {
    var match = RegExp(r"([a-z-]+)-(\d+)\[([a-z]+)\]").firstMatch(line);
    if (match == null) {
      throw Exception("Invalid line: $line");
    }
    return Room(
      match.group(1)!.split('-'),
      int.parse(match.group(2)!),
      match.group(3)!,
    );
  }).toList();
}

String solvePart1(InputType input) {
  int sum = 0;
  for (var room in input) {
    if (calculateCheckSum(room.name) == room.checksum) {
      sum += room.sectorId;
    }
  }
  return sum.toString();
}

String solvePart2(InputType input) {
  return "";
}

String calculateCheckSum(List<String> roomCodes) {
  Map<String, int> map = {};
  for (String code in roomCodes) {
    for (String char in code.characters) {
      map.increment(char);
    }
  }
  var pairs = map.entries.toList()
    ..sort((a, b) {
      int valCompare = b.value.compareTo(a.value);
      return valCompare != 0 ? valCompare : a.key.compareTo(b.key);
    });
  return pairs.take(5).map((e) => e.key).join();
}
