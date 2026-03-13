import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'package:utils/dart_utils.dart';
import '../bin/day04.dart' hide main;

void main() {
  for (var (file, p1, p2) in [('A', 18, 9)])
    group("Check sample input $file passes for part", () {
      late var input;
      setUp(() {
        input = parseInput(
          Utils.readToString('../test_inputs/day04-$file.txt'),
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
      input = parseInput(Utils.readToString('../inputs/day04.txt'));
    });
    test("1", () {
      expect(solvePart1(input), "2434");
    });
    test("2", () {
      expect(solvePart2(input), "1835");
    });
  });
}
