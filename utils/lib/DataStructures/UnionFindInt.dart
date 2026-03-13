/// Disjoint-set (Union-Find) structure for integer node ids `0..n-1`.
///
/// Supports near-constant-time set lookup and merging using path compression
/// and union by size.
class UnionFindInt {
  late List<int> parent;
  late List<int> size;
  int _numSets = 0;

  /// Creates `n` singleton sets, one for each element in `0..n-1`.
  UnionFindInt(int n) {
    parent = List<int>.generate(n, (i) => i, growable: false);
    size = List<int>.filled(n, 1, growable: false);
    _numSets = n;
  }

  /// The current number of disjoint sets.
  int get numSets => _numSets;

  /// Whether all elements are connected into a single set.
  bool get isSingleSet => _numSets <= 1;

  /// The current representative roots for all sets.
  List<int> get roots {
    List<int> rootsList = [];
    for (int i = 0; i < parent.length; i++) {
      if (parent[i] == i) {
        rootsList.add(i);
      }
    }
    return rootsList;
  }

  /// Returns the representative root of `x` with path compression.
  int find(int x) {
    var r = x;
    while (parent[r] != r) {
      r = parent[r];
    }
    // Path compression
    if (parent[x] != r) parent[x] = find(parent[x]);
    return r;
  }

  /// Merges the sets containing `a` and `b` and returns the merged set size.
  ///
  /// If both elements are already in the same set, returns that existing size.
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

  /// Returns the size of the set containing `x`.
  int sizeOf(int x) {
    final r = find(x);
    return size[r];
  }
}
