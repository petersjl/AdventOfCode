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
    test('buttons $input => $presses', () {
      final machine = parseInput(input)[0];
      expect(getMinPresses(machine), equals(presses));
    });

  for (var (input, presses) in [
    ("[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}", 10),
    ("[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}", 12),
    ("[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}", 11),
    (
      "[..#####..] (1,3,6) (0,2,3,4,6,7) (0,3,5,7,8) (1,8) (1,4,5,6,7) (0,1,2) (0,2,4,6,7,8) (3,4,5) (1,3,4) {39,59,20,48,34,30,17,31,44}",
      91,
    ),
    (
      "[.....##.#.] (1,2,3,5,6,8) (4) (1,5,6,9) (2,5,6,8,9) (1,3,4,8) (0,3,8) (0,3,4,5,6,7,8,9) (1,4) (0,7) (1,2,4,6,9) {11,213,12,33,230,26,27,11,40,23}",
      245,
    ),
    (
      "[...##...#] (2,5,6,7,8) (0,3,5,7,8) (0,2,3,5,7,8) (1,4,5,7,8) (0,1,2,4,6) (1,3,4,6,7,8) (0,4,5,7) {43,26,39,19,39,47,36,52,39}",
      68,
    ),
    (
      "[..#...#] (1,3) (0,2,6) (0,3,5,6) (4,5,6) (0,1,2,3,5) (0,2,3,4,5) (0,3,6) {184,38,30,194,18,43,178}",
      218,
    ),
    ("[.#..#] (0,1,3) (0,1,2) (1,2) (3) (1,4) {23,46,16,23,19}", 58),
  ])
    test('jolts $input => $presses', () {
      final machine = parseInput(input)[0];
      expect(getMinJoltPresses(machine), equals(presses));
    });

  test('getPressesWithParity', () {
    final buttons = [
      int.parse('1000', radix: 2),
      int.parse('1010', radix: 2),
      int.parse('0100', radix: 2),
      int.parse('0110', radix: 2),
      int.parse('0010', radix: 2),
    ];
    final targets = [0, 1, 0, 1];
    final result = getPressesWithParity(buttons, targets);
    expect(
      result,
      equals([
        [buttons[1]],
        [buttons[1], buttons[2], buttons[3], buttons[4]],
        [buttons[0], buttons[4]],
        [buttons[0], buttons[2], buttons[3]],
      ]),
    );
  });

  test('pressButtons', () {
    final buttons = [
      int.parse('1000', radix: 2),
      int.parse('1010', radix: 2),
      int.parse('0100', radix: 2),
      int.parse('0110', radix: 2),
      int.parse('0010', radix: 2),
    ];
    final result = pressButtons(buttons, 4);
    expect(result, equals([0, 3, 2, 2]));
  });

  test('shareParity', () {
    final current = [0, 1, 0, 1];
    final target = [2, 3, 4, 5];
    expect(shareParity(current, target), isTrue);
    final target2 = [2, 2, 4, 5];
    expect(shareParity(current, target2), isFalse);
  });

  for (var (file, p1, p2) in [('A', "7", "33")])
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
    const part2Answer = "20626";
    test("1", () {
      expect(solvePart1(input), part1Answer);
    }, skip: part1Answer.isEmpty);
    test("2", () {
      expect(solvePart2(input), part2Answer);
    }, skip: part2Answer.isEmpty);
  });
}
