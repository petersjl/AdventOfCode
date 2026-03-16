import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as Path;
import 'dart:io' show File, Platform;

// Random utilites methods
class Utils {
  static String timingString(Duration dur) {
    if (dur.inSeconds != 0)
      return '${dur.inSeconds}.${dur.inMilliseconds.toString().padLeft(3, '0')}s';
    else if (dur.inMilliseconds > 10)
      return '${dur.inMilliseconds}ms';
    else if (dur.inMilliseconds != 0)
      return '${dur.inMilliseconds}.${dur.inMicroseconds.toString().padLeft(3, '0')}ms';
    else
      return '${dur.inMicroseconds}µs';
  }

  static void runWithTiming<T>(
    T parser(String rawInput),
    String part1Solver(T input)?,
    String part2Solver(T input)?,
    String rawInput,
  ) {
    Stopwatch stopwatch = new Stopwatch()..start();
    var inputP1 = parser(rawInput);
    var timeParse = stopwatch.elapsed;
    // Parse again for part 2 to allow any mutations,
    // but don't count that time
    stopwatch.stop();
    var inputP2 = parser(rawInput);

    String solutionP1 = "", solutionP2 = "";
    stopwatch.start();
    if (part1Solver != null) solutionP1 = part1Solver(inputP1);
    var timeP1 = stopwatch.elapsed;
    if (part2Solver != null) solutionP2 = part2Solver(inputP2);
    var timeP2 = stopwatch.elapsed;
    stopwatch.stop();

    print('Parse time: ${Utils.timingString(timeParse)}');
    if (part1Solver != null)
      print(
        'Part 1 (${Utils.timingString(timeP1 - timeParse)}): ${solutionP1}',
      );
    if (part2Solver != null)
      print('Part 2 (${Utils.timingString(timeP2 - timeP1)}): ${solutionP2}');
    print('Ran in ${Utils.timingString(timeP2)}');
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
    var contents = File(to_abs_path(path)).readAsStringSync();
    contents = contents.replaceAll('\r\n', '\n');
    if (contents.isNotEmpty) {
      if (contents.endsWith('\n')) {
        contents = contents.substring(0, contents.length - 1);
      }
    }
    return contents;
  }

  static String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  static int ManhattanDist(Point first, Point second) {
    return (first.x - second.x).abs() + (first.y - second.y).abs();
  }

  static List<int> ParseIntList(String line, {String separator = " "}) {
    return line.split(separator).map((str) => int.parse(str)).toList();
  }

  static List<List<String>> getPointMap(
    Iterable<Point> points,
    int mapHeight,
    int mapWidth,
  ) {
    List<List<String>> map = List.generate(
      mapHeight,
      (i) => List.generate(mapWidth, (j) => "."),
    );
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

  static void gridMap<T>(List<List<T>> grid, T fun(T)) {
    for (int y = 0; y < grid.length; y++) {
      for (int x = 0; x < grid[y].length; x++) {
        grid[y][x] = fun(grid[y][x]);
      }
    }
  }
}

// Extensions
extension StringExtras on String {
  List<String> get characters {
    return this.split('');
  }

  List<String> splitNewLine() {
    return this.split('\n');
  }

  List<String> splitDoubleNewLine() {
    return this.split('\n\n');
  }

  List<String> splitWhitespace() {
    return this.split(new RegExp('\\s+'));
  }
}

extension GenericIterableExtras<T> on Iterable<T> {
  // Use .map().toList()
  List<Out> listMap<Out>(Out fun(T element)) {
    List<Out> list = [];
    for (T e in this) {
      list.add(fun(e));
    }
    return list;
  }

  // Use .where().toList()
  List<T> listWhere(bool fun(T element)) {
    List<T> list = [];
    for (T e in this) {
      if (fun(e)) list.add(e);
    }
    return list;
  }

  // Use .where().length
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

  // Use .fold
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
  Point.clone(Point other) : x = other.x, y = other.y;

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
