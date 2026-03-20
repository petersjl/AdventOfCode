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

class Binode<T> {
  T value;
  Binode<T>? prev;
  Binode<T>? next;

  Binode(this.value);
}
