// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day25.txt");
  Utils.runWithTiming(parseInput, solvePart1, null, rawInput);
}

typedef InputType = (List<List<int>>, List<List<int>>);

List<int> parseLock(List<String> lockString) {
  List<int> locks = [];
  for (int pin = 0; pin < lockString[0].length; pin++) {
    for (int height = 0; height < lockString.length; height++) {
      if (lockString[height][pin] == ".") {
        locks.add(height - 1);
        break;
      }
    }
  }
  return locks;
}

List<int> parseKey(List<String> keyString) {
  List<int> keys = [];
  for (int pin = 0; pin < keyString[0].length; pin++) {
    for (int height = 0; height < keyString.length; height++) {
      if (keyString[height][pin] == "#") {
        keys.add(keyString.length - (height + 1));
        break;
      }
    }
  }
  return keys;
}

InputType parseInput(String input) {
  List<List<int>> locks = [];
  List<List<int>> keys = [];
  var blocks = input.splitDoubleNewLine();
  blocks.forEach((block) {
    if (block[0] == "#")
      locks.add(parseLock(block.splitNewLine()));
    else
      keys.add(parseKey(block.splitNewLine()));
  });
  return (locks, keys);
}

String solvePart1(InputType input) {
  List<List<int>> locks = List.from(input.$1);
  List<List<int>> keys = List.from(input.$2);

  int pairs = 0;
  for (int l = 0; l < locks.length; l++) {
    keyloop:
    for (int k = 0; k < keys.length; k++) {
      for (int i = 0; i < locks[l].length; i++) {
        if (locks[l][i] + keys[k][i] > 5) continue keyloop;
      }
      pairs++;
    }
  }
  return pairs.toString();
}
