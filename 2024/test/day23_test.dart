import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'package:utils/dart_utils.dart';
import '../bin/day23.dart' hide main;

void main() {
  for (var (file, p1, p2) in [("A", 7, "co,de,ka,ta")])
    group("Check sample input $file passes for part", () {
      late var input;
      setUp(() {
        input = parseInput(
          Utils.readToString('../test_inputs/day23-$file.txt'),
        );
      });
      test("1", () {
        expect(solvePart1(input), p1.toString());
      });
      test("2", () {
        expect(solvePart2(input, 4), p2.toString());
      });
    });

  group("Check actual input passes for part", () {
    late var input;
    setUp(() {
      input = parseInput(Utils.readToString('../inputs/day23.txt'));
    });
    test("1", () {
      expect(solvePart1(input), "1075");
    });
    test("2", () {
      expect(solvePart2(input), "az,cg,ei,hz,jc,km,kt,mv,sv,sx,wc,wq,xy");
    });
  });
}
