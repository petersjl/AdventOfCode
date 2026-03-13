import 'package:test/test.dart';
import 'package:utils/DataStructures/AxisLine.dart';
import 'package:utils/DartUtils.dart' show Point;

void main() {
  group('AxisLine', () {
    test('should set correct left,right,top,bottom', () {
      var horizontal = AxisLine(Point(0, 7), Point(0, 5));
      expect(horizontal.left, 0);
      expect(horizontal.right, 0);
      expect(horizontal.top, 7);
      expect(horizontal.bottom, 5);
      var vertical = AxisLine(Point(3, 0), Point(3, 4));
      expect(vertical.left, 3);
      expect(vertical.right, 3);
      expect(vertical.top, 4);
      expect(vertical.bottom, 0);
    });

    test('equality is not start dependent', () {
      expect(
        AxisLine(Point(0, 5), Point(0, 7)),
        equals(AxisLine(Point(0, 7), Point(0, 5))),
      );
    });

    test('non-axis-aligned throws', () {
      expect(() => AxisLine(Point(0, 0), Point(1, 1)), throwsException);
    });

    group('crosses', () {
      test('horizontal does not cross horizontal', () {
        final a = AxisLine(Point(0, 0), Point(5, 0));
        final b = AxisLine(Point(1, 0), Point(6, 0));
        expect(a.crosses(b), isFalse);
        expect(b.crosses(a), isFalse);
      });

      test('vertical does not cross vertical', () {
        final a = AxisLine(Point(0, 0), Point(0, 5));
        final b = AxisLine(Point(0, 1), Point(0, 6));
        expect(a.crosses(b), isFalse);
        expect(b.crosses(a), isFalse);
      });

      test('horizontal crosses vertical at interior point', () {
        final h = AxisLine(Point(0, 2), Point(5, 2));
        final v = AxisLine(Point(3, 0), Point(3, 4));
        expect(h.crosses(v), isTrue);
        expect(v.crosses(h), isTrue);
      });

      test('no cross when ranges do not overlap', () {
        final h = AxisLine(Point(0, 2), Point(2, 2));
        final v = AxisLine(Point(3, 0), Point(3, 4));
        expect(h.crosses(v), isFalse);
        expect(v.crosses(h), isFalse);
      });

      test('crossing at endpoint is not considered crossing', () {
        final h = AxisLine(Point(0, 2), Point(3, 2));
        final v = AxisLine(Point(3, 0), Point(3, 2));
        expect(h.crosses(v), false);
        expect(v.crosses(h), false);
      });
    });

    group('contains', () {
      for (final (first, second, expected) in [
        // horizontal
        (
          AxisLine(Point(1, 0), Point(5, 0)),
          AxisLine(Point(2, 0), Point(4, 0)),
          true,
        ),
        (
          AxisLine(Point(1, 0), Point(5, 0)),
          AxisLine(Point(1, 0), Point(4, 0)),
          true,
        ),
        (
          AxisLine(Point(1, 0), Point(5, 0)),
          AxisLine(Point(2, 0), Point(5, 0)),
          true,
        ),
        (
          AxisLine(Point(1, 0), Point(5, 0)),
          AxisLine(Point(1, 0), Point(5, 0)),
          true,
        ),
        (
          AxisLine(Point(1, 0), Point(5, 0)),
          AxisLine(Point(0, 0), Point(4, 0)),
          false,
        ),
        (
          AxisLine(Point(1, 0), Point(5, 0)),
          AxisLine(Point(2, 0), Point(6, 0)),
          false,
        ),
        (
          AxisLine(Point(1, 0), Point(5, 0)),
          AxisLine(Point(6, 0), Point(8, 0)),
          false,
        ),
        (
          AxisLine(Point(1, 0), Point(5, 0)),
          AxisLine(Point(2, 1), Point(4, 1)),
          false,
        ),
        (
          AxisLine(Point(1, 0), Point(5, 0)),
          AxisLine(Point(2, -1), Point(4, -1)),
          false,
        ),
        // vertical
        (
          AxisLine(Point(0, 1), Point(0, 5)),
          AxisLine(Point(0, 2), Point(0, 4)),
          true,
        ),
        (
          AxisLine(Point(0, 1), Point(0, 5)),
          AxisLine(Point(0, 1), Point(0, 4)),
          true,
        ),
        (
          AxisLine(Point(0, 1), Point(0, 5)),
          AxisLine(Point(0, 2), Point(0, 5)),
          true,
        ),
        (
          AxisLine(Point(0, 1), Point(0, 5)),
          AxisLine(Point(0, 1), Point(0, 5)),
          true,
        ),
        (
          AxisLine(Point(0, 1), Point(0, 5)),
          AxisLine(Point(0, 0), Point(0, 4)),
          false,
        ),
        (
          AxisLine(Point(0, 1), Point(0, 5)),
          AxisLine(Point(0, 2), Point(0, 6)),
          false,
        ),
        (
          AxisLine(Point(0, 1), Point(0, 5)),
          AxisLine(Point(0, 6), Point(0, 8)),
          false,
        ),
        (
          AxisLine(Point(0, 1), Point(0, 5)),
          AxisLine(Point(1, 2), Point(1, 4)),
          false,
        ),
        (
          AxisLine(Point(0, 1), Point(0, 5)),
          AxisLine(Point(-1, 2), Point(-1, 4)),
          false,
        ),
      ])
        test('$first contains $second: $expected', () {
          expect(first.contains(second), expected);
        });
    });

    group('overlaps', () {
      for (final (first, second, expected) in [
        // Horizontal: overlapping ranges
        (
          AxisLine(Point(0, 0), Point(5, 0)),
          AxisLine(Point(3, 0), Point(7, 0)),
          true,
        ),
        // Horizontal: one contains the other
        (
          AxisLine(Point(0, 0), Point(10, 0)),
          AxisLine(Point(2, 0), Point(8, 0)),
          true,
        ),
        // Horizontal: identical lines
        (
          AxisLine(Point(1, 0), Point(5, 0)),
          AxisLine(Point(1, 0), Point(5, 0)),
          true,
        ),
        // Horizontal: different y (no overlap)
        (
          AxisLine(Point(0, 0), Point(5, 0)),
          AxisLine(Point(3, 1), Point(7, 1)),
          false,
        ),
        // Horizontal: disjoint ranges (no overlap)
        (
          AxisLine(Point(0, 0), Point(2, 0)),
          AxisLine(Point(3, 0), Point(5, 0)),
          false,
        ),
        // Horizontal: touching at endpoint counts as overlap
        (
          AxisLine(Point(0, 0), Point(3, 0)),
          AxisLine(Point(3, 0), Point(6, 0)),
          true,
        ),
        // Vertical: overlapping ranges
        (
          AxisLine(Point(0, 0), Point(0, 5)),
          AxisLine(Point(0, 3), Point(0, 7)),
          true,
        ),
        // Vertical: one contains the other
        (
          AxisLine(Point(0, 0), Point(0, 10)),
          AxisLine(Point(0, 2), Point(0, 8)),
          true,
        ),
        // Vertical: identical lines
        (
          AxisLine(Point(3, 1), Point(3, 5)),
          AxisLine(Point(3, 1), Point(3, 5)),
          true,
        ),
        // Vertical: different x (no overlap)
        (
          AxisLine(Point(0, 0), Point(0, 5)),
          AxisLine(Point(1, 0), Point(1, 5)),
          false,
        ),
        // Vertical: disjoint ranges (no overlap)
        (
          AxisLine(Point(0, 0), Point(0, 2)),
          AxisLine(Point(0, 3), Point(0, 5)),
          false,
        ),
        // Vertical: touching at endpoint counts as overlap
        (
          AxisLine(Point(0, 0), Point(0, 3)),
          AxisLine(Point(0, 3), Point(0, 6)),
          true,
        ),
      ])
        test('$first overlaps $second: $expected', () {
          expect(first.overlaps(second), expected);
          expect(second.overlaps(first), expected);
        });
    });

    group('containsPoint', () {
      for (var (line, point, expected) in [
        // Horizontal
        (AxisLine(Point(0, 0), Point(5, 0)), Point(3, 0), true),
        (AxisLine(Point(0, 0), Point(5, 0)), Point(0, 0), true),
        (AxisLine(Point(0, 0), Point(5, 0)), Point(5, 0), true),
        (AxisLine(Point(0, 0), Point(5, 0)), Point(7, 0), false),
        (AxisLine(Point(0, 0), Point(5, 0)), Point(-1, 0), false),
        (AxisLine(Point(0, 0), Point(5, 0)), Point(3, 1), false),
        //Vertical
        (AxisLine(Point(0, 0), Point(0, 5)), Point(0, 3), true),
        (AxisLine(Point(0, 0), Point(0, 5)), Point(0, 0), true),
        (AxisLine(Point(0, 0), Point(0, 5)), Point(0, 5), true),
        (AxisLine(Point(0, 0), Point(0, 5)), Point(0, 7), false),
        (AxisLine(Point(0, 0), Point(0, 5)), Point(0, -1), false),
        (AxisLine(Point(0, 0), Point(0, 5)), Point(1, 3), false),
      ])
        test('line $line contains ($point) should be $expected', () {
          expect(line.containsPoint(point), expected);
        });
    });
  });
}
