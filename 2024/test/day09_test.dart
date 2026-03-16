import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'package:utils/dart_utils.dart';
import '../bin/day09.dart' hide main;

void main() {
  group("Check getSize methods", () {
    test("block 1", () {
      expect(getBlockSize([null, null, 1, 1, 1, null, null], 4), 3);
    });
    test("block 2", () {
      expect(getBlockSize([1, 1, 1, null, null], 2), 3);
    });
    test("block 3", () {
      expect(getBlockSize([1, 1, 1, 2, 2, null, null], 4), 2);
    });
    test("hole 1", () {
      expect(getHoleSize([1, 1, null, null, null, 1, 1], 2), 3);
    });
    test("hole 2", () {
      expect(getHoleSize([1, 1, null, null, null, 1, 1], 0), 0);
    });
  });

  group("Check findABigHole", () {
    test("finds a hole", () {
      expect(findABigHole([1, 1, null, null, 1, null, null, null, 1], 8, 3), 5);
    });
  });

  group("Check swapNullAndId", () {
    test("handles non-adjacent days", () {
      List<int?> blocks = [0, 0, null, null, null, 1, 1, 2, 2, 2];
      List<int?> expected = [0, 0, 2, 2, 2, 1, 1, null, null, null];
      swapNullAndId(blocks, 2, 9, 3);
      expect(blocks, expected);
    });
    test("handles adjacent days", () {
      List<int?> blocks = [0, 0, null, null, null, 2, 2, 2];
      List<int?> expected = [0, 0, 2, 2, 2, null, null, null];
      swapNullAndId(blocks, 2, 7, 3);
      expect(blocks, expected);
    });
  });

  for (var (file, p1, p2) in [('A', 1928, 2858)])
    group("Check sample input $file passes for part", () {
      late var input;
      setUp(() {
        input = parseInput(
          Utils.readToString('../test_inputs/day09-$file.txt'),
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
      input = parseInput(Utils.readToString('../inputs/day09.txt'));
    });
    test("1", () {
      expect(solvePart1(input), "6216544403458");
    });
    test("2", () {
      expect(solvePart2(input), "6237075041489");
    });
  });
}
