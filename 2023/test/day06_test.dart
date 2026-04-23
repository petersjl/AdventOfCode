import '../bin/day06.dart' hide main;
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'package:utils/dart_utils.dart';

const String DAY = '06';
void main() {
  if (DAY.isEmpty) {
    throw Exception("Please set the DAY constant to the day being tested.");
  }
  group('getWinCount', () {
    for (var (time, distance, expected) in [
      (7, 9, 4),
      (15, 40, 8),
      (30, 200, 9),
    ]) {
      test('time: $time, distance: $distance', () {
        expect(getWinCount(time, distance), expected);
      });
    }
  });

  for (var (file, p1, p2) in [('A', "288", "")])
    group("Check sample input $file passes for part", () {
      late var input;
      setUp(() {
        input = parseInput(
          Utils.readToString('../test_inputs/day$DAY-$file.txt'),
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
      input = parseInput(Utils.readToString('../inputs/day$DAY.txt'));
    });
    const part1Answer = "281600";
    const part2Answer = "";
    test("1", () {
      expect(solvePart1(input), part1Answer);
    }, skip: part1Answer.isEmpty);
    test("2", () {
      expect(solvePart2(input), part2Answer);
    }, skip: part2Answer.isEmpty);
  });
}
