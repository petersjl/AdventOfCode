// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';
import 'package:utils/data_structures.dart' show PriorityQueue;

void main() {
  var rawInput = Utils.readToString("../inputs/day16.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = (List<List<int>>, Point, Point);

InputType parseInput(String input) {
  Point? start = null;
  Point? end = null;
  List<List<int>> map = [];
  for (var (row, line) in input.splitNewLine().indexed) {
    List<int> mapLine = [];
    for (var (col, char) in line.characters.indexed) {
      switch (char) {
        case "S":
          {
            start = Point(col, row);
            mapLine.add(0);
          }
        case "E":
          {
            end = Point(col, row);
            mapLine.add(0);
          }
        case "#":
          mapLine.add(1);
        default:
          mapLine.add(0);
      }
    }
    map.add(mapLine);
  }
  if (start == null) throw Exception("Could not find 'start' in input");
  if (end == null) throw Exception("Could not find 'end' in input");
  return (map, start, end);
}

class Runner {
  int score;
  Point pos, dir;
  Runner(int score, Point pos, Point dir)
    : score = score,
      pos = pos,
      dir = dir {}
}

int findLowestScore(List<List<int>> map, Point start, Point end) {
  Set<Point> visited = {start};
  PriorityQueue<Runner> queue = PriorityQueue(
    (item, toAdd) => item.score - toAdd.score,
  );
  queue.enqueue(Runner(0, start, Point.right));
  while (!queue.isEmpty) {
    var current = queue.dequeue();
    var forward = current.pos + current.dir;
    if (forward == end) return current.score + 1;
    if (map[forward.y][forward.x] == 0 && visited.add(forward))
      queue.enqueue(Runner(current.score + 1, forward, current.dir));
    var turnLeft = current.dir.rotateCounterClockwise();
    var moveLeft = current.pos + turnLeft;
    if (moveLeft == end) return current.score + 1001;
    if (map[moveLeft.y][moveLeft.x] == 0 && visited.add(moveLeft))
      queue.enqueue(Runner(current.score + 1001, moveLeft, turnLeft));
    var turnRight = current.dir.rotateClockwise();
    var moveRight = current.pos + turnRight;
    if (moveRight == end) return current.score + 1001;
    if (map[moveRight.y][moveRight.x] == 0 && visited.add(moveRight))
      queue.enqueue(Runner(current.score + 1001, moveRight, turnRight));
  }
  return -1;
}

String solvePart1(InputType input) {
  var (map, start, end) = input;
  int score = findLowestScore(map, start, end);
  return score.toString();
}

class PathRunner {
  int score;
  Point pos, dir;
  Set<Point> path;
  PathRunner(int score, Point pos, Point dir, Set<Point> path)
    : score = score,
      pos = pos,
      dir = dir,
      path = path {}
}

int findSeats(List<List<int>> map, Point start, Point end) {
  PriorityQueue<PathRunner> queue = PriorityQueue(
    (item, toAdd) => item.score - toAdd.score,
  );
  int lowestScore = findLowestScore(map, start, end);
  Set<Point> seats = {start, end};
  queue.enqueue(PathRunner(0, start, Point.right, {}));
  while (!queue.isEmpty) {
    var current = queue.dequeue();
    if (current.pos == end) {
      seats.addAll(current.path);
      continue;
    }

    var forward = current.pos + current.dir;
    var forwardPath = Set<Point>.from(current.path);
    if (map[forward.y][forward.x] == 0 && forwardPath.add(forward)) {
      var forwardRunner = PathRunner(
        current.score + 1,
        forward,
        current.dir,
        forwardPath,
      );
      if (forwardRunner.score <= lowestScore) queue.enqueue(forwardRunner);
    }

    var turnLeft = current.dir.rotateCounterClockwise();
    var moveLeft = current.pos + turnLeft;
    var leftPath = Set<Point>.from(current.path);
    if (map[moveLeft.y][moveLeft.x] == 0 && leftPath.add(moveLeft)) {
      var leftRunner = PathRunner(
        current.score + 1001,
        moveLeft,
        turnLeft,
        leftPath,
      );
      if (leftRunner.score <= lowestScore) queue.enqueue(leftRunner);
    }

    var turnRight = current.dir.rotateClockwise();
    var moveRight = current.pos + turnRight;
    var rightPath = Set<Point>.from(current.path);
    if (map[moveRight.y][moveRight.x] == 0 && rightPath.add(moveRight)) {
      var rightRunner = PathRunner(
        current.score + 1001,
        moveRight,
        turnRight,
        rightPath,
      );
      if (rightRunner.score <= lowestScore) queue.enqueue(rightRunner);
    }
  }
  return seats.length;
}

String solvePart2(InputType input) {
  var (map, start, end) = input;
  int seats = findSeats(map, start, end);
  return seats.toString();
}
