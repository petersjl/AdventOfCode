class UnionFindInt {
  late List<int> parent;
  late List<int> size;
  int _numSets = 0;

  UnionFindInt(int n) {
    parent = List<int>.generate(n, (i) => i, growable: false);
    size = List<int>.filled(n, 1, growable: false);
    _numSets = n;
  }

  int get numSets => _numSets;
  bool get isSingleSet => _numSets <= 1;
  List<int> get roots {
    List<int> rootsList = [];
    for (int i = 0; i < parent.length; i++) {
      if (parent[i] == i) {
        rootsList.add(i);
      }
    }
    return rootsList;
  }

  int find(int x) {
    var r = x;
    while (parent[r] != r) {
      r = parent[r];
    }
    // Path compression
    if (parent[x] != r) parent[x] = find(parent[x]);
    return r;
  }

  int union(int a, int b) {
    final ra = find(a);
    final rb = find(b);
    if (ra == rb) return size[ra];
    if (size[ra] < size[rb]) {
      parent[ra] = rb;
      size[rb] += size[ra];
      _numSets--;
      return size[rb];
    } else {
      parent[rb] = ra;
      size[ra] += size[rb];
      _numSets--;
      return size[ra];
    }
  }

  int setSize(int x) {
    final r = find(x);
    return size[r];
  }
}
