import 'package:test/test.dart';
import 'package:utils/DartUtils.dart';
import 'package:utils/Grid.dart';

void main() {
  var grid = Grid.fromArrays([
    [0, 1, 0],
    [1, 0, 1],
    [0, 1, 0],
  ]);

  group('surroundingLessThan', () {
    group('center point', () {
      for (var count in [0, 1, 2, 3, 4, 5, 6, 7, 8]) {
        test('count $count', () {
          expect(
            grid.surroundingLessThan(Point(1, 1), count, (v) => v == 1),
            count > 4,
          );
        });
      }
    });
    group('corner point', () {
      for (var count in [0, 1, 2, 3]) {
        test('count $count', () {
          expect(
            grid.surroundingLessThan(Point(0, 0), count, (v) => v == 1),
            count > 2,
          );
        });
      }
    });
  });
  group('surroundingMoreThan', () {
    group('center point', () {
      for (var count in [0, 1, 2, 3, 4, 5, 6, 7, 8]) {
        test('count $count', () {
          expect(
            grid.surroundingMoreThan(Point(1, 1), count, (v) => v == 1),
            count < 4,
          );
        });
      }
    });
    group('corner point', () {
      for (var count in [0, 1, 2, 3]) {
        test('count $count', () {
          expect(
            grid.surroundingMoreThan(Point(0, 0), count, (v) => v == 1),
            count < 2,
          );
        });
      }
    });
  });
}
