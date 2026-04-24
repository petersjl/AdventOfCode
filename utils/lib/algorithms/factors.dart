int leastCommonMultiple(List<int> numbers) {
  if (numbers.isEmpty) throw Exception('LCM is not defined for an empty list');
  int lcm = numbers[0].abs();
  if (lcm == 0) throw Exception('LCM is not defined for zero');
  for (int number in numbers.skip(1)) {
    if (number == 0) throw Exception('LCM is not defined for zero');
    lcm = lcm * number.abs() ~/ _greatestCommonDivisor(lcm, number.abs());
  }
  return lcm;
}

int greatestCommonDivisor(List<int> numbers) {
  if (numbers.isEmpty) throw Exception('GCD is not defined for an empty list');
  int gcd = numbers[0];
  if (gcd == 0) throw Exception('GCD is not defined for zero');
  for (int number in numbers.skip(1)) {
    if (number == 0) throw Exception('GCD is not defined for zero');
    gcd = _greatestCommonDivisor(gcd, number);
  }
  return gcd;
}

int _greatestCommonDivisor(int a, int b) {
  a = a.abs();
  b = b.abs();
  while (b != 0) {
    int temp = b;
    b = a % b;
    a = temp;
  }
  return a;
}
