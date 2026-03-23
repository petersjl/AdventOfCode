import 'package:test/test.dart';
import 'package:utils/data_structures.dart';
import 'package:utils/data_structures/linear_collections.dart';

void main() {
  group('PriorityQueue', () {
    test('enqueue and dequeue keeps priority order', () {
      final queue = PriorityQueue<int>((a, b) => a - b);

      queue.enqueue(5);
      queue.enqueue(1);
      queue.enqueue(3);
      queue.enqueue(2);

      expect(queue.length, 4);
      expect(queue.dequeue(), 1);
      expect(queue.dequeue(), 2);
      expect(queue.dequeue(), 3);
      expect(queue.dequeue(), 5);
      expect(queue.isEmpty, isTrue);
    });

    test('enqueueAll and clear update length and isEmpty', () {
      final queue = PriorityQueue<int>((a, b) => a - b);

      queue.enqueueAll([4, 2, 9]);
      expect(queue.length, 3);
      expect(queue.isEmpty, isFalse);

      queue.clear();
      expect(queue.length, 0);
      expect(queue.isEmpty, isTrue);
    });

    test("contains returns true when the item is in the queue", () {
      final queue = PriorityQueue<String>((a, b) => a.compareTo(b));

      queue.enqueueAll(['apple', 'banana', 'cherry']);
      expect(queue.contains('banana'), isTrue);
      expect(queue.contains('durian'), isFalse);
    });
  });

  group('Stack', () {
    test('push and pop are LIFO', () {
      final stack = Stack<String>();

      stack.push('a');
      stack.push('b');
      stack.push('c');

      expect(stack.length, 3);
      expect(stack.pop(), 'c');
      expect(stack.pop(), 'b');
      expect(stack.pop(), 'a');
      expect(stack.isEmpty, isTrue);
    });

    test('pushBottom and popBottom operate on bottom', () {
      final stack = Stack<int>();

      stack.push(2);
      stack.push(3);
      stack.pushBottom(1);

      expect(stack.length, 3);
      expect(stack.popBottom(), 1);
      expect(stack.pop(), 3);
      expect(stack.pop(), 2);
    });

    test('pop and popBottom throw on empty stack', () {
      final stack = Stack<int>();

      expect(() => stack.pop(), throwsRangeError);
      expect(() => stack.popBottom(), throwsRangeError);
    });
  });

  group('Queue', () {
    test('push and pop are FIFO', () {
      final queue = Queue<int>();

      queue.push(10);
      queue.push(20);
      queue.push(30);

      expect(queue.length, 3);
      expect(queue.pop(), 10);
      expect(queue.pop(), 20);
      expect(queue.pop(), 30);
      expect(queue.isEmpty, isTrue);
    });

    test('pushToFront appends to front and popFromBack removes from back', () {
      final queue = Queue<int>();

      queue.push(2);
      queue.push(1);
      queue.pushToFront(3);

      expect(queue.length, 3);
      expect(queue.popFromBack(), 1);
      expect(queue.pop(), 3);
      expect(queue.pop(), 2);
      expect(queue.isEmpty, isTrue);
    });

    test('contains finds existing values', () {
      final queue = Queue<String>();

      queue.pushAll(['x', 'y', 'z']);

      expect(queue.contains('y'), isTrue);
      expect(queue.contains('missing'), isFalse);
    });

    test('pop and popFromBack throw on empty queue', () {
      final queue = Queue<int>();

      expect(() => queue.pop(), throwsRangeError);
      expect(() => queue.popFromBack(), throwsRangeError);
    });
  });

  group('LinkedList', () {
    test('default constructor starts empty', () {
      final list = LinkedList<int>();

      expect(list.length, 0);
      expect(() => list[0], throwsRangeError);
    });

    test('generate constructor creates values in index order', () {
      final list = LinkedList<int>.generate((i) => i * 10, 4);

      expect(list.length, 4);
      expect(list[0], 0);
      expect(list[1], 10);
      expect(list[2], 20);
      expect(list[3], 30);
    });

    test('fromList constructor copies values in order', () {
      final list = LinkedList<String>.fromList(['a', 'b', 'c']);

      expect(list.length, 3);
      expect(list[0], 'a');
      expect(list[1], 'b');
      expect(list[2], 'c');
    });

    test('add appends to end', () {
      final list = LinkedList<int>();

      list.add(1);
      list.add(2);
      list.add(3);

      expect(list.length, 3);
      expect(list[0], 1);
      expect(list[1], 2);
      expect(list[2], 3);
    });

    test('operator []= updates value at index', () {
      final list = LinkedList<int>.fromList([1, 2, 3]);

      list[1] = 99;

      expect(list[0], 1);
      expect(list[1], 99);
      expect(list[2], 3);
      expect(list.length, 3);
    });

    test('removeAt removes head and updates order', () {
      final list = LinkedList<int>.fromList([1, 2, 3]);

      final removed = list.removeAt(0);

      expect(removed, 1);
      expect(list.length, 2);
      expect(list[0], 2);
      expect(list[1], 3);
    });

    test('removeAt removes middle and keeps links consistent', () {
      final list = LinkedList<int>.fromList([10, 20, 30, 40]);

      final removed = list.removeAt(2);

      expect(removed, 30);
      expect(list.length, 3);
      expect(list[0], 10);
      expect(list[1], 20);
      expect(list[2], 40);
    });

    test('removeAt removes tail', () {
      final list = LinkedList<int>.fromList([7, 8, 9]);

      final removed = list.removeAt(2);

      expect(removed, 9);
      expect(list.length, 2);
      expect(list[0], 7);
      expect(list[1], 8);
    });

    test('removeAt on single-item list leaves list empty', () {
      final list = LinkedList<int>.fromList([42]);

      final removed = list.removeAt(0);

      expect(removed, 42);
      expect(list.length, 0);
      expect(() => list[0], throwsRangeError);
    });

    test('index operations throw on out-of-range indexes', () {
      final list = LinkedList<int>.fromList([1, 2, 3]);

      expect(() => list[-1], throwsRangeError);
      expect(() => list[3], throwsRangeError);
      expect(() => list[-1] = 0, throwsRangeError);
      expect(() => list[3] = 0, throwsRangeError);
      expect(() => list.removeAt(-1), throwsRangeError);
      expect(() => list.removeAt(3), throwsRangeError);
    });

    test('for-in loop iterates items in order', () {
      final list = LinkedList<String>.fromList(['a', 'b', 'c']);
      final seen = <String>[];

      for (var item in list) {
        seen.add(item);
      }

      expect(seen, ['a', 'b', 'c']);
    });
  });
}
