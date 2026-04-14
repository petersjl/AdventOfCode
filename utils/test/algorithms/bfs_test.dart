import 'package:test/test.dart';
import 'package:utils/algorithms.dart' show bfs, bfsAllPairs;
import 'package:utils/dart_utils.dart' show Point;
import 'package:utils/data_structures.dart' show Grid;

void main() {
  final Grid<bool> grid = Grid.fromStringGrid(
    """
    .....
    .###.
    .#...
    .###.
    .#.#.
    """,
    (line) => line.trim().split(''),
    (cell) => cell == '#',
  );

  group('bfs', () {
    test('from one source to a set of targets', () {
      final result = bfs(grid, Point(0, 0), {
        Point(2, 2),
        Point(4, 4),
        Point(2, 4),
      });

      expect(result[Point(2, 2)], 8);
      expect(result[Point(4, 4)], 8);
      expect(result.containsKey(Point(2, 4)), false);
    });

    test('ignores start when included in targets', () {
      final result = bfs(grid, Point(0, 0), {Point(0, 0), Point(2, 2)});

      expect(result.containsKey(Point(0, 0)), false);
      expect(result[Point(2, 2)], 8);
    });

    test('omits unreachable pairs', () {
      final result = bfs(grid, Point(0, 0), {Point(2, 4)});

      expect(result.containsKey(Point(2, 4)), false);
    });
  });

  group('bfsAllPairs', () {
    test('computes symmetric distances', () {
      final p0 = Point(0, 0);
      final p1 = Point(4, 0);
      final p2 = Point(2, 2);

      final result = bfsAllPairs(grid, {p0, p1, p2});

      expect(result[p0]![p1], 4);
      expect(result[p1]![p0], 4);
      expect(result[p0]![p2], 8);
      expect(result[p2]![p0], 8);
      expect(result[p1]![p2], 4);
      expect(result[p2]![p1], 4);
    });

    test('omits unreachable pairs', () {
      final p0 = Point(0, 0);
      final p1 = Point(2, 4);

      final result = bfsAllPairs(grid, {p0, p1});

      expect(result[p0]!.containsKey(p1), false);
      expect(result[p1]!.containsKey(p0), false);
    });
  });
}
