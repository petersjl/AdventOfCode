import 'package:utils/DartUtils.dart';

class Grid<T> {
  late List<List<T>> _grid;

  Grid(T generator(int x, int y), int width, int height) {
    _grid = List.generate(
      height,
      (y) => List.generate(width, (x) => generator(x, y)),
    );
  }
  Grid.fromStringGrid(
    String strGrid,
    List<String> colSeparator(String line),
    T parseCell(String cell),
  ) {
    var lines = strGrid.splitNewLine();
    _grid = [];
    for (var line in lines) {
      var cols = colSeparator(line);
      _grid.add(cols.map((c) => parseCell(c)).toList());
    }
  }
  Grid.fromArrays(List<List<T>> arrays) {
    _grid = arrays.map((row) => row.toList()).toList();
  }

  int get height => _grid.length;
  int get width => _grid.isEmpty ? 0 : _grid[0].length;

  Grid<T> clone() {
    var newGrid = Grid<T>((x, y) => _grid[y][x], _grid[0].length, _grid.length);
    return newGrid;
  }

  void map(T Function(T, Point) fun) {
    for (int y = 0; y < _grid.length; y++) {
      for (int x = 0; x < _grid[y].length; x++) {
        _grid[y][x] = fun(_grid[y][x], Point(x, y));
      }
    }
  }

  int count(bool Function(T, Point) condition) {
    var count = 0;
    for (int y = 0; y < _grid.length; y++) {
      for (int x = 0; x < _grid[y].length; x++) {
        if (condition(_grid[y][x], Point(x, y))) {
          count++;
        }
      }
    }
    return count;
  }

  int countSurroundingWhere(Point p, bool Function(T) condition) {
    return surroundingWhere(p, condition).length;
  }

  List<Point> surroundingWhere(Point p, bool Function(T) condition) {
    var points = <Point>[];
    for (var dx = -1; dx <= 1; dx++) {
      for (var dy = -1; dy <= 1; dy++) {
        if (dx == 0 && dy == 0) continue;
        var newX = p.x + dx;
        var newY = p.y + dy;
        if (newX >= 0 &&
            newX < _grid[0].length &&
            newY >= 0 &&
            newY < _grid.length &&
            condition(_grid[newY][newX])) {
          points.add(Point(newX, newY));
        }
      }
    }
    return points;
  }

  bool surroundingLessThan(Point p, int count, bool Function(T) condition) {
    if (count <= 0) return false;
    return _surroundingWhereShort(
      p,
      condition,
      (found) => found >= count,
      false,
    );
  }

  bool surroundingMoreThan(Point p, int count, bool Function(T) condition) {
    return _surroundingWhereShort(p, condition, (found) => found > count, true);
  }

  bool _surroundingWhereShort(
    Point p,
    bool Function(T) condition, // What counts as found
    bool Function(int) comparator, // Compare against the found count
    bool earlyExit, // What to return when comparator is satisfied
  ) {
    var found = 0;
    for (var dx = -1; dx <= 1; dx++) {
      for (var dy = -1; dy <= 1; dy++) {
        if (dx == 0 && dy == 0) continue;
        var newX = p.x + dx;
        var newY = p.y + dy;
        if (newX >= 0 &&
            newX < _grid[0].length &&
            newY >= 0 &&
            newY < _grid.length &&
            condition(_grid[newY][newX])) {
          found++;
          if (comparator(found)) return earlyExit;
        }
      }
    }
    return !earlyExit;
  }
}
