class _ParentTreeNode<T> {
  int size;
  _ParentTreeNode<T>? parent;
  T value;

  @override
  int get hashCode => this.value.hashCode;
  @override
  bool operator ==(Object other) {
    if (other is _ParentTreeNode<T>)
      return this.value == other.value;
    else
      return false;
  }

  _ParentTreeNode(this.value) : this.size = 1;
}

class UnionFind<T> {
  Map<T, _ParentTreeNode<T>> nodes = {};
  int _numSets = 0;

  UnionFind();
  UnionFind.fromList(List<T> elements) {
    for (var element in elements) {
      nodes[element] = _ParentTreeNode<T>(element);
      _numSets++;
    }
  }

  /// Return a list of the size of each set
  List<int> get setSizes => nodes.entries
      .where((e) => e.value.size > 0)
      .map((e) => e.value.size)
      .toList();

  /// Add an element as a new set
  void add(T element) {
    if (!nodes.containsKey(element)) {
      nodes[element] = _ParentTreeNode<T>(element);
      _numSets++;
    }
  }

  /// Number of disjoint sets currently present
  int get numSets => _numSets;

  /// True if all elements are in one set (i.e., fully connected)
  bool get isSingleSet => _numSets <= 1;

  /// Find the size and representative of the set containing the element
  (int, T)? find(T element) {
    var node = nodes[element];
    if (node == null) return null;

    // Find root
    var root = node;
    while (root.parent != null) {
      root = root.parent!;
    }

    // Path compression: make all nodes on the path point directly to root
    var current = node;
    while (current.parent != null && current.parent != root) {
      final next = current.parent!;
      current.parent = root;
      current = next;
    }

    return (root.size, root.value);
  }

  /// Merge the sets containing the two elements and return the size of the resulting set
  int union(T first, T second) {
    var rootFirst = find(first);
    var rootSecond = find(second);
    if (rootFirst == null || rootSecond == null) return 0;

    var (sizeFirst, rootValueFirst) = rootFirst;
    var (sizeSecond, rootValueSecond) = rootSecond;

    if (rootValueFirst == rootValueSecond) return sizeFirst;

    var nodeFirst = nodes[rootValueFirst]!;
    var nodeSecond = nodes[rootValueSecond]!;

    if (nodeFirst.size < nodeSecond.size) {
      nodeFirst.parent = nodeSecond;
      nodeSecond.size += nodeFirst.size;
      // Only roots keep size
      nodeFirst.size = 0;
      _numSets--;
      return nodeSecond.size;
    } else {
      nodeSecond.parent = nodeFirst;
      nodeFirst.size += nodeSecond.size;
      // Only roots keep size
      nodeSecond.size = 0;
      _numSets--;
      return nodeFirst.size;
    }
  }
}
