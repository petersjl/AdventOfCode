import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'package:utils/dart_utils.dart';
import '../bin/day03.dart' hide main;

void main() {
  for (var (file, p1, p2) in [('A', 161, null), ('B', null, 48)])
    group("Check sample input $file passes for part", () {
      late var input;
      setUp(() {
        input = parseInput(
          Utils.readToString('../test_inputs/day03-$file.txt'),
        );
      });
      if (p1 != null) {
        test("1", () {
          expect(solvePart1(input), p1.toString());
        });
      }
      if (p2 != null) {
        test("2", () {
          expect(solvePart2(input), p2.toString());
        });
      }
    });

  group("Check actual input passes for part", () {
    late var input;
    setUp(() {
      input = parseInput(Utils.readToString('../inputs/day03.txt'));
    });
    test("1", () {
      expect(solvePart1(input), "175615763");
    });
    test("2", () {
      expect(solvePart2(input), "74361272");
    });
  });
}
