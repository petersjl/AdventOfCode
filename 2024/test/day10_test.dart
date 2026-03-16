import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'package:utils/dart_utils.dart';
import '../bin/day10.dart' hide main;

void main() {
  test("Get trail head score", () {
    var input = parseInput(Utils.readToString('../test_inputs/day10-A.txt'));
    expect(getTrailheadScore(input.$1, Point(2, 0)), 5);
  });

  for (var (file, p1, p2) in [('A', 36, 81)])
    group("Check sample input $file passes for part", () {
      late var input;
      setUp(() {
        input = parseInput(
          Utils.readToString('../test_inputs/day10-$file.txt'),
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
      input = parseInput(Utils.readToString('../inputs/day10.txt'));
    });
    test("1", () {
      expect(solvePart1(input), "552");
    });
    test("2", () {
      expect(solvePart2(input), "1225");
    });
  });
}
