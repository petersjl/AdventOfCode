import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'package:utils/dart_utils.dart';
import '../bin/day14.dart' hide main;

void main() {
  for (var (file, p1) in [('A', 12)])
    group("Check sample input $file passes for part", () {
      late var input;
      setUp(() {
        input = parseInput(
          Utils.readToString('../test_inputs/day14-$file.txt'),
        );
      });
      test("1", () {
        expect(solvePart1(input, Point(11, 7)), p1.toString());
      });
      // No sample input for part 2
    });

  group("Check actual input passes for part", () {
    late var input;
    setUp(() {
      input = parseInput(Utils.readToString('../inputs/day14.txt'));
    });
    test("1", () {
      expect(solvePart1(input), "211773366");
    });
    test("2", () {
      expect(solvePart2(input), "7344");
    });
  });
}
