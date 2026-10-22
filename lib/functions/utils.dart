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

// --------------------- Generate fraction ----------------------------

List<int> generateFraction(int minNumerator, int maxDenominator) {
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

// --------------------- Least Common Multiple  ----------------------------

int lcm(int a, int b) {
  return (a * b) ~/ gcd(a, b);
}

// ----------------------- Simplify fraction  ------------------------------

List<int> simplifyFraction(List<int> fraction) {
  int numerator = fraction[0];
  int denominator = fraction[1];
  int simplificationFactor = gcd(numerator, denominator);
  numerator = numerator ~/ simplificationFactor;
  denominator = denominator ~/ simplificationFactor;
  return [numerator, denominator, simplificationFactor];
}