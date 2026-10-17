import '../functions/utils.dart';
import 'dart:math';

bool choice = true;

enum CalculationType {
  sum,
  subtract,
  multiply,
  divide,
}

abstract class CalculationExercise {
  String get question;
  int get answer;
}

class SumNumbers implements CalculationExercise {
  final int nb1;
  final int nb2;

  SumNumbers(this.nb1, this.nb2);

  factory SumNumbers.random() {
    final n1 = randomFromInterval(-100, 100);
    final n2 = randomFromInterval(-100, 100);
    return SumNumbers(n1, n2);
  }
  @override
  String get question => '$nb1 + ${nb2 < 0 ? '($nb2)' : nb2}';

  @override
  int get answer => nb1 + nb2;
}

class SubtractNumbers implements CalculationExercise {
  final int nb1;
  final int nb2;

  SubtractNumbers(this.nb1, this.nb2);

  factory SubtractNumbers.random() {
    final n1 = randomFromInterval(-100, 100);
    final n2 = randomFromInterval(-100, 100);
    return SubtractNumbers(n1, n2);
  }

  @override
  String get question => '$nb1 - ${nb2 < 0 ? '($nb2)' : nb2}';

  @override
  int get answer => nb1 - nb2;
}

class MultiplyNumbers implements CalculationExercise {
  final int nb1;
  final int nb2;

  MultiplyNumbers(this.nb1, this.nb2);

  factory MultiplyNumbers.random() {
    final n1 = randomFromInterval(-12, 12);
    final n2 = randomFromInterval(-12, 12);
    return MultiplyNumbers(n1, n2);
  }

  @override
  String get question => '$nb1 x ${nb2 < 0 ? '($nb2)' : nb2}';

  @override
  int get answer => nb1 * nb2;
}

class DivideNumbers implements CalculationExercise {
  final int nb1;
  final int nb2;

  DivideNumbers(this.nb1, this.nb2);

  factory DivideNumbers.random() {
    final n1 = randomFromInterval(-12, 12);
    var n2 = randomFromInterval(-12, 12);
    while (n2 == 0) {
      n2 = randomFromInterval(-12, 12);
    }
    return DivideNumbers(n1, n2);
  }

  late int nb3 = nb1 * nb2;

  @override
  String get question => '$nb3 ÷ ${nb2 < 0 ? '($nb2)' : nb2}';

  @override
  int get answer => nb1;

}

/*------------------------------------------------------------------------------
Fonction randomCalculation de type CalculationExercice qui prend en paramètre un
ensemble (Set) de type CalculationType et retourne un exercise aléatoire.
le ? signifie qu'un null peut être retourné.
 */

CalculationExercise? randomCalculation(
  Set<CalculationType> selectedTypes,
) {
    if (selectedTypes.isEmpty) {
      return null;
    }

  final types = selectedTypes.toList();
  final chosenType = types[Random().nextInt(types.length)];

  switch (chosenType) {
    case CalculationType.sum:
      return SumNumbers.random();
    case CalculationType.subtract:
      return SubtractNumbers.random();
    case CalculationType.multiply:
      return MultiplyNumbers.random();
    case CalculationType.divide:
      return DivideNumbers.random();
  }
  }