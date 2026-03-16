import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'package:utils/dart_utils.dart';
import '../bin/day16.dart' hide main;

void main() {
  for (var (file, p1, p2) in [("A", 7036, 45), ("B", 11048, 64)])
    group("Check sample input $file passes for part", () {
      late var input;
      setUp(() {
        input = parseInput(
          Utils.readToString('../test_inputs/day16-$file.txt'),
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
      input = parseInput(Utils.readToString('../inputs/day16.txt'));
    });
    test("1", () {
      expect(solvePart1(input), "90460");
    });
    test("2", () {
      expect(solvePart2(input), "");
    }, skip: true);
  });
}
