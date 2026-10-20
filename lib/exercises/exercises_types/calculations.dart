import '../../functions/utils.dart';
import '../../models/exercises.dart';
import 'dart:math';

bool choice = true;

const calculationOptions = <ExerciseOptions>[
  ExerciseOptions(id: 'sum', label: 'Sammañ'),
  ExerciseOptions(id: 'subtract', label: 'Lemel'),
  ExerciseOptions(id: 'multiply', label: 'Liesaat'),
  ExerciseOptions(id: 'divide', label: 'Rannañ'),
];

class SumNumbers implements Exercise {
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
  String get answer => (nb1 + nb2).toString();

  @override
  String? get help => null;

  @override
  String? get details => null;
}

class SubtractNumbers implements Exercise {
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
  String get answer => (nb1 - nb2).toString();

  @override
  String? get help => null;

  @override
  String? get details => null;
}

class MultiplyNumbers implements Exercise {
  final int nb1;
  final int nb2;

  MultiplyNumbers(this.nb1, this.nb2);

  factory MultiplyNumbers.random() {
    final n1 = randomFromInterval(-12, 12);
    final n2 = randomFromInterval(-12, 12);
    return MultiplyNumbers(n1, n2);
  }

  @override
  String get question => '$nb1 \\times ${nb2 < 0 ? '($nb2)' : nb2}';

  @override
  String get answer => (nb1 * nb2).toString();

  @override
  String? get help => null;

  @override
  String? get details => null;
}

class DivideNumbers implements Exercise {
  final int nb1;
  final int nb2;

  DivideNumbers(this.nb1, this.nb2);

  factory DivideNumbers.random() {
    final n1 = randomFromInterval(-12, 12);
    final n2 = randomFromInterval(-12, 12);
    return DivideNumbers(n1, n2);
  }

  late int nb3 = nb1 * nb2;

  @override
  String get question => '$nb3 \\div ${nb2 < 0 ? '($nb2)' : nb2}';

  @override
  String get answer => nb2 == 0 ? '\\text{Dibosupl}' : '$nb1';

  @override
  String? get help => nb2 == 0 ? "Tu 'zo rannañ dre zero ?" : null;

  @override
  String? get details => null;

}

/*------------------------------------------------------------------------------
Fonction randomCalculation de type Exercise qui prend en paramètre un
ensemble (Set) de type CalculationOptions et retourne un exercise aléatoire.
----------------------------------------------------------------------------- */

Exercise? randomCalculation(Set<String> selectedOptions) {

    if (selectedOptions.isEmpty) {
      return null;
    }

  final options= selectedOptions.toList();
  final chosen = options[Random().nextInt(options.length)];

  return switch (chosen) {
    'sum' =>  SumNumbers.random(),
    'subtract' =>  SubtractNumbers.random(),
    'multiply' =>  MultiplyNumbers.random(),
    'divide' =>  DivideNumbers.random(),
    _ => throw ArgumentError('Unknown option: $chosen'),
  };
}