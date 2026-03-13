import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'package:utils/dart_utils.dart';
import '../bin/day02.dart' hide main;

void main() {
  for (var (file, p1, p2) in [('A', 2, 4)])
    group("Check sample input $file passes for part", () {
      late var input;
      setUp(() {
        input = parseInput(
          Utils.readToString('../test_inputs/day02-$file.txt'),
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
      input = parseInput(Utils.readToString('../inputs/day02.txt'));
    });
    test("1", () {
      expect(solvePart1(input), "299");
    });
    test("2", () {
      expect(solvePart2(input), "364");
    });
  });

  group("Check Line Safety", () {
    test("handles increasing numbers", () {
      expect(checkLineSafety([2, 4, 6]), true);
    });
    test("handles decreasing numbers", () {
      expect(checkLineSafety([6, 4, 2]), true);
    });
    test("checks distance between numbers", () {
      expect(checkLineSafety([1, 2, 3]), true);
      expect(checkLineSafety([3, 6, 9]), true);
      expect(checkLineSafety([1, 1, 1]), false);
      expect(checkLineSafety([1, 5, 9]), false);
    });
  });

  group("Check Line Safety With Fails", () {
    test("handles allowing fails", () {
      expect(checkLineSafetyWithFail([1, 2, 3]), true);
      expect(checkLineSafetyWithFail([1, 6, 2]), true);
      expect(checkLineSafetyWithFail([1, 6, 7, 2]), false);
    });
  });
}
