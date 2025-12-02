import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'package:utils/DartUtils.dart';
import '../bin/Day02.dart' hide main;

void main() {
  for (var (file, p1, p2) in [('A', 1227775554, 4174379265)])
    group("Check sample input $file passes for part", () {
      late var input;
      setUp(() {
        input = parseInput(
          Utils.readToString('../test_inputs/Day02-$file.txt'),
        );
      });
      test("1", () {
        expect(solvePart1(input), p1.toString());
      });
      test("2", () {
        expect(solvePart2(input), p2.toString());
      });
    });

  group("Check actual input passes for part", () {
    late var input;
    setUp(() {
      input = parseInput(Utils.readToString('../inputs/Day02.txt'));
    });
    test("1", () {
      expect(solvePart1(input), "12586854255");
    });
    test("2", () {
      expect(solvePart2(input), "17298174201");
    });
  });

  group("Check getDigitCount", () {
    for (var (number, expected) in [
      (0, 1),
      (5, 1),
      (9, 1),
      (10, 2),
      (99, 2),
      (100, 3),
      (999, 3),
      (1000, 4),
      (-5, 1),
      (-12345, 5),
    ]) {
      test("Number $number has $expected digits", () {
        expect(getDigitCount(number), expected);
      });
    }
  });

  group("Check checkNumForRepeats", () {
    for (var (number, expected) in [
      (11, 1),
      (12, 0),
      (100, 0),
      (101, 0),
      (102, 0),
      (110, 0),
      (1212, 2),
      (1234, 0),
      (111, 1),
      (1111, 1),
      (123123, 3),
      (123456, 0),
      (121212, 2),
      (1001001, 0),
      (1010101, 0),
    ]) {
      test("Number $number has matching halves: $expected", () {
        expect(checkNumForRepeats(number), expected);
      });
    }
  });
}
