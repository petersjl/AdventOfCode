// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day05.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = String;

InputType parseInput(String input) {
  return input;
}

String solvePart1(InputType input) {
  return generatePassword(input);
}

String solvePart2(InputType input) {
  return "";
}

String generatePassword(String input) {
  String password = '';
  int index = 0;
  for (int i = 0; i < 8; i++) {
    while (true) {
      var md5 = Utils.generateMd5(input + index.toString());
      var guess = checkMd5(md5);
      if (guess != null) {
        password += guess;
        index++;
        break;
      }
      index++;
    }
  }
  return password;
}

String? checkMd5(String guess) {
  for (int i = 0; i < 5; i++) {
    if (guess[i] != '0') return null;
  }
  return guess[5];
}
