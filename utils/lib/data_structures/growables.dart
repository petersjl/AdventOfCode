import 'package:utils/dart_utils.dart';
import 'package:utils/data_structures/grid_base.dart' show GridBase;

class GrowableGrid<T> extends GridBase<T> {
  List<List<T>> _grid;
  int _xOffset;
  int _yOffset;
  T Function(int x, int y) _defaultGenerator;
  bool _allowNegative;

  int get xLength => _grid[0].length;
  int get yLength => _grid.length;
  int get size => xLength * yLength;

  GrowableGrid(
    T Function(int x, int y) defaultGenerator, [
    int lowX = 0,
    int highX = 0,
    int lowY = 0,
    int highY = 0,
    bool allowNegative = true,
  ]) : _grid = [],
       _defaultGenerator = defaultGenerator,
       _xOffset = lowX,
       _yOffset = lowY,
       _allowNegative = allowNegative {
    if (!allowNegative && (lowX < 0 || lowY < 0))
      throw RangeError(
        'Negative bounds not allowed when allowNegative is false',
      );
    if (lowX > highX || lowY > highY)
      throw RangeError('Lows cannot be larger than highs');
    _grid = List.generate(
      highY - lowY + 1,
      (y) => List.generate(
        highX - lowX + 1,
        (x) => _defaultGenerator(x + lowX, y + lowY),
      ),
    );
  }

  T get(int x, int y) {
    if (!_allowNegative && (x < 0 || y < 0))
      throw RangeError(
        'Negative indexes not allowed when allowNegative is false',
      );
    var actual = checkAndConvert(x, y);
    return _grid[actual.y][actual.x];
  }

  void set(int x, int y, T value) {
    if (!_allowNegative && (x < 0 || y < 0))
      throw RangeError(
        'Negative indexes not allowed when allowNegative is false',
      );
    var actual = checkAndConvert(x, y);
    _grid[actual.y][actual.x] = value;
  }

  int get width => xLength;
  int get height => yLength;

  Point checkAndConvert(int x, int y) {
    var xActual = x - _xOffset;
    var yActual = y - _yOffset;
    if (xActual < 0) {
      var increase = xActual * -1;
      _growX(increase, false);
      _xOffset -= increase;
      xActual = 0;
    } else if (xActual >= _grid[0].length) {
      _growX(xActual - _grid[0].length + 1, true);
    }
    if (yActual < 0) {
      var increase = yActual * -1;
      _growX(increase, false);
      _yOffset -= increase;
      yActual = 0;
    } else if (yActual >= _grid.length) {
      _growY(yActual - _grid.length + 1, true);
    }
    return Point(xActual, yActual);
  }

  void _growX(int amount, bool toPositive) {
    for (int i = 0; i < amount; ++i) {
      for (var line in _grid)
        line.insert(
          toPositive ? line.length : 0,
          _defaultGenerator(toPositive ? line.length : 0, i),
        );
    }
  }

  void _growY(int amount, bool toPositive) {
    for (int i = 0; i < amount; ++i) {
      _grid.insert(
        toPositive ? _grid.length : 0,
        List.generate(
          _grid[0].length,
          (index) => _defaultGenerator(index, toPositive ? _grid.length : 0),
        ),
      );
    }
  }
}

class GrowableList<T> {
  List<T> _list;
  int _offset;
  T Function(int index) _defaultGenerator;

  int get length => _list.length;

  GrowableList(
    T Function(int index) defaultGenerator, [
    int low = 0,
    int high = 0,
  ]) : _list = [],
       _defaultGenerator = defaultGenerator,
       _offset = low {
    if (low > high) throw RangeError('Low cannot be greater than high');
    _list = List.generate(
      high - low + 1,
      (index) => _defaultGenerator(index + low),
    );
  }

  operator [](int i) => _list[checkAndConvert(i)];

  operator []=(int i, T value) => _list[checkAndConvert(i)] = value;

  int checkAndConvert(int i) {
    var actual = i - _offset;
    if (actual < 0) {
      var increase = actual * -1;
      _grow(increase, false);
      _offset -= increase;
      actual = 0;
    } else if (actual >= _list.length) {
      _grow(actual - _list.length + 1, true);
    }
    return actual;
  }

  void _grow(int amount, bool toPositive) {
    for (int i = 0; i < amount; ++i) {
      _list.insert(
        toPositive ? _list.length : 0,
        _defaultGenerator(toPositive ? _list.length : 0),
      );
    }
  }

  void forEach(void action(T element)) {
    for (T element in _list) action(element);
  }
}
