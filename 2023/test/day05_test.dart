import '../bin/day05.dart' hide main;
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'package:utils/dart_utils.dart';

const String DAY = '05';

Mapping _mapping(
  String from,
  String to,
  List<(int target, int source, int length)> rows,
) {
  final body = rows.map((r) => '${r.$1} ${r.$2} ${r.$3}').join('\n');
  return Mapping('$from-to-$to map:\n$body');
}

void _expectRanges(
  Mapping mapping,
  List<(int target, int source, int length)> expected,
) {
  final actualSorted = [...mapping.ranges]
    ..sort(
      (a, b) =>
          a.target != b.target ? a.target - b.target : a.source - b.source,
    );
  final expectedSorted = [...expected]
    ..sort((a, b) => a.$1 != b.$1 ? a.$1 - b.$1 : a.$2 - b.$2);

  expect(actualSorted.length, expectedSorted.length);
  for (var i = 0; i < expectedSorted.length; i++) {
    final actual = actualSorted[i];
    final e = expectedSorted[i];
    expect(actual.target, e.$1, reason: 'target mismatch at index $i');
    expect(actual.source, e.$2, reason: 'source mismatch at index $i');
    expect(actual.length, e.$3, reason: 'length mismatch at index $i');
  }
}

void _expectRangeList(
  List<Range> actual,
  List<(int target, int source, int length)> expected,
) {
  expect(actual.length, expected.length);
  for (var i = 0; i < expected.length; i++) {
    final range = actual[i];
    final e = expected[i];
    expect(range.target, e.$1, reason: 'target mismatch at index $i');
    expect(range.source, e.$2, reason: 'source mismatch at index $i');
    expect(range.length, e.$3, reason: 'length mismatch at index $i');
  }
}

void main() {
  if (DAY.isEmpty) {
    throw Exception("Please set the DAY constant to the day being tested.");
  }
  for (var (file, p1, p2) in [('A', "35", "46")])
    group("Check sample input $file passes for part", () {
      late var input;
      setUp(() {
        input = parseInput(
          Utils.readToString('../test_inputs/day$DAY-$file.txt'),
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
      input = parseInput(Utils.readToString('../inputs/day$DAY.txt'));
    });
    const part1Answer = "175622908";
    const part2Answer = "5200543";
    test("1", () {
      expect(solvePart1(input), part1Answer);
    }, skip: part1Answer.isEmpty);
    test("2", () {
      expect(solvePart2(input), part2Answer);
    }, skip: part2Answer.isEmpty);
  });

  group('Range.merge', () {
    test('returns one range for perfect overlap', () {
      final result = Range(50, 98, 2).merge(Range(100, 50, 2));

      _expectRangeList(result, [(100, 98, 2)]);
    });

    test('returns two ranges when starts match and only one side extends', () {
      final result = Range(10, 100, 10).merge(Range(300, 10, 5));

      _expectRangeList(result, [(300, 100, 5), (15, 105, 5)]);
    });

    test('returns two ranges when ends match and only one side extends', () {
      final result = Range(15, 105, 5).merge(Range(300, 10, 10));

      _expectRangeList(result, [(300, 10, 5), (305, 105, 5)]);
    });

    test('returns three ranges when overlap is in the middle', () {
      final result = Range(10, 100, 10).merge(Range(500, 13, 3));

      _expectRangeList(result, [(10, 100, 3), (500, 103, 3), (16, 106, 4)]);
    });

    test('returns three ranges when other fully encapsulates this', () {
      final result = Range(10, 100, 5).merge(Range(500, 8, 10));

      _expectRangeList(result, [(500, 8, 2), (502, 100, 5), (507, 15, 3)]);
    });
  });

  group('Mapping.mergeRanges', () {
    test('keeps range unchanged when other has no overlap', () {
      final a = _mapping('seed', 'soil', [(50, 98, 2)]);
      final b = _mapping('soil', 'fertilizer', [(200, 10, 5)]);

      a.mergeRanges(b);

      _expectRanges(a, [(200, 10, 5), (50, 98, 2)]);
    });

    test('fully overlaps and shifts entire range', () {
      final a = _mapping('seed', 'soil', [(50, 98, 2)]);
      final b = _mapping('soil', 'fertilizer', [(100, 50, 2)]);

      a.mergeRanges(b);

      _expectRanges(a, [(100, 98, 2)]);
    });

    test('partial overlap at start splits into mapped and passthrough', () {
      final a = _mapping('seed', 'soil', [(10, 100, 10)]); // 100..109 -> 10..19
      final b = _mapping('soil', 'fertilizer', [
        (200, 10, 5),
      ]); // 10..14 -> 200..204

      a.mergeRanges(b);

      _expectRanges(a, [(200, 100, 5), (15, 105, 5)]);
    });

    test('partial overlap at end splits into passthrough and mapped', () {
      final a = _mapping('seed', 'soil', [(10, 100, 10)]); // 100..109 -> 10..19
      final b = _mapping('soil', 'fertilizer', [
        (300, 15, 5),
      ]); // 15..19 -> 300..304

      a.mergeRanges(b);

      _expectRanges(a, [(10, 100, 5), (300, 105, 5)]);
    });

    test('middle overlap creates three segments', () {
      final a = _mapping('seed', 'soil', [(10, 100, 10)]); // 100..109 -> 10..19
      final b = _mapping('soil', 'fertilizer', [
        (500, 13, 3),
      ]); // 13..15 -> 500..502

      a.mergeRanges(b);

      _expectRanges(a, [(10, 100, 3), (500, 103, 3), (16, 106, 4)]);
    });

    test('single source range overlaps multiple other ranges', () {
      final a = _mapping('seed', 'soil', [
        (20, 1000, 8),
      ]); // 1000..1007 -> 20..27
      final b = _mapping('soil', 'fertilizer', [
        (100, 21, 2), // 21..22 -> 100..101
        (200, 24, 2), // 24..25 -> 200..201
      ]);

      a.mergeRanges(b);

      _expectRanges(a, [
        (20, 1000, 1),
        (100, 1001, 2),
        (23, 1003, 1),
        (200, 1004, 2),
        (26, 1006, 2),
      ]);
    });

    test('unmatched other range is preserved in result', () {
      final a = _mapping('seed', 'soil', [(50, 10, 5)]);
      final b = _mapping('soil', 'fertilizer', [(999, 1, 2), (150, 50, 5)]);

      a.mergeRanges(b);

      _expectRanges(a, [(999, 1, 2), (150, 10, 5)]);
    });
  });
}
