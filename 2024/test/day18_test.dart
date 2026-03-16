import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'package:utils/dart_utils.dart';
import '../bin/day18.dart' hide main;

void main() {
  for (var (file, p1, p2) in [("A", 22, "6,1")])
    group("Check sample input $file passes for part", () {
      late var input;
      setUp(() {
        input = parseInput(
          Utils.readToString('../test_inputs/day18-$file.txt'),
        );
      });
      test("1", () {
        expect(solvePart1(input, 6, 12), p1.toString());
      });
      test("2", () {
        expect(solvePart2(input, 6, 12), p2.toString());
      });
    });

  group("Check actual input passes for part", () {
    late var input;
    setUp(() {
      input = parseInput(Utils.readToString('../inputs/day18.txt'));
    });
    test("1", () {
      expect(solvePart1(input), "446");
    });
    test("2", () {
      expect(solvePart2(input), "39,40");
    });
  });
}
