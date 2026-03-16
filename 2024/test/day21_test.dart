import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'package:utils/dart_utils.dart';
import '../bin/day21.dart' hide main;

void main() {
  group("Check robot produces correct directions for", () {
    test("029A", () {
      Robot r = Robot(RobType.Number);
      expect(r.getMovementsForSequence("029A"), "<A^A^^>AvvvA");
    });
  });

  group("Check getFullSequence gets correct input length for", () {
    late Robot numBot;
    late Robot dirBot;
    setUp(() {
      numBot = Robot(RobType.Number);
      dirBot = Robot(RobType.Direction);
    });
    test("029A", () {
      var sequence = getFullSequenceForCode(numBot, dirBot, "029A");
      expect(sequence.length, 68);
    });
    test("980A", () {
      var sequence = getFullSequenceForCode(numBot, dirBot, "980A");
      expect(sequence.length, 60);
    });
    test("179A", () {
      var sequence = getFullSequenceForCode(numBot, dirBot, "179A");
      expect(sequence.length, 68);
    });
    test("456A", () {
      var sequence = getFullSequenceForCode(numBot, dirBot, "456A");
      expect(sequence.length, 64);
    });
    test("379A", () {
      var sequence = getFullSequenceForCode(numBot, dirBot, "379A");
      expect(sequence.length, 64);
    });
    test("62A", () {
      var sequence = getFullSequenceForCode(numBot, dirBot, "62A");
      expect(sequence.length, 51);
    });
    test("26A", () {
      var sequence = getFullSequenceForCode(numBot, dirBot, "26A");
      expect(sequence.length, 57);
    });
  });

  for (var (file, p1, p2) in [("A", 126384, null)])
    group("Check sample input $file passes for part", () {
      late var input;
      setUp(() {
        input = parseInput(
          Utils.readToString('../test_inputs/day21-$file.txt'),
        );
      });
      test("1", () {
        expect(solvePart1(input), p1.toString());
      });
      if (p2 != null)
        test("2", () {
          expect(solvePart2(input), p2.toString());
        });
    });

  group("Check actual input passes for part", () {
    late var input;
    setUp(() {
      input = parseInput(Utils.readToString('../inputs/day21.txt'));
    });
    test("1", () {
      expect(solvePart1(input), "137870");
    });
    test("2", () {
      expect(solvePart2(input), "");
    }, skip: true);
  });
}
