import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'package:utils/dart_utils.dart';
import '../bin/day13.dart' hide main;

void main() {
  for (var (file, p1, p2) in [('A', 480, 875318608908)])
    group("Check sample input $file passes for part", () {
      late var input;
      setUp(() {
        input = parseInput(
          Utils.readToString('../test_inputs/day13-$file.txt'),
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
      input = parseInput(Utils.readToString('../inputs/day13.txt'));
    });
    test("1", () {
      expect(solvePart1(input), "26005");
    });
    test("2", () {
      expect(solvePart2(input), "105620095782547");
    });
  });
}
