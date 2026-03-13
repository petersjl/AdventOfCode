import 'package:utils/DartUtils.dart';

class GrowableGrid<T> {
  List<List<T>> _grid;
  int _xOffset;
  int _yOffset;
  T _defaultValue;

  int get xLength => _grid[0].length;
  int get yLength => _grid.length;
  int get size => xLength * yLength;

  GrowableGrid(
    this._defaultValue, [
    int lowX = 0,
    int highX = 0,
    int lowY = 0,
    int highY = 0,
  ]) : _grid = [],
       _xOffset = lowX,
       _yOffset = lowY {
    if (lowX > highX || lowY > highY)
      throw RangeError('Lows cannot be larger than highs');
    _grid = List.generate(
      highY - lowY + 1,
      (index) => List.generate(highX - lowX + 1, ((index) => _defaultValue)),
    );
  }

  T get(int x, int y) {
    var actual = checkAndConvert(x, y);
    return _grid[actual.y][actual.x];
  }

  void set(int x, int y, T value) {
    var actual = checkAndConvert(x, y);
    _grid[actual.y][actual.x] = value;
  }

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
        line.insert(toPositive ? line.length : 0, _defaultValue);
    }
  }

  void _growY(int amount, bool toPositive) {
    for (int i = 0; i < amount; ++i) {
      _grid.insert(
        toPositive ? _grid.length : 0,
        List.generate(_grid[0].length, (index) => _defaultValue),
      );
    }
  }
}

class GrowableList<T> {
  List<T> _list;
  int _offset;
  T _defaultValue;

  int get length => _list.length;

  GrowableList(this._defaultValue, [int low = 0, int high = 0])
    : _list = [],
      _offset = low {
    if (low > high) throw RangeError('Low cannot be greater than high');
    _list = List.generate(high - low + 1, (index) => _defaultValue);
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
      _list.insert(toPositive ? _list.length : 0, _defaultValue);
    }
  }

  void forEach(void action(T element)) {
    for (T element in _list) action(element);
  }
}
