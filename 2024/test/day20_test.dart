import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'package:utils/dart_utils.dart';
import '../bin/day20.dart' hide main;

void main() {
  for (var (file, p1, p2) in [("A", 44, 285)])
    group("Check sample input $file passes for part", () {
      late var input;
      setUp(() {
        input = parseInput(
          Utils.readToString('../test_inputs/day20-$file.txt'),
        );
      });
      test("1", () {
        expect(solvePart1(input, 2), p1.toString());
      });
      test("2", () {
        expect(solvePart2(input, 50), p2.toString());
      });
    });

  group("Check actual input passes for part", () {
    late var input;
    setUp(() {
      input = parseInput(Utils.readToString('../inputs/day20.txt'));
    });
    test("1", () {
      expect(solvePart1(input), "1399");
    });
    test("2", () {
      expect(solvePart2(input), "994807");
    });
  });
}
