import '../bin/Day10.dart' hide main;
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'package:utils/DartUtils.dart';

const String DAY = '10';
void main() {
  if (DAY.isEmpty) {
    throw Exception("Please set the DAY constant to the day being tested.");
  }

  test('parseInput', () {
    final input = '[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}';
    final result = parseInput(input);
    expect(result.length, equals(1));
    final machine = result[0];
    expect(machine.expected, equals(int.parse('0110', radix: 2)));
    expect(
      machine.buttons,
      equals([
        int.parse('1000', radix: 2),
        int.parse('1010', radix: 2),
        int.parse('0100', radix: 2),
        int.parse('1100', radix: 2),
        int.parse('0101', radix: 2),
        int.parse('0011', radix: 2),
      ]),
    );
    expect(machine.joltages, equals([3, 5, 4, 7]));
  });

  for (var (input, presses) in [
    ("[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}", 2),
  ])
    test('$input => $presses', () {
      final machine = parseInput(input)[0];
      expect(getMinPresses(machine), equals(presses));
    });

  for (var (input, presses) in [
    ("[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}", 10),
  ])
    test('$input => $presses', () {
      final machine = parseInput(input)[0];
      expect(getMinJoltPresses(machine), equals(presses));
    });

  test('getNewJoltages', () {
    final button = int.parse('1000', radix: 2);
    final jolts = [0, 0, 0, 0];
    expect(getNewJoltages(button, jolts), equals([0, 0, 0, 1]));
  });

  for (var (file, p1, p2) in [('A', "7", "")])
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
    const part1Answer = "520";
    const part2Answer = "";
    test("1", () {
      expect(solvePart1(input), part1Answer);
    }, skip: part1Answer.isEmpty);
    test("2", () {
      expect(solvePart2(input), part2Answer);
    }, skip: part2Answer.isEmpty);
  });
}
