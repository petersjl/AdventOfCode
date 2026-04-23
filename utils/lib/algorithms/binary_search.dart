({int index, T value}) binarySearch<T>(
  List<T> list,
  int Function(T element) compare, {
  int? start,
  int? end,
}) {
  int left = start ?? 0;
  int right = end ?? list.length - 1;

  while (left <= right) {
    int mid = left + ((right - left) >> 1);
    final element = list[mid];
    final cmp = compare(element);
    if (cmp == 0) {
      return (index: mid, value: element);
    } else if (cmp < 0) {
      left = mid + 1;
    } else {
      right = mid - 1;
    }
  }

  throw Exception('Element not found');
}

int binarySearchInt(int Function(int element) compare, {int? start, int? end}) {
  int left = start ?? 0;
  int right = end ?? 1 << 30;

  while (left <= right) {
    int mid = left + ((right - left) >> 1);
    final cmp = compare(mid);
    if (cmp == 0) {
      return mid;
    } else if (cmp < 0) {
      left = mid + 1;
    } else {
      right = mid - 1;
    }
  }

  throw Exception('Element not found');
}
