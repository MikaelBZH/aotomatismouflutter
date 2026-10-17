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