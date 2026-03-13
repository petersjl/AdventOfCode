import 'package:test/test.dart';
import 'package:utils/data_structures.dart';

void main() {
  group('UnionFindInt', () {
    test('initializes with singleton sets', () {
      final uf = UnionFindInt(5);

      expect(uf.numSets, 5);
      expect(uf.isSingleSet, isFalse);
      expect(uf.roots, [0, 1, 2, 3, 4]);

      for (var i = 0; i < 5; i++) {
        expect(uf.find(i), i);
        expect(uf.sizeOf(i), 1);
      }
    });

    test('union merges two different sets and returns merged size', () {
      final uf = UnionFindInt(4);

      final mergedSize = uf.union(0, 1);

      expect(mergedSize, 2);
      expect(uf.numSets, 3);
      expect(uf.sizeOf(0), 2);
      expect(uf.sizeOf(1), 2);
      expect(uf.find(0), uf.find(1));
      expect(uf.roots.length, 3);
    });

    test('union on already-connected elements is a no-op', () {
      final uf = UnionFindInt(4);
      uf.union(0, 1);

      final mergedSize = uf.union(1, 0);

      expect(mergedSize, 2);
      expect(uf.numSets, 3);
      expect(uf.sizeOf(0), 2);
      expect(uf.sizeOf(1), 2);
    });

    test('multiple unions connect all elements into a single set', () {
      final uf = UnionFindInt(5);

      uf.union(0, 1);
      uf.union(2, 3);
      uf.union(3, 4);
      final finalSize = uf.union(1, 4);

      expect(finalSize, 5);
      expect(uf.numSets, 1);
      expect(uf.isSingleSet, isTrue);
      expect(uf.roots.length, 1);

      final root = uf.find(0);
      for (var i = 1; i < 5; i++) {
        expect(uf.find(i), root);
        expect(uf.sizeOf(i), 5);
      }
    });

    test('find applies path compression', () {
      final uf = UnionFindInt(6);

      uf.union(0, 1);
      uf.union(2, 3);
      uf.union(4, 5);
      uf.union(0, 2);
      uf.union(0, 4);

      final root = uf.find(5);

      expect(root, uf.find(0));
      expect(uf.parent[5], root);
      expect(uf.sizeOf(5), 6);
    });
  });
}
