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
  return findFinalKey(input, 1);
}

String solvePart2(InputType input) {
  return findFinalKey(input, 2017);
}

String generateHash(String key, int index, int hashCount) {
  var toHash = "$key$index";
  var hash = Utils.generateMd5(toHash);
  for (int i = 1; i < hashCount; i++) {
    hash = Utils.generateMd5(hash);
  }
  return hash;
}

String findFinalKey(String key, int hashCount) {
  int count = 0;
  var toVisit = List.generate(
    1000,
    (index) => generateHash(key, index, hashCount),
  );
  for (int i = 0; i < 100000000; i++) {
    var current = toVisit.removeAt(0);
    toVisit.add(generateHash(key, i + 1000, hashCount));
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
