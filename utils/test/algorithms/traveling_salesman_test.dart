import 'package:test/test.dart';
import 'package:utils/algorithms.dart' show travelingSalesman;
import 'package:utils/dart_utils.dart' show Point;

void main() {
  test('finds shortest path without return to start', () {
    final a = Point(0, 0);
    final b = Point(1, 0);
    final c = Point(2, 0);

    final distances = <Point, Map<Point, int>>{
      a: {b: 1, c: 10},
      b: {a: 1, c: 2},
      c: {a: 10, b: 2},
    };

    final result = travelingSalesman(distances, a);

    expect(result.path, [a, b, c]);
    expect(result.totalDistance, 3);
  });

  test('adds final leg back to start when requested', () {
    final a = Point(0, 0);
    final b = Point(1, 0);
    final c = Point(2, 0);

    final distances = <Point, Map<Point, int>>{
      a: {b: 1, c: 10},
      b: {a: 1, c: 2},
      c: {a: 10, b: 2},
    };

    final result = travelingSalesman(distances, a, returnToStart: true);

    expect(result.path, [a, b, c, a]);
    expect(result.totalDistance, 13);
  });

  test('handles single-node graph', () {
    final a = Point(0, 0);

    final distances = <Point, Map<Point, int>>{a: {}};

    final result = travelingSalesman(distances, a, returnToStart: true);

    expect(result.path, [a]);
    expect(result.totalDistance, 0);
  });

  test('finds global optimum when greedy first step is misleading', () {
    final a = Point(0, 0);
    final b = Point(1, 0);
    final c = Point(2, 0);
    final d = Point(3, 0);

    final distances = <Point, Map<Point, int>>{
      a: {b: 1, c: 4, d: 4},
      b: {a: 1, c: 1, d: 3},
      c: {a: 4, b: 1, d: 100},
      d: {a: 4, b: 3, c: 100},
    };

    final result = travelingSalesman(distances, a);

    // A greedy nearest-neighbor walk is A->B->C->D with total 102.
    expect(result.path.first, a);
    expect(result.path[1], isNot(b));
    expect(result.totalDistance, 8);
  });

  test('uses return leg when choosing shortest cycle', () {
    final a = Point(0, 0);
    final b = Point(1, 0);
    final c = Point(2, 0);
    final d = Point(3, 0);

    final distances = <Point, Map<Point, int>>{
      a: {b: 1, c: 2, d: 10},
      b: {a: 1, c: 1, d: 2},
      c: {a: 2, b: 1, d: 1},
      d: {a: 10, b: 2, c: 1},
    };

    final result = travelingSalesman(distances, a, returnToStart: true);

    expect(result.path, [a, b, d, c, a]);
    expect(result.totalDistance, 6);
  });
}
