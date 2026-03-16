import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'package:utils/dart_utils.dart';
import '../bin/day25.dart' hide main;

void main() {
  for (var (file, p1) in [("A", 3)])
    group("Check sample input $file passes for part", () {
      late var input;
      setUp(() {
        input = parseInput(
          Utils.readToString('../test_inputs/day25-$file.txt'),
        );
      });
      test("1", () {
        expect(solvePart1(input), p1.toString());
      });
    });

  group("Check actual input passes for part", () {
    late var input;
    setUp(() {
      input = parseInput(Utils.readToString('../inputs/day25.txt'));
    });
    test("1", () {
      expect(solvePart1(input), "3344");
    });
  });
}
