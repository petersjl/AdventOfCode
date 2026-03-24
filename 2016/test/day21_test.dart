import '../bin/day21.dart' hide main;
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'package:utils/dart_utils.dart';

const String DAY = '21';
void main() {
  if (DAY.isEmpty) {
    throw Exception("Please set the DAY constant to the day being tested.");
  }
  for (var (file, p1, p2) in [('A', "decab", "")])
    group("Check sample input $file passes for part", () {
      late var input;
      setUp(() {
        input = parseInput(
          Utils.readToString('../test_inputs/day$DAY-$file.txt'),
        );
      });
      test("1", () {
        expect(solvePart1(input, "abcde"), p1.toString());
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
    const part1Answer = "fdhbcgea";
    const part2Answer = "";
    test("1", () {
      expect(solvePart1(input), part1Answer);
    }, skip: part1Answer.isEmpty);
    test("2", () {
      expect(solvePart2(input), part2Answer);
    }, skip: part2Answer.isEmpty);
  });

  group('Command classes', () {
    test('SwapPosition swaps elements at two positions', () {
      var password = ['a', 'b', 'c', 'd', 'e'];
      SwapPosition(1, 3).apply(password);
      expect(password, ['a', 'd', 'c', 'b', 'e']);
    });

    test('SwapLetter swaps two letters regardless of position', () {
      var password = ['a', 'b', 'c', 'd', 'e'];
      SwapLetter('b', 'd').apply(password);
      expect(password, ['a', 'd', 'c', 'b', 'e']);
    });

    test('RotateCount left rotates the password', () {
      var password = ['a', 'b', 'c', 'd', 'e'];
      RotateCount(true, 2).apply(password);
      expect(password, ['c', 'd', 'e', 'a', 'b']);
    });

    test('RotateCount right rotates the password', () {
      var password = ['a', 'b', 'c', 'd', 'e'];
      RotateCount(false, 2).apply(password);
      expect(password, ['d', 'e', 'a', 'b', 'c']);
    });

    test('RotateLetter rotates based on letter position', () {
      var password = ['a', 'b', 'c', 'd', 'e'];
      RotateLetter('b').apply(password);
      expect(password, ['d', 'e', 'a', 'b', 'c']);
    });

    test('RotateLetter adds extra rotation when index is 4 or higher', () {
      var password = ['a', 'b', 'c', 'd', 'e'];
      RotateLetter('e').apply(password);
      expect(password, ['e', 'a', 'b', 'c', 'd']);
    });

    test('ReversePositions reverses a range of elements', () {
      var password = ['a', 'b', 'c', 'd', 'e'];
      ReversePositions(1, 3).apply(password);
      expect(password, ['a', 'd', 'c', 'b', 'e']);
    });

    test('MovePosition moves element from one position to another', () {
      var password = ['a', 'b', 'c', 'd', 'e'];
      MovePosition(1, 3).apply(password);
      expect(password, ['a', 'c', 'd', 'b', 'e']);
    });
  });
}
