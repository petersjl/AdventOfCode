import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as Path;
import 'dart:io' show File, Platform;

// Random utilites methods
class Utils {
  static String timingString(Duration dur) {
    if (dur.inSeconds != 0)
      return '${dur.inSeconds}.${dur.inMilliseconds.toString().padLeft(3, '0')}s';
    else if (dur.inMilliseconds != 0)
      return '${dur.inMilliseconds}ms';
    else
      return '${dur.inMicroseconds}µs';
  }

  static String to_abs_path(path, [base_dir = null]) {
    Path.Context context;
    if (Platform.isWindows) {
      context = new Path.Context(style: Path.Style.windows);
    } else {
      context = new Path.Context(style: Path.Style.posix);
    }
    base_dir ??= Path.dirname(Platform.script.toFilePath());
    path = context.join(base_dir, path);
    return context.normalize(path);
  }

  static String readToString(path, [base_dir = null]) {
    return File(to_abs_path(path)).readAsStringSync();
  }

  static String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  static int ManhattanDist(Point first, Point second) {
    return (first.x - second.x).abs() + (first.y - second.y).abs();
  }

  static List<int> ParseIntList(String line, {String separator = " "}) {
    return line.split(separator).listMap((str) => int.parse(str));
  }

  static List<List<String>> getPointMap(
      Iterable<Point> points, int mapHeight, int mapWidth) {
    List<List<String>> map =
        List.generate(mapHeight, (i) => List.generate(mapWidth, (j) => "."));
    for (var point in points) {
      map[point.y][point.x] = "#";
    }
    return map;
  }

  static List<List<T>> getGrid<T>(T fill, int height, [int? width]) {
    width = width ?? height;
    return List.generate(height, (_) => List.generate(width!, (_) => fill));
  }

  static List<List<T>> cloneGrid<T>(List<List<T>> orig) {
    var clone = getGrid(orig[0][0], orig.length, orig[0].length);
    for (int row = 0; row < orig.length; row++)
      for (int col = 0; col < orig[0].length; col++)
        clone[row][col] = orig[row][col];
    return clone;
  }
}

// Extensions
extension StringExtras on String {
  List<String> get characters {
    return this.split('');
  }

  List<String> splitNewLine() {
    return this.split('\r\n');
  }

  List<String> splitDoubleNewLine() {
    return this.split('${Platform.lineTerminator}${Platform.lineTerminator}');
  }

  List<String> splitWhitespace() {
    return this.split(new RegExp('\\s+'));
  }
}

extension GenericIterableExtras<T> on Iterable<T> {
  List<Out> listMap<Out>(Out fun(T element)) {
    List<Out> list = [];
    for (T e in this) {
      list.add(fun(e));
    }
    return list;
  }

  List<T> listWhere(bool fun(T element)) {
    List<T> list = [];
    for (T e in this) {
      if (fun(e)) list.add(e);
    }
    return list;
  }

  int count(bool compare(T element)) {
    int count = 0;
    this.forEach((element) {
      if (compare(element)) count++;
    });
    return count;
  }

  T? whereFirst(bool fun(T element)) {
    for (T e in this) if (fun(e)) return e;
    return null;
  }

  Out collect<Out>(Out base, Out fun(Out collected, T element)) {
    Out col = base;
    this.forEach((e) => col = fun(col, e));
    return col;
  }
}

extension ListExtras on List<List<dynamic>> {
  void printFlat([String formatter(dynamic element) = _toString]) {
    StringBuffer s = StringBuffer();
    for (var list in this) {
      list.forEach((element) => s.write(formatter(element)));
      s.write('\n');
    }
    print(s.toString());
  }
}

String _toString(element) => element.toString();

extension MapExtras on Map<dynamic, int> {
  int increment(dynamic key, [int amount = 1]) {
    return update(key, (value) => value + amount, ifAbsent: () => amount);
  }
}

extension GenericMapExtras on Map<dynamic, dynamic> {
  bool where(bool test(dynamic key, dynamic value)) {
    for (MapEntry entry in this.entries) {
      if (test(entry.key, entry.value)) return true;
    }
    return false;
  }

  dynamic whereFirst(bool test(dynamic key, dynamic value)) {
    for (MapEntry entry in this.entries) {
      if (test(entry.key, entry.value)) return entry.value;
    }
    return null;
  }
}

extension MapOfListExtras<K, V> on Map<K, List<V>> {
  List<V> appendToKey(K key, V value) {
    return update(key, (ls) => ls..add(value), ifAbsent: () => [value]);
  }
}

// Classes
class Point {
  static Point origin = Point(0, 0);
  static Point up = Point(0, -1);
  static Point down = Point(0, 1);
  static Point left = Point(-1, 0);
  static Point right = Point(1, 0);
  static List<Point> directions = [up, down, left, right];

  int x, y;
  Point(this.x, this.y);
  Point.clone(Point other)
      : x = other.x,
        y = other.y;

  @override
  // https://en.wikipedia.org/wiki/Pairing_function#Cantor_pairing_function
  // Has a low chance of clashing
  int get hashCode => ((x + y) * (x + y + 1) ~/ 2 + y);

  @override
  operator ==(Object other) {
    if (other is! Point) return false;
    return x == other.x && y == other.y;
  }

  @override
  String toString() {
    return '${this.x}, ${this.y}';
  }

  Point operator +(Point other) {
    return new Point(this.x + other.x, this.y + other.y);
  }

  Point operator -(Point other) {
    return new Point(this.x - other.x, this.y - other.y);
  }

  Point operator *(int scale) {
    return new Point(x * scale, y * scale);
  }

  bool operator <(Point other) {
    // Compares based on the magnitued of each point from (0,0)
    return x.abs() + y.abs() < other.x.abs() + other.y.abs();
  }

  bool operator >(Point other) {
    // Compares based on the magnitued of each point from (0,0)
    return !(this < other);
  }

  // Should only be used on direcitons
  Point rotateClockwise() => Point(-this.y, this.x);
  Point rotateCounterClockwise() => Point(this.y, -this.x);

  /// Assert that this is within the box created by
  /// origin inclusive and farCorner exclusive
  bool isInBounds(Point farCorner, [Point? origin = null]) {
    origin = origin ?? Point.origin;
    return origin.x <= x && x < farCorner.x && origin.y <= y && y < farCorner.y;
  }
}

class Pair<T1, T2> extends Object {
  T1 first;
  T2 second;
  int get length => 2;

  @override
  int get hashCode => '${first.hashCode},${second.hashCode}'.hashCode;

  Pair(this.first, this.second);

  operator [](int index) {
    if (index == 0) return first;
    if (index == 1) return second;
    throw IndexError.withLength(index, 2, indexable: this);
  }

  @override
  operator ==(Object other) {
    if (other is! Pair) return false;
    return first == other.first && second == other.second;
  }

  @override
  String toString() {
    return '($first, $second)';
  }
}

class PriorityQueue<T> {
  int _size = 0;
  List<T> _array;
  Function _comparator;

  int get length => _size;
  bool get isEmpty => _size == 0;

  PriorityQueue(int comparator(T queueItem, T toInsert))
      : _comparator = comparator,
        _array = [];

  void enqueue(T object) {
    for (int i = 0; i < _array.length; ++i) {
      T thing = _array[i];
      // 0 < thing.value - object.value
      if (0 < _comparator(thing, object)) {
        _array.insert(i, object);
        _size++;
        return;
      }
    }
    _array.add(object);
    _size++;
    return;
  }

  void enqueueAll(List<T> items) {
    for (var item in items) enqueue(item);
  }

  T dequeue() {
    _size--;
    return _array.removeAt(0);
  }

  void clear() {
    _array.clear();
    _size = 0;
  }

  @override
  String toString() {
    StringBuffer str = StringBuffer('[');
    str.writeAll(_array, ',');
    str.write(']');
    return str.toString();
  }
}

class Binode<T> {
  T value;
  Binode<T>? prev;
  Binode<T>? next;

  Binode(this.value);
}

class Stack<T> {
  int _size;
  int get length => _size;

  bool get isEmpty => _size == 0;

  Binode<T>? _top;
  Binode<T>? _bottom;

  Stack() : _size = 0;

  void push(T item) {
    Binode<T> node = Binode(item);
    if (_size == 0) {
      _top = node;
      _bottom = node;
    } else {
      _top!.next = node;
      node.prev = _top;
      _top = node;
    }
    _size++;
  }

  void pushAll(List<T> items) {
    for (var item in items) push(item);
  }

  void pushBottom(T item) {
    Binode<T> node = Binode(item);
    if (_size == 0) {
      _top = node;
      _bottom = node;
    } else {
      _bottom!.prev = node;
      node.next = _bottom;
      _bottom = node;
    }
    _size++;
  }

  T pop() {
    if (_size == 0) throw new RangeError("Pop called on empty stack");
    var val = _top!.value;
    if (_size == 1) {
      _top = null;
      _bottom = null;
    } else {
      _top = _top!.prev;
    }
    _size--;
    return val;
  }

  T popBottom() {
    if (_size == 0) throw new RangeError("Pop called on empty stack");
    var val = _bottom!.value;
    if (_size == 1) {
      _top = null;
      _bottom = null;
    } else {
      _bottom = _bottom!.next;
    }
    _size--;
    return val;
  }

  @override
  String toString() {
    var buf = StringBuffer('Top{');
    var cur = _top;
    while (cur != null) {
      buf.write(cur.value);
      buf.write(',');
      cur = cur.prev;
    }
    var str = buf.toString();
    if (_size > 0) str = str.substring(0, str.length - 1);
    return str + '}Bottom';
  }
}

class Queue<T> {
  int _size;
  int get length => _size;

  bool get isEmpty => _size == 0;

  Binode<T>? _start;
  Binode<T>? _end;

  Queue() : _size = 0;

  void push(T item) {
    Binode<T> node = Binode(item);
    if (_size == 0) {
      _start = node;
      _end = node;
    } else {
      _start!.prev = node;
      node.next = _start;
      _start = node;
    }
    _size++;
  }

  void pushAll(List<T> items) {
    for (var item in items) push(item);
  }

  void pushEnd(T item) {
    Binode<T> node = Binode(item);
    if (_size == 0) {
      _start = node;
      _end = node;
    } else {
      _end!.next = node;
      node.prev = _end;
      _end = node;
    }
    _size++;
  }

  T pop() {
    if (_size == 0) throw new RangeError("Pop called on empty stack");
    var val = _end!.value;
    if (_size == 1) {
      _start = null;
      _end = null;
    } else {
      _end = _end!.prev;
    }
    _size--;
    return val;
  }

  T popStart() {
    if (_size == 0) throw new RangeError("Pop called on empty stack");
    var val = _start!.value;
    if (_size == 1) {
      _start = null;
      _end = null;
    } else {
      _start = _start!.next;
    }
    _size--;
    return val;
  }

  bool contains(T value) {
    if (length == 0) return false;
    var current = _start;
    while (current != null) {
      if (current.value == value) return true;
      current = current.next;
    }
    return false;
  }

  @override
  String toString() {
    var buf = StringBuffer('Start{');
    var cur = _start;
    while (cur != null) {
      buf.write(cur.value);
      buf.write(',');
      cur = cur.next;
    }
    var str = buf.toString();
    if (_size > 0) str = str.substring(0, str.length - 1);
    return str + '}End';
  }
}

class GrowableGrid<T> {
  List<List<T>> _grid;
  int _xOffset;
  int _yOffset;
  T _defaultValue;

  int get xLength => _grid[0].length;
  int get yLength => _grid.length;
  int get size => xLength * yLength;

  GrowableGrid(this._defaultValue,
      [int lowX = 0, int highX = 0, int lowY = 0, int highY = 0])
      : _grid = [],
        _xOffset = lowX,
        _yOffset = lowY {
    if (lowX > highX || lowY > highY)
      throw RangeError('Lows cannot be larger than highs');
    _grid = List.generate(highY - lowY + 1,
        (index) => List.generate(highX - lowX + 1, ((index) => _defaultValue)));
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
      _grid.insert(toPositive ? _grid.length : 0,
          List.generate(_grid[0].length, (index) => _defaultValue));
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
