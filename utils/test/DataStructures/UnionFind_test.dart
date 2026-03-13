import 'package:test/test.dart';
import 'package:utils/data_structures.dart';

void main() {
  group('UnionFind<T>', () {
    test('empty constructor starts with zero sets', () {
      final uf = UnionFind<String>();

      expect(uf.numSets, 0);
      expect(uf.isSingleSet, isTrue);
      expect(uf.setSizes, isEmpty);
      expect(uf.find('missing'), isNull);
    });

    test('add creates singleton sets and ignores duplicates', () {
      final uf = UnionFind<String>();

      uf.add('a');
      uf.add('b');
      uf.add('a');

      expect(uf.numSets, 2);
      expect(uf.isSingleSet, isFalse);
      expect(uf.find('a'), (1, 'a'));
      expect(uf.find('b'), (1, 'b'));
      expect(uf.setSizes, unorderedEquals([1, 1]));
    });

    test('fromList initializes one set per element', () {
      final uf = UnionFind<int>.fromList([10, 20, 30]);

      expect(uf.numSets, 3);
      expect(uf.isSingleSet, isFalse);
      expect(uf.find(10), (1, 10));
      expect(uf.find(20), (1, 20));
      expect(uf.find(30), (1, 30));
      expect(uf.setSizes, unorderedEquals([1, 1, 1]));
    });

    test('union merges two sets and returns merged size', () {
      final uf = UnionFind<String>.fromList(['a', 'b', 'c']);

      final mergedSize = uf.union('a', 'b');

      expect(mergedSize, 2);
      expect(uf.numSets, 2);
      expect(uf.find('a')!.$1, 2);
      expect(uf.find('b')!.$1, 2);
      expect(uf.find('a')!.$2, uf.find('b')!.$2);
      expect(uf.setSizes, unorderedEquals([2, 1]));
    });

    test('union already-connected elements is a no-op', () {
      final uf = UnionFind<String>.fromList(['a', 'b', 'c']);
      uf.union('a', 'b');

      final mergedSize = uf.union('b', 'a');

      expect(mergedSize, 2);
      expect(uf.numSets, 2);
      expect(uf.setSizes, unorderedEquals([2, 1]));
    });

    test('union with missing element returns 0 and does not change sets', () {
      final uf = UnionFind<String>.fromList(['a', 'b']);

      final mergedSize = uf.union('a', 'missing');

      expect(mergedSize, 0);
      expect(uf.numSets, 2);
      expect(uf.setSizes, unorderedEquals([1, 1]));
    });

    test('multiple unions eventually create one set', () {
      final uf = UnionFind<int>.fromList([0, 1, 2, 3, 4]);

      uf.union(0, 1);
      uf.union(2, 3);
      uf.union(3, 4);
      final finalSize = uf.union(1, 4);

      expect(finalSize, 5);
      expect(uf.numSets, 1);
      expect(uf.isSingleSet, isTrue);
      expect(uf.setSizes, [5]);

      final representative = uf.find(0)!.$2;
      for (final value in [1, 2, 3, 4]) {
        expect(uf.find(value)!.$1, 5);
        expect(uf.find(value)!.$2, representative);
      }
    });
  });
}
