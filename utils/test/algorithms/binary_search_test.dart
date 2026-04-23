import 'package:test/test.dart';
import 'package:utils/algorithms.dart' show binarySearch, binarySearchInt;

void main() {
  group('binarySearch', () {
    test('finds an exact integer match', () {
      final list = [1, 3, 5, 7, 9, 11, 13];
      final result = binarySearch(list, (element) {
        if (element == 7) return 0;
        if (element < 7) return -1;
        return 1;
      });

      expect(result.index, 3);
      expect(result.value, 7);
    });

    test('finds the first element', () {
      final list = [10, 20, 30, 40, 50];
      final result = binarySearch(list, (element) {
        if (element == 10) return 0;
        if (element < 10) return -1;
        return 1;
      });

      expect(result.index, 0);
      expect(result.value, 10);
    });

    test('finds the last element', () {
      final list = [10, 20, 30, 40, 50];
      final result = binarySearch(list, (element) {
        if (element == 50) return 0;
        if (element < 50) return -1;
        return 1;
      });

      expect(result.index, 4);
      expect(result.value, 50);
    });

    test('finds element with custom compare function', () {
      final list = ['apple', 'banana', 'cherry', 'date', 'elderberry'];
      final result = binarySearch(list, (element) {
        if (element == 'cherry') return 0;
        if (element.compareTo('cherry') < 0) return -1;
        return 1;
      });

      expect(result.index, 2);
      expect(result.value, 'cherry');
    });

    test('finds element within specified range', () {
      final list = [1, 2, 3, 4, 5, 6, 7, 8, 9];
      final result = binarySearch(
        list,
        (element) {
          if (element == 6) return 0;
          if (element < 6) return -1;
          return 1;
        },
        start: 3,
        end: 7,
      );

      expect(result.index, 5);
      expect(result.value, 6);
    });

    test('throws exception when element not found', () {
      final list = [1, 3, 5, 7, 9];

      expect(
        () => binarySearch(list, (element) {
          if (element == 4) return 0;
          if (element < 4) return -1;
          return 1;
        }),
        throwsA(isA<Exception>()),
      );
    });

    test('works with single element list', () {
      final list = [42];
      final result = binarySearch(list, (element) {
        if (element == 42) return 0;
        if (element < 42) return -1;
        return 1;
      });

      expect(result.index, 0);
      expect(result.value, 42);
    });

    test('works with list of strings', () {
      final list = ['aaa', 'bbb', 'ccc', 'ddd'];
      final result = binarySearch(list, (element) {
        if (element == 'ccc') return 0;
        if (element.compareTo('ccc') < 0) return -1;
        return 1;
      });

      expect(result.index, 2);
      expect(result.value, 'ccc');
    });

    test('finds element with custom comparator logic', () {
      final list = [2, 4, 6, 8, 10, 12];
      // Find element with value 8
      final result = binarySearch(list, (element) {
        if (element == 8) return 0;
        if (element < 8) return -1;
        return 1;
      });

      expect(result.value, 8);
    });
  });

  group('binarySearchInt', () {
    test('finds an exact value in an unbounded search space', () {
      final result = binarySearchInt((element) {
        if (element == 73) return 0;
        if (element < 73) return -1;
        return 1;
      });

      expect(result, 73);
    });

    test('finds an exact value within the provided bounds', () {
      final result = binarySearchInt(
        (element) {
          if (element == 17) return 0;
          if (element < 17) return -1;
          return 1;
        },
        start: 10,
        end: 20,
      );

      expect(result, 17);
    });

    test('throws when the target is outside the provided bounds', () {
      expect(
        () => binarySearchInt(
          (element) {
            if (element == 17) return 0;
            if (element < 17) return -1;
            return 1;
          },
          start: 0,
          end: 10,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}
