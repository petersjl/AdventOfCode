// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

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
  return "";
}

class DataNode {
  int x, y;
  int size, used, available;

  DataNode(this.x, this.y, this.size, this.used) : available = size - used;
}
