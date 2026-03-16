import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'package:utils/dart_utils.dart';
import '../bin/day22.dart' hide main;

void main() {
  for (var (file, p1, p2) in [("A", 37327623, null), ("B", null, 23)])
    group("Check sample input $file passes for part", () {
      late var input;
      setUp(() {
        input = parseInput(
          Utils.readToString('../test_inputs/day22-$file.txt'),
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
      input = parseInput(Utils.readToString('../inputs/day22.txt'));
    });
    test("1", () {
      expect(solvePart1(input), "20506453102");
    });
    test("2", () {
      expect(solvePart2(input), "");
    }, skip: true);
  });
}
