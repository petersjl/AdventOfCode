// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';
import 'package:utils/data_structures/linear_collections.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day19.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = int;

InputType parseInput(String input) {
  return int.parse(input.trim());
}

String solvePart1(InputType input) {
  var ring = createRing(input);
  while (ring.next != ring) {
    // Remove the next node
    ring.next = ring.next!.next;
    // Move to the next node
    ring = ring.next!;
  }
  return ring.value.toString();
}

String solvePart2(InputType input) {
  int count = input;
  Stack<int> firstHalf = Stack();
  Queue<int> secondHalf = Queue();
  for (int i = 1; i < count ~/ 2 + 1; ++i) firstHalf.push(i);
  for (int i = count ~/ 2 + 1; i <= count; ++i) secondHalf.push(i);
  while (!secondHalf.isEmpty) {
    firstHalf.length > secondHalf.length ? firstHalf.pop() : secondHalf.pop();
    secondHalf.push(firstHalf.popBottom());
    firstHalf.push(secondHalf.pop());
  }
  return firstHalf.pop().toString();
}

Binode<int> createRing(int size) {
  Binode<int> head = Binode(1);
  Binode<int> current = head;
  for (int i = 2; i <= size; i++) {
    final node = Binode(i);
    current.next = node;
    node.prev = current;
    current = node;
  }
  head.prev = current;
  current.next = head;
  return head;
}
