// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day16.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = List<bool>;

InputType parseInput(String input) {
  return input
      .trim()
      .characters
      .map((char) => char == '1' ? true : false)
      .toList();
}

String solvePart1(InputType input, [int diskLength = 272]) {
  var data = input;
  while (data.length < diskLength) {
    data = generateData(data);
  }
  data = data.sublist(0, diskLength);
  var checksum = computeChecksum(data);
  while (checksum.length.isEven) {
    checksum = computeChecksum(checksum);
  }
  return checksum.map((bit) => bit ? '1' : '0').join();
}

String solvePart2(InputType input) {
  return "";
}

List<bool> generateData(List<bool> input) {
  var a = input;
  var b = input.reversed.map((bit) => !bit).toList();
  return [...a, false, ...b];
}

List<bool> computeChecksum(List<bool> data) {
  var checksum = <bool>[];
  for (int i = 0; i < data.length; i += 2) {
    checksum.add(data[i] == data[i + 1]);
  }
  return checksum;
}
