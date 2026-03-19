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

String solvePart2(InputType input) {
  List<String?> password = List.filled(8, null);
  for (int index = 0; password.contains(null); index++) {
    var md5 = Utils.generateMd5(input + index.toString());
    var guess = checkMd5(md5);
    if (guess != null) {
      int pos = int.tryParse(guess) ?? -1;
      if (pos >= 0 && pos < 8 && password[pos] == null) {
        password[pos] = md5[6];
      }
    }
  }
  return password.map((e) => e ?? '').join();
}

String? checkMd5(String guess) {
  for (int i = 0; i < 5; i++) {
    if (guess[i] != '0') return null;
  }
  return guess[5];
}
