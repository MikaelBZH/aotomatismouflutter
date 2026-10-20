import '../../functions/utils.dart';
import '../../models/exercises.dart';
import 'dart:math';

bool choice = true;

const fractionOptions = <ExerciseOptions>[
  ExerciseOptions(id: 'sumSubtract', label: 'Sammañ pe lemel'),
  ExerciseOptions(id: 'multiply', label: 'Liesaat'),
  ExerciseOptions(id: 'divide', label: 'Rannañ'),
];

class SumSubtractFractions implements Exercise {
  final List<int> frac1;
  final List<int> frac2;

  SumSubtractFractions(this.frac1, this.frac2);

  factory SumSubtractFractions.random() {
    final f1 = fraction(-12, 12);
    final f2 = fraction(-12, 12);
    return SumSubtractFractions(f1, f2);
  }

  late final sumSubtract = randomFromInterval(0, 1);
  late final d1 = frac1[0];
  late final n1 = frac1[1];
  late final d2 = frac2[0];
  late final n2 = frac2[1];
  late final commonDenominator = gcf(n1, n2);

  @override
  String get question => '\\frac{$d1}{$n1} ${sumSubtract == 0 ? '+' : '-'} \\frac{$d2}{$n2}';

  @override
  String get answer => '\\frac{${d1 * n2 + d2 * n1}{$commonDenominator}}';

  @override
  String? get help => 'Evit sammañ pe lemel kevrennoù eo ret dezhe kaout un anver boutin.';
}

class MultiplyFractions implements Exercise {
  final int nb1;
  final int nb2;

  MultiplyFractions(this.nb1, this.nb2);

  factory MultiplyFractions.random() {
    final n1 = randomFromInterval(-12, 12);
    final n2 = randomFromInterval(-12, 12);
    return MultiplyFractions(n1, n2);
  }

  @override
  String get question => '$nb1 \\times ${nb2 < 0 ? '($nb2)' : nb2}';

  @override
  String get answer => (nb1 * nb2).toString();

  @override
  String? get help => null;
}

class DivideFractions implements Exercise {
  final int nb1;
  final int nb2;

  DivideFractions(this.nb1, this.nb2);

  factory DivideFractions.random() {
    final n1 = randomFromInterval(-12, 12);
    final n2 = randomFromInterval(-12, 12);
    return DivideFractions(n1, n2);
  }

  late int nb3 = nb1 * nb2;

  @override
  String get question => '$nb3 \\div ${nb2 < 0 ? '($nb2)' : nb2}';

  @override
  String get answer => nb2 == 0 ? '\\text{Dibosupl}' : '$nb1';

  @override
  String? get help => nb2 == 0 ? "Tu 'zo rannañ dre zero ?" : null;

}

/*------------------------------------------------------------------------------
Fonction randomCalculation de type Exercise qui prend en paramètre un
ensemble (Set) de type CalculationOptions et retourne un exercise aléatoire.
----------------------------------------------------------------------------- */

Exercise? randomFraction(Set<String> selectedOptions) {

  if (selectedOptions.isEmpty) {
    return null;
  }

  final options= selectedOptions.toList();
  final chosen = options[Random().nextInt(options.length)];

  return switch (chosen) {
    'sumSubtract' =>  SumSubtractFractions.random(),
    'multiply' =>  MultiplyFractions.random(),
    'divide' =>  DivideFractions.random(),
    _ => throw ArgumentError('Unknown option: $chosen'),
  };
}