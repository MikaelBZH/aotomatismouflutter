import 'dart:math';

int randomFromInterval(int min, int max) {
  if (min > max) {
    throw ArgumentError('min n''hall ket bezañ brasoc''h eget max');
  }
  if (min == max) {
    return min;
  }
  return min + Random().nextInt(max - min + 1);
}

// --------------------- Fractions ----------------------------

List<int> fraction(int minNumerator, int maxDenominator) {
  int numerator = randomFromInterval(minNumerator, 12);
  while (numerator == 0) {
    numerator = randomFromInterval(minNumerator, 12);
  }

  int denominator = randomFromInterval(2, maxDenominator);
  while (denominator == 0 || numerator % denominator == 0) {
    denominator = randomFromInterval(2, maxDenominator);
  }

  return [numerator, denominator];
}

// --------------------- Greatest Common Divisor  ----------------------------

int gcd(int a, int b) {
  a = (a).abs();
  b = (b).abs();
  while (b != 0) {
    int temp = b;
    b = a % b;
    a = temp;
  }
  return a;

}

// --------------------- Greatest Common Factor  ----------------------------

int gcf(int a, int b) {
  return (a * b) ~/ gcd(a, b);
}