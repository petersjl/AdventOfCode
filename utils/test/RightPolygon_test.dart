import 'package:test/test.dart';
import 'package:utils/DataStructures/AxisLine.dart';
import 'package:utils/DataStructures/RightPolygon.dart';
import 'package:utils/DartUtils.dart' show Point;

void main() {
  group('RightPolygon', () {
    final RightPolygon polygon = RightPolygon([
      Point(0, 0),
      Point(4, 0),
      Point(4, 4),
      Point(0, 4),
    ]); // 4x4 square

    group('constructor', () {
      test('throws when no points are given', () {
        expect(() => RightPolygon([]), throwsException);
      });

      test('throws when less than 3 points are given', () {
        expect(() => RightPolygon([Point(0, 0), Point(1, 1)]), throwsException);
      });

      test('throws when lines are not axis-aligned', () {
        expect(
          () => RightPolygon([Point(0, 0), Point(1, 1), Point(2, 2)]),
          throwsException,
        );
      });

      test('creates correct edges', () {
        var edges = polygon.edges;
        expect(edges.length, 4);
        expect(edges, contains(AxisLine(Point(0, 0), Point(4, 0))));
        expect(edges, contains(AxisLine(Point(4, 0), Point(4, 4))));
        expect(edges, contains(AxisLine(Point(4, 4), Point(0, 4))));
        expect(edges, contains(AxisLine(Point(0, 4), Point(0, 0))));
      });
    });

    group('containsPoint', () {
      test('returns true for points inside the polygon', () {
        expect(polygon.containsPoint(Point(1, 1)), isTrue);
      });

      test('returns false for points outside the polygon', () {
        expect(polygon.containsPoint(Point(5, 5)), isFalse);
      });

      for (var point in [
        Point(0, 0),
        Point(4, 0),
        Point(4, 4),
        Point(0, 4),
        Point(0, 2),
      ])
        test(
          'returns true for points on the edge of the polygon: ($point)',
          () {
            expect(polygon.containsPoint(point), isTrue);
          },
        );
    });

    group('intersects', () {
      test('intersecting polygon', () {
        expect(
          polygon.intersects(
            RightPolygon([Point(2, 2), Point(5, 2), Point(5, 5), Point(2, 5)]),
          ),
          isTrue,
        );
      });

      test('non-intersecting polygon', () {
        expect(
          polygon.intersects(
            RightPolygon([Point(5, 5), Point(7, 5), Point(7, 7), Point(5, 7)]),
          ),
          isFalse,
        );
      });

      test('touching polygon', () {
        expect(
          polygon.intersects(
            RightPolygon([Point(4, 0), Point(6, 0), Point(6, 4), Point(4, 4)]),
          ),
          isFalse,
        );
      });
    });

    group('odd polygon', () {
      final oddBall = RightPolygon([
        Point(7, 1),
        Point(11, 1),
        Point(11, 7),
        Point(9, 7),
        Point(9, 5),
        Point(2, 5),
        Point(2, 3),
        Point(7, 3),
      ]);

      for (final point in [
        // vertices
        Point(7, 1),
        Point(11, 1),
        Point(11, 7),
        Point(9, 7),
        Point(9, 5),
        Point(2, 5),
        Point(2, 3),
        Point(7, 3),
        // other
        Point(9, 3),
      ])
        test('contains point ($point)', () {
          expect(oddBall.containsPoint(point), isTrue);
        });

      for (final point in [Point(2, 1)])
        test('does not contain ($point)', () {
          expect(oddBall.containsPoint(point), isFalse);
        });
    });
  });
}
