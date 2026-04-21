import 'package:test/test.dart';
import 'package:utils/data_structures.dart';

void main() {
  group('SparseGrid', () {
    test('returns default value for unset cells', () {
      final grid = SparseGrid<int>(0);

      expect(grid.get(3, 7), 0);
      expect(grid.get(-2, -9), 0);
    });

    test('stores and retrieves set values', () {
      final grid = SparseGrid<String>('.');

      grid.set(2, 4, 'X');
      grid.set(-1, 5, 'Y');

      expect(grid.get(2, 4), 'X');
      expect(grid.get(-1, 5), 'Y');
      expect(grid.get(0, 0), '.');
    });

    test('has zero width and height when empty', () {
      final grid = SparseGrid<int>(0);

      expect(grid.width, 0);
      expect(grid.height, 0);
    });

    test('computes width and height for positive coordinates', () {
      final grid = SparseGrid<int>(0);

      grid.set(2, 3, 1);
      grid.set(5, 8, 2);

      expect(grid.width, 4);
      expect(grid.height, 6);
    });

    test('computes width correctly for negative-only x coordinates', () {
      final grid = SparseGrid<int>(0);

      grid.set(-5, 1, 1);
      grid.set(-3, 2, 2);

      expect(grid.width, 3);
    });

    test('computes height correctly for negative-only y coordinates', () {
      final grid = SparseGrid<int>(0);

      grid.set(1, -7, 1);
      grid.set(2, -4, 2);

      expect(grid.height, 4);
    });

    test('computes dimensions correctly for mixed coordinates', () {
      final grid = SparseGrid<int>(0);

      grid.set(-2, -2, 1);
      grid.set(3, 4, 2);

      expect(grid.width, 6);
      expect(grid.height, 7);
    });
  });
}
