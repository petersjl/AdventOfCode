import '../bin/day08.dart' hide main;
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'package:utils/dart_utils.dart';

const String DAY = '08';
void main() {
  if (DAY.isEmpty) {
    throw Exception("Please set the DAY constant to the day being tested.");
  }
  for (var (file, p1) in [('A', "2"), ('B', "6")])
    test("Check sample input $file passes for part 1", () {
      final input = parseInput(
        Utils.readToString('../test_inputs/day$DAY-$file.txt'),
      );
      expect(solvePart1(input), p1.toString(), skip: p1.isEmpty);
    });

  test('Check sample input C passes for part 2', () {
    final input = parseInput(
      Utils.readToString('../test_inputs/day$DAY-C.txt'),
    );
    expect(solvePart2(input), "6");
  });

  group("Check actual input passes for part", () {
    late var input;
    setUp(() {
      input = parseInput(Utils.readToString('../inputs/day$DAY.txt'));
    });
    const part1Answer = "22357";
    const part2Answer = "10371555451871";
    test("1", () {
      expect(solvePart1(input), part1Answer);
    }, skip: part1Answer.isEmpty);
    test("2", () {
      expect(solvePart2(input), part2Answer);
    }, skip: part2Answer.isEmpty);
  });
}
