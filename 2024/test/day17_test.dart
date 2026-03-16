import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'package:utils/dart_utils.dart';
import '../bin/day17.dart' hide main;

void main() {
  for (var (file, p1, p2) in [
    ("A", "4,6,3,5,6,3,5,2,1,0", null),
    ("B", null, 117440),
  ])
    group("Check sample input $file passes for part", () {
      late var input;
      setUp(() {
        input = parseInput(
          Utils.readToString('../test_inputs/day17-$file.txt'),
        );
      });
      if (p1 != null)
        test("1", () {
          expect(solvePart1(input), p1.toString());
        });
      if (p2 != null)
        test("2", () {
          expect(solvePart2(input), p2.toString());
        });
    });

  group("Check actual input passes for part", () {
    late var input;
    setUp(() {
      input = parseInput(Utils.readToString('../inputs/day17.txt'));
    });
    test("1", () {
      expect(solvePart1(input), "6,2,7,2,3,1,6,0,5");
    });
    test("2", () {
      expect(solvePart2(input), "");
    }, skip: true);
  });
}
