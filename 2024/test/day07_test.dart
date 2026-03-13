import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'package:utils/dart_utils.dart';
import '../bin/day07.dart' hide main;

void main() {
  for (var (file, p1, p2) in [('A', 3749, 11387)])
    group("Check sample input $file passes for part", () {
      late var input;
      setUp(() {
        input = parseInput(
          Utils.readToString('../test_inputs/day07-$file.txt'),
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
      input = parseInput(Utils.readToString('../inputs/day07.txt'));
    });
    test("1", () {
      expect(solvePart1(input), "2299996598890");
    });
    test("2", () {
      expect(solvePart2(input), "362646859298554");
    });
  });

  group("Check getLineValue", () {
    var good = {
      (190, [10, 19]): 190,
      (3267, [81, 40, 27]): 3267,
    };
    good.forEach(
      (input, expected) => test("returns value of good lines: ${expected}", () {
        expect(getLineValue(input.$1, input.$2), expected);
      }),
    );

    var bad = {
      (21037, [9, 7, 18, 13]): 0,
      (192, [17, 8, 14]): 0,
    };
    bad.forEach(
      (input, expected) => test("returns value of good lines: ${expected}", () {
        expect(getLineValue(input.$1, input.$2), expected);
      }),
    );
  });
}
