import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'package:utils/dart_utils.dart';
import '../bin/day11.dart' hide main;

void main() {
  group("Check sample input A passes for part", () {
    late var input;
    setUp(() {
      input = parseInput(Utils.readToString('../test_inputs/day11-A.txt'));
    });
    test("1", () {
      expect(solvePart1(input, 6), "22");
    });
    test("1.2", () {
      expect(solvePart1(input), "55312");
    });
    test("2", () {
      expect(solvePart2(input), "65601038650482");
    });
  });

  group("Check actual input passes for part", () {
    late var input;
    setUp(() {
      input = parseInput(Utils.readToString('../inputs/day11.txt'));
    });
    test("1", () {
      expect(solvePart1(input), "188902");
    });
    test("2", () {
      expect(solvePart2(input), "223894720281135");
    });
  });
}
