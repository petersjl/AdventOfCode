import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'package:utils/DartUtils.dart';
import '../bin/Day01.dart' hide main;

void main() {
  for (var (file, p1, p2) in [('A', 3, 6)])
    group("Check sample input $file passes for part", () {
      late var input;
      setUp(() {
        input = parseInput(
          Utils.readToString('../test_inputs/Day01-$file.txt'),
        );
      });
      test("1", () {
        expect(solvePart1(input), p1.toString());
      });
      test("2", () {
        expect(solvePart2(input), p2.toString());
      });
    });

  group("Check part 2 edge cases", () {
    test("No rotations", () {
      var input = <Rotation>[];
      expect(solvePart2(input), "0");
    });
    test("L50", () {
      var input = <Rotation>[Rotation(false, 50)];
      expect(solvePart2(input), "1");
    });
    test("L150", () {
      var input = <Rotation>[Rotation(false, 150)];
      expect(solvePart2(input), "2");
    });
    test("R1000", () {
      var input = <Rotation>[Rotation(true, 1000)];
      expect(solvePart2(input), "10");
    });
    test("R50, R100", () {
      var input = <Rotation>[Rotation(true, 50), Rotation(true, 100)];
      expect(solvePart2(input), "2");
    });
    test("R50, L1000", () {
      var input = <Rotation>[Rotation(true, 50), Rotation(false, 1000)];
      expect(solvePart2(input), "11");
    });
    test("R50, L1, R1", () {
      var input = <Rotation>[
        Rotation(true, 50),
        Rotation(false, 1),
        Rotation(true, 1),
      ];
      expect(solvePart2(input), "2");
    });
    test("R50, R1, L1", () {
      var input = <Rotation>[
        Rotation(true, 50),
        Rotation(true, 1),
        Rotation(false, 1),
      ];
      expect(solvePart2(input), "2");
    });
  });

  group("Check actual input passes for part", () {
    late var input;
    setUp(() {
      input = parseInput(Utils.readToString('../inputs/Day01.txt'));
    });
    test("1", () {
      expect(solvePart1(input), "995");
    });
    test("2", () {
      expect(solvePart2(input), "5847");
    });
  });
}
