import '../../functions/utils.dart';
import '../../models/exercises.dart';
import 'dart:math';

bool choice = true;

const fractionOptions = <ExerciseOptions>[
  ExerciseOptions(id: 'sumSubtract', label: 'Sammañ pe lemel'),
  ExerciseOptions(id: 'multiply', label: 'Liesaat'),
  ExerciseOptions(id: 'divide', label: 'Rannañ'),
];

String parenthesis(int n) {
  return n < 0 ? '($n)' : '$n';
}

// ---------------------- ÉTAPES DE CORRECTION ------------------------

// question &= ligne 1 \\ &= ligne 2 ... Chaque ligne commence par « = »
// (sauf le titre « Simplaat : ») et s'aligne sous le premier « = ».
String _alignedSteps(String question, List<String> rows) =>
    '\\begin{aligned}$question &${rows.join(' \\\\ &')}\\end{aligned}';

// Fin de calcul commune : simplification éventuelle, puis réponse finale.
List<String> _endOfCalculation({
  required int numerator,
  required int denominator,
  required String answer,
}) {
  final divisor = gcd(numerator, denominator);
  final rows = <String>[];
  var current = '\\frac{$numerator}{$denominator}';
  if (divisor != 1) {
    rows
      ..add('\\text{Simplaat :}')
      ..add(
        '=\\frac{$numerator \\color{red}{\\div $divisor}}{$denominator \\color{red}{\\div $divisor}}',
      );
    current = '\\frac{${numerator ~/ divisor}}{${denominator ~/ divisor}}';
    if (numerator % denominator != 0) rows.add('=$current');
  }
  if (answer != current) rows.add('= $answer');
  return rows;
}


// ---------------------- SUM AND SUBTRACT FRACTIONS ------------------------

class SumSubtractFractions implements Exercise {
  final List<int> frac1;
  final List<int> frac2;

  SumSubtractFractions(this.frac1, this.frac2);

  factory SumSubtractFractions.random() {
    final f1 = generateFraction(-12, 12);
    final f2 = generateFraction(-12, 12);
    return SumSubtractFractions(f1, f2);
  }

  late final sumSubtract = randomFromInterval(0, 1);
  late final n1 = frac1[0];
  late final d1 = frac1[1];
  late final n2 = frac2[0];
  late final d2 = frac2[1];
  late final commonDenominator = lcm(d1, d2);
  late final fact1 = commonDenominator ~/ d1;
  late final fact2 = commonDenominator ~/ d2;
  late final calculatedNumerator = sumSubtract == 0
      ? n1 * fact1 + n2 * fact2
      : n1 * fact1 - n2 * fact2;
  late final calculatedDenominator = d1 * fact1;
  late final factSimplified = gcd(calculatedNumerator, calculatedDenominator);
  late final simplifiedFraction = simplifyFraction([calculatedNumerator, calculatedDenominator]);


  @override
  String get question => '\\frac{$n1}{$d1} ${sumSubtract == 0 ? '+' : '-'} \\frac{$n2}{$d2}';

  @override
  String get answer {
    if (calculatedNumerator % calculatedDenominator == 0) {
      return '${calculatedNumerator ~/ calculatedDenominator}';
    }

    final numerator = simplifiedFraction[0];
    final denominator = simplifiedFraction[1];

    if (numerator < 0) {
      return '- \\frac{${numerator.abs()}}{$denominator}';
    }

    return '\\frac{$numerator}{$denominator}';
  }

  @override
  String? get help => 'Evit sammañ pe lemel kevrennoù eo ret dezhe kaout un anver boutin.';

  @override
  String? get details {
    final symbol = sumSubtract == 0 ? '+' : '-';
    String factor(int value) => value != 1 ? ' \\color{red}{\\times $value}' : '';
    return _alignedSteps(question, [
      if (d1 != d2) ...[
        '=\\frac{$n1${factor(fact1)}}{$d1${factor(fact1)}} $symbol \\frac{$n2${factor(fact2)}}{$d2${factor(fact2)}}',
        '=\\frac{${n1 * fact1}}{$commonDenominator} $symbol \\frac{${n2 * fact2}}{$commonDenominator}',
      ],
      '=\\frac{${n1 * fact1} $symbol ${parenthesis(n2 * fact2)}}{$commonDenominator}',
      '=\\frac{$calculatedNumerator}{$commonDenominator}',
      ..._endOfCalculation(
        numerator: calculatedNumerator,
        denominator: calculatedDenominator,
        answer: answer,
      ),
    ]);
  }
}

// ---------------------- MULTIPLY FRACTIONS ------------------------

class MultiplyFractions implements Exercise {
  final List<int> frac1;
  final List<int> frac2;

  MultiplyFractions(this.frac1, this.frac2);

  factory MultiplyFractions.random() {
    final f1 = generateFraction(-12, 12);
    final f2 = generateFraction(-12, 12);
    return MultiplyFractions(f1, f2);
  }

  late final n1 = frac1[0];
  late final d1 = frac1[1];
  late final n2 = frac2[0];
  late final d2 = frac2[1];
  late final calculatedNumerator = n1 * n2;
  late final calculatedDenominator = d1 * d2;
  late final factSimplified = gcd(calculatedNumerator, calculatedDenominator);
  late final simplifiedFraction = simplifyFraction([calculatedNumerator, calculatedDenominator]);

  @override
  String get question => '\\frac{$n1}{$d1} \\times \\frac{$n2}{$d2}';

  @override
  String get answer {
    if (calculatedNumerator % calculatedDenominator == 0) {
      return '${calculatedNumerator ~/ calculatedDenominator}';
    }

    final numerator = simplifiedFraction[0];
    final denominator = simplifiedFraction[1];

    if (numerator < 0) {
      return '- \\frac{${numerator.abs()}}{$denominator}';
    }

    return '\\frac{$numerator}{$denominator}';
  }

  @override
  String? get help => 'Liesaat div gevrenn a zo liesaat an daou niverer ha liesaat an daou anver.';

  @override
  String? get details => _alignedSteps(question, [
        '=\\frac{$n1 \\times ${parenthesis(n2)}}{$d1 \\times $d2}',
        '=\\frac{$calculatedNumerator}{$calculatedDenominator}',
        ..._endOfCalculation(
          numerator: calculatedNumerator,
          denominator: calculatedDenominator,
          answer: answer,
        ),
      ]);
}

// ---------------------- DIVIDE FRACTIONS ------------------------

class DivideFractions implements Exercise {
  final List<int> frac1;
  final List<int> frac2;

  DivideFractions(this.frac1, this.frac2);

  factory DivideFractions.random() {
    final first = generateFraction(-12, 12);
    final second = generateFraction(-12, 12);
    return DivideFractions(first, second);
  }

  late final n1 = frac1[0];
  late final d1 = frac1[1];
  late final n2 = frac2[0];
  late final d2 = frac2[1];
  late final questionAsNestedFraction = Random().nextBool();
  late final rawNumerator = n1 * d2;
  late final rawDenominator = d1 * n2;
  late final calculatedNumerator =
      rawDenominator < 0 ? -rawNumerator : rawNumerator;
  late final calculatedDenominator = rawDenominator.abs();
  late final factSimplified = calculatedDenominator == 0
      ? 1
      : gcd(calculatedNumerator, calculatedDenominator);
  late final simplifiedFraction = calculatedDenominator == 0
      ? <int>[0, 1, 1]
      : simplifyFraction([calculatedNumerator, calculatedDenominator]);

  @override
  String get question => questionAsNestedFraction
      ? '\\frac{\\frac{$n1}{$d1}}{\\frac{$n2}{$d2}}'
      : '\\frac{$n1}{$d1} \\div \\frac{$n2}{$d2}';

  @override
  String get answer {
    if (calculatedDenominator == 0) return '\\text{Dibosupl}';
    if (calculatedNumerator % calculatedDenominator == 0) {
      return (calculatedNumerator ~/ calculatedDenominator).toString();
    }
    final numerator = simplifiedFraction[0];
    final denominator = simplifiedFraction[1];
    final magnitude = numerator.abs();
    return numerator < 0
        ? '- \\frac{$magnitude}{$denominator}'
        : '\\frac{$numerator}{$denominator}';
  }

  @override
  String? get help =>
      'Diviser par une fraction revient à multiplier par son inverse.';

  @override
  String? get details {
    if (calculatedDenominator == 0) {
      return '$question = \\text{Dibosupl}';
    }
    return _alignedSteps(question, [
      '=\\frac{$n1}{$d1} \\times \\frac{$d2}{$n2}',
      '=\\frac{$n1 \\times $d2}{$d1 \\times ${parenthesis(n2)}}',
      '=\\frac{$rawNumerator}{$rawDenominator}',
      if (rawDenominator < 0)
        '=\\frac{$calculatedNumerator}{$calculatedDenominator}',
      ..._endOfCalculation(
        numerator: calculatedNumerator,
        denominator: calculatedDenominator,
        answer: answer,
      ),
    ]);
  }
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