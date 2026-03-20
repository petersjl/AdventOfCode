import 'package:test/test.dart';
import 'package:utils/algorithms.dart' show aStar;
import 'package:utils/dart_utils.dart' show Point, Utils;
import 'package:utils/data_structures.dart';

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

  for (var (start, expected) in [
    (Point(0, 0), 8),
    (Point(4, 0), 4),
    (Point(0, 4), 12),
    (Point(4, 4), 4),
    (Point(2, 4), null),
  ])
    test("astar from $start should be $expected", () {
      var result = aStar(
        grid,
        start,
        Point(2, 2),
        (p) => Utils.ManhattanDist(p, Point(2, 2)),
      );
      expect(result, expected);
    });
}
