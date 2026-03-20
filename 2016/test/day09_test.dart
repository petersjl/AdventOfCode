import '../bin/day09.dart' hide main;
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'package:utils/dart_utils.dart';

const String DAY = '09';
void main() {
  if (DAY.isEmpty) {
    throw Exception("Please set the DAY constant to the day being tested.");
  }

  group("Check non-recursive decompress gets correct length for", () {
    for (var (input, expected) in [
      ("ADVENT", 6),
      ("A(1x5)BC", 7),
      ("(3x3)XYZ", 9),
      ("A(2x2)BCD(2x2)EFG", 11),
      ("(6x1)(1x3)A", 6),
      ("X(8x2)(3x3)ABCY", 18),
    ]) {
      test(input, () {
        expect(decompressLength(input), expected);
      });
    }
  });

  for (var (file, p1, p2) in [('A', "238", "")])
    group("Check sample input $file passes for part", () {
      late var input;
      setUp(() {
        input = parseInput(
          Utils.readToString('../test_inputs/day$DAY-$file.txt'),
        );
      });
      test("1", () {
        expect(solvePart1(input), p1.toString());
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
    const part1Answer = "123908";
    const part2Answer = "";
    test("1", () {
      expect(solvePart1(input), part1Answer);
    }, skip: part1Answer.isEmpty);
    test("2", () {
      expect(solvePart2(input), part2Answer);
    }, skip: part2Answer.isEmpty);
  });
}
