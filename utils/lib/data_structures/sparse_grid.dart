import 'package:utils/data_structures/grid_base.dart';

class SparseGrid<T> extends GridBase<T> {
  final _grid = <int, Map<int, T>>{};
  final T defaultValue;

  SparseGrid(this.defaultValue);
  @override
  T get(int x, int y) {
    if (!_grid.containsKey(x)) return defaultValue;
    return _grid[x]![y] ?? defaultValue;
  }

  @override
  void set(int x, int y, T value) {
    if (!_grid.containsKey(x)) _grid[x] = {};
    _grid[x]![y] = value;
  }

  @override
  int get width {
    if (_grid.isEmpty) return 0;
    var keys = _grid.keys.iterator;
    keys.moveNext();
    int min = keys.current;
    int max = keys.current;
    while (keys.moveNext()) {
      var x = keys.current;
      if (x < min) min = x;
      if (x > max) max = x;
    }
    return max - min + 1;
  }

  @override
  int get height {
    if (_grid.isEmpty) return 0;
    int? min;
    int? max;
    for (var x in _grid.keys) {
      for (var y in _grid[x]!.keys) {
        min ??= y;
        max ??= y;
        if (y < min) min = y;
        if (y > max) max = y;
      }
    }
    if (min == null || max == null) return 0;
    return max - min + 1;
  }
}
