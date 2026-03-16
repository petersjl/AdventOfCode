import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'package:utils/dart_utils.dart';
import '../bin/day12.dart' hide main;

void main() {
  for (var (file, p1, p2) in [
    ("A", 140, 80),
    ("B", 772, 436),
    ("C", 1930, 1206),
    ("D", null, 236),
    ("E", null, 368),
  ])
    group("Check sample input $file passes for part", () {
      late var input;
      setUp(() {
        input = parseInput(
          Utils.readToString('../test_inputs/day12-$file.txt'),
        );
      });
      if (!(p1 == null))
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
      input = parseInput(Utils.readToString('../inputs/day12.txt'));
    });
    test("1", () {
      expect(solvePart1(input), "1446042");
    });
    test("2", () {
      expect(solvePart2(input), "Fail");
    }, skip: true);
  });
}
