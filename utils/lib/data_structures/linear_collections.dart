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

  bool contains(T value) {
    for (var item in _array) {
      if (item == value) return true;
    }
    return false;
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

  void pushToFront(T item) {
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

  T popFromBack() {
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

class LinkedList<T> extends Iterable<T> {
  int _length;
  int get length => _length;
  Binode<T>? _head;
  Binode<T>? _tail;

  LinkedList() : _length = 0;

  LinkedList.generate(T generator(int index), int count) : _length = count {
    for (int i = 0; i < count; i++) {
      var node = Binode(generator(i));
      if (i == 0) {
        _head = node;
        _tail = node;
      } else {
        _tail!.next = node;
        node.prev = _tail;
        _tail = node;
      }
    }
  }

  LinkedList.fromList(List<T> items) : _length = items.length {
    for (int i = 0; i < items.length; i++) {
      var node = Binode(items[i]);
      if (i == 0) {
        _head = node;
        _tail = node;
      } else {
        _tail!.next = node;
        node.prev = _tail;
        _tail = node;
      }
    }
  }

  void add(T item) {
    var node = Binode(item);
    if (_length == 0) {
      _head = node;
      _tail = node;
    } else {
      _tail!.next = node;
      node.prev = _tail;
      _tail = node;
    }
    _length++;
  }

  T removeAt(int index) {
    if (index < 0 || index >= _length) {
      throw new RangeError("Index out of range: $index");
    }
    Binode<T>? current = _head;
    for (int i = 0; i < index; i++) {
      current = current!.next;
    }
    // Fill in the gap left by current
    if (current!.prev != null) {
      current.prev!.next = current.next;
    } else {
      _head = current.next;
    }
    if (current.next != null) {
      current.next!.prev = current.prev;
    } else {
      _tail = current.prev;
    }
    _length--;
    return current.value;
  }

  operator [](int index) {
    if (index < 0 || index >= _length) {
      throw new RangeError("Index out of range: $index");
    }
    Binode<T>? current = _head;
    for (int i = 0; i < index; i++) {
      current = current!.next;
    }
    return current!.value;
  }

  operator []=(int index, T value) {
    if (index < 0 || index >= _length) {
      throw new RangeError("Index out of range: $index");
    }
    Binode<T>? current = _head;
    for (int i = 0; i < index; i++) {
      current = current!.next;
    }
    current!.value = value;
  }

  Iterator<T> get iterator => _LinkedListIterator(this);
}

class _LinkedListIterator<T> implements Iterator<T> {
  LinkedList<T> _list;
  Binode<T>? _currentNode;
  T? _current;

  _LinkedListIterator(this._list) : _currentNode = null, _current = null;

  @override
  T get current => _current as T;

  @override
  bool moveNext() {
    if (_currentNode == null) {
      _currentNode = _list._head;
    } else {
      _currentNode = _currentNode!.next;
    }
    if (_currentNode != null) {
      _current = _currentNode!.value;
      return true;
    } else {
      _current = null;
      return false;
    }
  }
}

class LinkedRing<T> extends Iterable<T> {
  int _length;
  int get length => _length;
  Binode<T>? _head;

  LinkedRing() : _length = 0;

  LinkedRing.generate(T generator(int index), int count) : _length = count {
    Binode<T>? prev;
    for (int i = 0; i < count; i++) {
      var node = Binode(generator(i));
      if (i == 0) {
        _head = node;
      } else {
        prev!.next = node;
        node.prev = prev;
      }
      prev = node;
    }
    if (prev != null) {
      prev.next = _head;
      _head!.prev = prev;
    }
  }

  LinkedRing.fromList(List<T> items) : _length = items.length {
    Binode<T>? prev;
    for (int i = 0; i < items.length; i++) {
      var node = Binode(items[i]);
      if (i == 0) {
        _head = node;
      } else {
        prev!.next = node;
        node.prev = prev;
      }
      prev = node;
    }
    if (prev != null) {
      prev.next = _head;
      _head!.prev = prev;
    }
  }

  void add(T item) {
    var node = Binode(item);
    if (_length == 0) {
      _head = node;
      node.next = node;
      node.prev = node;
    } else {
      node.next = _head;
      node.prev = _head!.prev;
      _head!.prev!.next = node;
      _head!.prev = node;
    }
    _length++;
  }

  T removeAt(int index) {
    if (_length == 0) {
      throw new RangeError("Ring has length 0");
    }
    // If we have one item, null the head and return the value
    if (_length == 1) {
      final value = _head!.value;
      _head = null;
      _length = 0;
      return value;
    }
    // Normalize into index length to allow negative indexes and indexes larger than length
    var idx = ((index % _length) + _length) % _length;
    Binode<T>? current = _head;
    for (int i = 0; i < idx; i++) {
      current = current!.next;
    }
    // Fill in the gap left by current
    current!.prev!.next = current.next;
    current.next!.prev = current.prev;
    if (current == _head) {
      _head = current.next;
    }
    _length--;
    return current.value;
  }

  operator [](int index) {
    if (_length == 0) {
      throw new RangeError("Ring has length 0");
    }
    var idx = ((index % _length) + _length) % _length;
    Binode<T>? current = _head;
    for (int i = 0; i < idx; i++) {
      current = current!.next;
    }
    return current!.value;
  }

  operator []=(int index, T value) {
    if (_length == 0) {
      throw new RangeError("Ring has length 0");
    }
    var idx = ((index % _length) + _length) % _length;
    Binode<T>? current = _head;
    for (int i = 0; i < idx; i++) {
      current = current!.next;
    }
    current!.value = value;
  }

  Iterator<T> get iterator => _LinkedRingIterator(this);
}

class _LinkedRingIterator<T> implements Iterator<T> {
  LinkedRing<T> _ring;
  Binode<T>? _currentNode;
  T? _current;

  _LinkedRingIterator(this._ring) : _currentNode = null, _current = null;

  @override
  T get current => _current as T;

  @override
  bool moveNext() {
    if (_ring._head == null) return false;

    if (_currentNode == null) {
      _currentNode = _ring._head;
    } else {
      _currentNode = _currentNode!.next;
    }

    _current = _currentNode!.value;
    return true;
  }
}

class Binode<T> {
  T value;
  Binode<T>? prev;
  Binode<T>? next;

  Binode(this.value);
}
