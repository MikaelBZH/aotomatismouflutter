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
  String? get details => '''\\begin{aligned}
    
    $question &
    ${d1 != d2
      ? '=\\frac{$n1 ${fact1 != 1 ? ' \\color{red}{\\times $fact1}' : ''}}{$d1 ${fact1 != 1 ? ' \\color{red}{\\times $fact1}' : ''}} '
        '${sumSubtract == 0 ? '+' : '-'}'
        '\\frac{$n2 ${fact2 != 1 ? ' \\color{red}{\\times $fact2}' : ''}}{$d2 ${fact2 != 1 ? ' \\color{red}{\\times $fact2}' : ''}} \\\\'
        '&=\\frac{${n1 * fact1}}{$commonDenominator} ${sumSubtract == 0 ? '+' : '-'} \\frac{${n2 * fact2}}{$commonDenominator} \\\\'
      : ''}
    &=\\frac{${n1 * fact1} ${sumSubtract == 0 ? '+' : '-'} ${parenthesis(n2 * fact2)}}{$commonDenominator} \\\\
    &=\\frac{$calculatedNumerator}{$commonDenominator} \\\\
    
    ${factSimplified != 1 && (calculatedNumerator % calculatedDenominator != 0)
      ? '\\text{Simplaat :} \\\\'
        '&=\\frac{$calculatedNumerator \\color{red}{\\div $factSimplified}}{$commonDenominator \\color{red}{\\div $factSimplified}} \\\\'
        '&=\\frac{${simplifiedFraction[0]}}{${simplifiedFraction[1]}} \\\\'
      : '\\\\'}
    
    ${factSimplified != 1 || calculatedNumerator < 0 ? '&= $answer' : ''}
      
    \\end{aligned}''';
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
  String? get details => '''\\begin{aligned}
    
    $question &
    =\\frac{$n1 \\times $n2}{$d1 \\times $d2} \\\\
    &=\\frac{$calculatedNumerator}{$calculatedDenominator} \\\\
    ${factSimplified != 1 && (calculatedNumerator % calculatedDenominator != 0)
      ? '\\text{Simplaat :} \\\\'
      '&=\\frac{$calculatedNumerator \\color{red}{\\div $factSimplified}}{$calculatedDenominator \\color{red}{\\div $factSimplified}} \\\\'
      '&=\\frac{${simplifiedFraction[0]}}{${simplifiedFraction[1]}} \\\\'
      : '\\\\'}
    
    ${factSimplified != 1 || calculatedNumerator < 0 ? '&= $answer' : ''}
      
    \\end{aligned}''';
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
    final reducedNumerator = calculatedNumerator ~/ factSimplified;
    final reducedDenominator = calculatedDenominator ~/ factSimplified;
    final reduction = factSimplified == 1
        ? ''
        : '&= \\frac{$calculatedNumerator \\div $factSimplified}{$calculatedDenominator \\div $factSimplified} \\\\ &= \\frac{$reducedNumerator}{$reducedDenominator} \\\\';
    return '''\\begin{aligned}
    $question
    &= \\frac{$n1}{$d1} \\times \\frac{$d2}{$n2} \\\\
    &= \\frac{$rawNumerator}{$rawDenominator} \\\\
    $reduction
    &= $answer
    \\end{aligned}''';
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