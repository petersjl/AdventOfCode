abstract class GridBase<T> {
  T get(int x, int y);
  void set(int x, int y, T value);
  int get width;
  int get height;
}
