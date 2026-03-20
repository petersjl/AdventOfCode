import '../bin/day11.dart' hide main;
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'package:utils/dart_utils.dart';

const String DAY = '11';
void main() {
  if (DAY.isEmpty) {
    throw Exception("Please set the DAY constant to the day being tested.");
  }
  // The sample input has no solution for part 2, so we don't include it
  group("Check sample input A passes for part", () {
    late var input;
    setUp(() {
      input = parseInput(Utils.readToString('../test_inputs/day$DAY-A.txt'));
    });
    test("1", () {
      expect(solvePart1(input), "11");
    });
  });

  group("Check actual input passes for part", () {
    late var input;
    setUp(() {
      input = parseInput(Utils.readToString('../inputs/day$DAY.txt'));
    });
    const part1Answer = "31";
    const part2Answer = "55";
    test("1", () {
      expect(solvePart1(input), part1Answer);
    }, skip: part1Answer.isEmpty);
    test("2", () {
      expect(solvePart2(input), part2Answer);
    }, skip: part2Answer.isEmpty);
  });
}
