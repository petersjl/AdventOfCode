import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'package:utils/DartUtils.dart';

const String DAY = '{day_num}';
void main() {
  if (DAY.isEmpty) {
    throw Exception("Please set the DAY constant to the day being tested.");
  }
  for (var (file, p1, p2) in [('A', "", "")])
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
    const part1Answer = "";
    const part2Answer = "";
    test("1", () {
      expect(solvePart1(input), part1Answer);
    }, skip: part1Answer.isEmpty);
    test("2", () {
      expect(solvePart2(input), part2Answer);
    }, skip: part2Answer.isEmpty);
  });
}
