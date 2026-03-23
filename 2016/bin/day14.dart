// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day14.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = String;

InputType parseInput(String input) {
  return input;
}

String solvePart1(InputType input) {
  int count = 0;
  var toVisit = List.generate(1000, (index) => generateHash(input, index));
  for (int i = 0; i < 100000000; i++) {
    var current = toVisit.removeAt(0);
    toVisit.add(generateHash(input, i + 1000));
    var tripleChar = RegExp(r'(.)\1\1').firstMatch(current);
    if (tripleChar != null) {
      if (toVisit.any((hash) => hash.contains(tripleChar.group(1)! * 5))) {
        count++;
        if (count == 64) {
          return (i).toString();
        }
      }
    }
  }
  throw Exception("Did not find 64 keys within search limit");
}

String solvePart2(InputType input) {
  return "";
}

String generateHash(String key, int index) {
  var toHash = "$key$index";
  var hash = Utils.generateMd5(toHash);
  return hash;
}
