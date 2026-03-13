import 'package:test/test.dart';
import 'package:utils/DataStructures.dart';

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
}
