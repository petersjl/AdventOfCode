// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day13.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = List<ClawMachine>;

class ClawMachine {
  Point A, B, P;
  ClawMachine(Point A, Point B, Point P) : A = A, B = B, P = P {}
}

InputType parseInput(String input) {
  return input.splitDoubleNewLine().map((group) {
    var points = group.splitNewLine().map((line) {
      var halves = line.split(', ');
      var x = halves[0].substring(halves[0].indexOf('X') + 2);
      var y = halves[1].substring(2);
      return Point(int.parse(x), int.parse(y));
    }).toList();
    return ClawMachine(points[0], points[1], points[2]);
  }).toList();
}

(int, int) findButtonsForClaw(ClawMachine m, [int offset = 0]) {
  Point P = m.P + Point(offset, offset);
  int A = (m.B.y * P.x - m.B.x * P.y) ~/ (m.B.y * m.A.x - m.B.x * m.A.y);
  int B = (P.y - A * m.A.y) ~/ m.B.y;
  if (A * m.A.x + B * m.B.x == P.x && A * m.A.y + B * m.B.y == P.y)
    return (A, B);
  else
    return (-1, -1);
}

String solvePart1(InputType input) {
  int price = 0;
  for (var machine in input) {
    var (A, B) = findButtonsForClaw(machine);
    if (A == -1) continue;
    price += 3 * A + B;
  }
  return price.toString();
}

String solvePart2(InputType input) {
  int price = 0;
  int offset = 10000000000000;
  for (var machine in input) {
    var (A, B) = findButtonsForClaw(machine, offset);
    if (A == -1) continue;
    price += 3 * A + B;
  }
  return price.toString();
}
