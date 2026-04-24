import 'package:test/test.dart';
import 'package:utils/algorithms/factors.dart'
    show greatestCommonDivisor, leastCommonMultiple;

void main() {
  group('greatestCommonDivisor', () {
    for (var (numbers, gcd) in [
      ([12, 8], 4),
      ([7, 5], 1),
      ([48, 18], 6),
      ([15, -5], 5),
    ]) {
      test('GCD of $numbers should be $gcd', () {
        expect(greatestCommonDivisor(numbers), equals(gcd));
      });
    }

    test('GCD of an empty list should throw an exception', () {
      expect(() => greatestCommonDivisor([]), throwsException);
    });

    test('GCD of zero should throw an exception', () {
      expect(() => greatestCommonDivisor([0, 5]), throwsException);
      expect(() => greatestCommonDivisor([5, 0]), throwsException);
    });
  });

  group('leastCommonMultiple', () {
    for (var (numbers, lcm) in [
      ([4, 6], 12),
      ([7, 5], 35),
      ([-7, 5], 35),
    ]) {
      test('LCM of $numbers should be $lcm', () {
        expect(leastCommonMultiple(numbers), equals(lcm));
      });
    }

    test('LCM of an empty list should throw an exception', () {
      expect(() => leastCommonMultiple([]), throwsException);
    });

    test('LCM of zero should throw an exception', () {
      expect(() => leastCommonMultiple([0, 5]), throwsException);
      expect(() => leastCommonMultiple([5, 0]), throwsException);
    });
  });
}
