import '../bin/day13.dart' hide main;
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'package:utils/dart_utils.dart';

const String DAY = '13';
void main() {
  if (DAY.isEmpty) {
    throw Exception("Please set the DAY constant to the day being tested.");
  }

  group("countOnes gets the correct number of 1s in the binary of", () {
    for (var (n, expected) in [
      (0, 0),
      (1, 1),
      (2, 1),
      (3, 2),
      (4, 1),
      (5, 2),
      (6, 2),
      (7, 3),
      (8, 1),
      (9, 2),
    ]) {
      test("$n", () {
        expect(intCountOnes(n), expected);
      });
    }
  });

  group("isWall correctly identifies walls", () {
    for (var (x, y, input, expected) in [
      (0, 0, 10, false),
      (1, 0, 10, true),
      (0, 1, 10, false),
      (1, 1, 10, false),
    ]) {
      test("($x, $y) with input $input", () {
        expect(isWall(x, y, input), expected);
      });
    }
  });

  for (var (file, p1, p2) in [('A', "11", "")])
    group("Check sample input $file passes for part", () {
      late var input;
      setUp(() {
        input = parseInput(
          Utils.readToString('../test_inputs/day$DAY-$file.txt'),
        );
      });
      test("1", () {
        expect(solvePart1(input, 7, 4), p1.toString());
      }, skip: p1.isEmpty);
      test("2", () {
        expect(solvePart2(input), p2.toString());
      }, skip: p2.isEmpty);
    });

  group("Check actual input passes for part", () {
    late var input;
    setUp(() {
      input = parseInput(Utils.readToString('../inputs/day$DAY.txt'));
    });
    const part1Answer = "92";
    const part2Answer = "124";
    test("1", () {
      expect(solvePart1(input), part1Answer);
    }, skip: part1Answer.isEmpty);
    test("2", () {
      expect(solvePart2(input), part2Answer);
    }, skip: part2Answer.isEmpty);
  });
}
