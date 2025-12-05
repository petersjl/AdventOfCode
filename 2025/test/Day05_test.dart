import '../bin/Day05.dart' hide main;
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'package:utils/DartUtils.dart';

const String DAY = '05';
void main() {
  if (DAY.isEmpty) {
    throw Exception("Please set the DAY constant to the day being tested.");
  }
  for (var (file, p1, p2) in [('A', "3", "14")])
    group("Check sample input $file passes for part", () {
      late var input;
      setUp(() {
        input = parseInput(
          Utils.readToString('../test_inputs/Day$DAY-$file.txt'),
        );
      });
      test("1", () {
        expect(solvePart1(input), p1.toString());
      }, skip: p1.isEmpty);
      test("2", () {
        expect(solvePart2(input), p2.toString());
      }, skip: p2.isEmpty);
    });

  group("Check actual input passes for part", () {
    late var input;
    setUp(() {
      input = parseInput(Utils.readToString('../inputs/Day$DAY.txt'));
    });
    const part1Answer = "638";
    const part2Answer = "352946349407338";
    test("1", () {
      expect(solvePart1(input), part1Answer);
    }, skip: part1Answer.isEmpty);
    test("2", () {
      expect(solvePart2(input), part2Answer);
    }, skip: part2Answer.isEmpty);
  });

  group('mergeRanges', () {
    for (var (input, expected) in [
      ([Pair(1, 5), Pair(3, 7)], [Pair(1, 7)]),
      ([Pair(1, 5), Pair(2, 4)], [Pair(1, 5)]),
      ([Pair(1, 5), Pair(5, 7)], [Pair(1, 7)]),
      ([Pair(1, 5), Pair(6, 7)], [Pair(1, 5), Pair(6, 7)]),
    ]) {
      test('merges $input to $expected', () {
        var result = mergeRanges(input);
        expect(result, expected);
      });
    }
  });
}
