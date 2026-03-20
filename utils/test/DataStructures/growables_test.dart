import 'package:test/test.dart';
import 'package:utils/data_structures/growables.dart';

void main() {
  group('GrowableGrid', () {
    test('initializes dimensions from bounds and fills defaults', () {
      final grid = GrowableGrid<int>((x, y) => 0, 0, 1, 0, 1);

      expect(grid.xLength, 2);
      expect(grid.yLength, 2);
      expect(grid.size, 4);
      expect(grid.get(0, 0), 0);
      expect(grid.get(1, 1), 0);
    });

    test('throws when low bounds are greater than high bounds', () {
      expect(
        () => GrowableGrid<int>((x, y) => 0, 1, 0, 0, 0),
        throwsRangeError,
      );
      expect(
        () => GrowableGrid<int>((x, y) => 0, 0, 0, 2, 1),
        throwsRangeError,
      );
    });

    test('set and get work inside initial bounds', () {
      final grid = GrowableGrid<String>((x, y) => '.', 0, 1, 0, 1);

      grid.set(1, 0, 'A');
      grid.set(0, 1, 'B');

      expect(grid.get(1, 0), 'A');
      expect(grid.get(0, 1), 'B');
      expect(grid.get(0, 0), '.');
    });

    test('grows to positive x and y and keeps previous values', () {
      final grid = GrowableGrid<int>((x, y) => 0);

      grid.set(0, 0, 7);
      grid.set(2, 2, 9);

      expect(grid.xLength, 3);
      expect(grid.yLength, 3);
      expect(grid.get(0, 0), 7);
      expect(grid.get(2, 2), 9);
      expect(grid.get(1, 1), 0);
    });

    test('grows to negative x and keeps previous values', () {
      final grid = GrowableGrid<String>((x, y) => '.');

      grid.set(0, 0, 'X');
      grid.set(-2, 0, 'Y');

      expect(grid.xLength, 3);
      expect(grid.yLength, 1);
      expect(grid.get(-2, 0), 'Y');
      expect(grid.get(0, 0), 'X');
      expect(grid.get(-1, 0), '.');
    });
  });

  group('GrowableList', () {
    test('initializes length from bounds and fills defaults', () {
      final list = GrowableList<int>((index) => 0, 2, 4);

      expect(list.length, 3);
      expect(list[2], 0);
      expect(list[3], 0);
      expect(list[4], 0);
    });

    test('throws when low is greater than high', () {
      expect(() => GrowableList<int>((index) => 0, 3, 2), throwsRangeError);
    });

    test('grows to positive and negative indexes and keeps values', () {
      final list = GrowableList<String>((index) => '-');

      list[0] = 'a';
      list[3] = 'b';
      list[-2] = 'c';

      expect(list.length, 6);
      expect(list[-2], 'c');
      expect(list[0], 'a');
      expect(list[3], 'b');
      expect(list[1], '-');
    });

    test('forEach visits all values in order', () {
      final list = GrowableList<int>((index) => 0, 0, 2);
      list[0] = 1;
      list[1] = 2;
      list[2] = 3;

      final visited = <int>[];
      list.forEach((value) => visited.add(value));

      expect(visited, [1, 2, 3]);
    });
  });
}
