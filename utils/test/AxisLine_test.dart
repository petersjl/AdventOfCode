import 'package:test/test.dart';
import 'package:utils/DataStructures/AxisLine.dart';
import 'package:utils/DartUtils.dart' show Point;

void main() {
  group('AxisLine.crosses', () {
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

    test('crossing at endpoint is considered crossing', () {
      final h = AxisLine(Point(0, 2), Point(3, 2));
      final v = AxisLine(Point(3, 0), Point(3, 2));
      expect(h.crosses(v), isTrue);
      expect(v.crosses(h), isTrue);
    });

    test('non-axis-aligned throws', () {
      expect(() => AxisLine(Point(0, 0), Point(1, 1)), throwsException);
    });
  });
}
