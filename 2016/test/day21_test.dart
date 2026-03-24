import '../bin/day21.dart' hide main;
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'package:utils/dart_utils.dart';

const String DAY = '21';
void main() {
  if (DAY.isEmpty) {
    throw Exception("Please set the DAY constant to the day being tested.");
  }
  for (var (file, p1, p2) in [('A', "decab", "abcde")])
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
        expect(solvePart2(input, "decab"), p2.toString());
      }, skip: p2.isEmpty);
    });

  group("Check actual input passes for part", () {
    late var input;
    setUp(() {
      input = parseInput(Utils.readToString('../inputs/day$DAY.txt'));
    });
    const part1Answer = "fdhbcgea";
    const part2Answer = "egfbcadh";
    test("1", () {
      expect(solvePart1(input), part1Answer);
    }, skip: part1Answer.isEmpty);
    test("2", () {
      expect(solvePart2(input), part2Answer);
    }, skip: part2Answer.isEmpty);
  });

  group('Command', () {
    group('SwapPosition', () {
      test('.apply swaps elements at two positions', () {
        var password = ['a', 'b', 'c', 'd', 'e'];
        SwapPosition(1, 3).apply(password);
        expect(password, ['a', 'd', 'c', 'b', 'e']);
      });

      test('.reverse restores the original password', () {
        var password = ['a', 'b', 'c', 'd', 'e'];
        var command = SwapPosition(1, 3);
        command.apply(password);
        command.reverse(password);
        expect(password, ['a', 'b', 'c', 'd', 'e']);
      });
    });

    group('SwapLetter', () {
      test('.apply swaps two letters regardless of position', () {
        var password = ['a', 'b', 'c', 'd', 'e'];
        SwapLetter('b', 'd').apply(password);
        expect(password, ['a', 'd', 'c', 'b', 'e']);
      });

      test('.reverse restores the original password', () {
        var password = ['a', 'b', 'c', 'd', 'e'];
        var command = SwapLetter('b', 'd');
        command.apply(password);
        command.reverse(password);
        expect(password, ['a', 'b', 'c', 'd', 'e']);
      });
    });

    group('RotateCount', () {
      test('.apply left rotates the password', () {
        var password = ['a', 'b', 'c', 'd', 'e'];
        RotateCount(true, 2).apply(password);
        expect(password, ['c', 'd', 'e', 'a', 'b']);
      });

      test('.apply right rotates the password', () {
        var password = ['a', 'b', 'c', 'd', 'e'];
        RotateCount(false, 2).apply(password);
        expect(password, ['d', 'e', 'a', 'b', 'c']);
      });

      test('.reverse restores the original password', () {
        var password = ['a', 'b', 'c', 'd', 'e'];
        var command = RotateCount(false, 2);
        command.apply(password);
        command.reverse(password);
        expect(password, ['a', 'b', 'c', 'd', 'e']);
      });
    });

    group("RotateLetter", () {
      test('.apply rotates based on letter position', () {
        var password = ['a', 'b', 'c', 'd', 'e'];
        RotateLetter('b').apply(password);
        expect(password, ['d', 'e', 'a', 'b', 'c']);
      });

      test('.apply adds extra rotation when index is 4 or higher', () {
        var password = ['a', 'b', 'c', 'd', 'e'];
        RotateLetter('e').apply(password);
        expect(password, ['e', 'a', 'b', 'c', 'd']);
      });

      test('.reverse undoes the rotation', () {
        var password = ['a', 'b', 'c', 'd', 'e'];
        var command = RotateLetter('b');
        command.apply(password);
        command.reverse(password);
        expect(password, ['a', 'b', 'c', 'd', 'e']);
      });

      test(".reverse undoes the rotation with extra step", () {
        var password = ['a', 'b', 'c', 'd', 'e'];
        var command = RotateLetter('e');
        command.apply(password);
        command.reverse(password);
        expect(password, ['a', 'b', 'c', 'd', 'e']);
      });
    });

    group('ReversePositions', () {
      test('.apply reverses a range of elements', () {
        var password = ['a', 'b', 'c', 'd', 'e'];
        ReversePositions(1, 3).apply(password);
        expect(password, ['a', 'd', 'c', 'b', 'e']);
      });

      test('.reverse restores the original password', () {
        var password = ['a', 'b', 'c', 'd', 'e'];
        var command = ReversePositions(1, 3);
        command.apply(password);
        command.reverse(password);
        expect(password, ['a', 'b', 'c', 'd', 'e']);
      });
    });

    group('MovePosition', () {
      test('.apply moves element from one position to another', () {
        var password = ['a', 'b', 'c', 'd', 'e'];
        MovePosition(1, 3).apply(password);
        expect(password, ['a', 'c', 'd', 'b', 'e']);
      });

      test('.reverse restores the original password', () {
        var password = ['a', 'b', 'c', 'd', 'e'];
        var command = MovePosition(1, 3);
        command.apply(password);
        command.reverse(password);
        expect(password, ['a', 'b', 'c', 'd', 'e']);
      });
    });
  });
}
