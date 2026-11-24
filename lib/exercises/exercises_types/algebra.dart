import 'dart:math';

import '../../functions/utils.dart';
import '../../models/exercises.dart';
import '../../models/exercise_visual.dart';

const numberLineOptions = <ExerciseOptions>[
  ExerciseOptions(id: 'read', label: 'Lenn absisenn ur poent'),
  ExerciseOptions(id: 'place', label: 'Daveañ ur poent'),
];

const expansionOptions = <ExerciseOptions>[
  ExerciseOptions(id: 'simple', label: 'Dispakañ simpl 1'),
  ExerciseOptions(id: 'collect', label: 'Dispakañ simpl 2'),
  ExerciseOptions(id: 'double', label: 'Dispakañ doubl'),
];

const powerOptions = <ExerciseOptions>[
  ExerciseOptions(id: 'product', label: 'Liesaat galloudoù'),
  ExerciseOptions(id: 'quotient', label: 'Rannañ galloudoù'),
  ExerciseOptions(id: 'powerOfPower', label: 'Galloud ur galloud'),
  ExerciseOptions(id: 'fractionPower', label: 'Galloud ur gevrenn'),
];

const squareOptions = <ExerciseOptions>[
  ExerciseOptions(id: 'square', label: 'Karrezioù peurvad'),
  ExerciseOptions(id: 'root', label: 'Gwrizhiennoù karrez'),
];

const equationOptions = <ExerciseOptions>[
  ExerciseOptions(id: 'additive', label: 'x + a = b'),
  ExerciseOptions(id: 'multiplicative', label: 'ax = b'),
  ExerciseOptions(id: 'mixed', label: 'ax + b = c'),
];

const divisibilityOptions = <ExerciseOptions>[
  ExerciseOptions(id: '2', label: 'Rannañ dre 2'),
  ExerciseOptions(id: '3', label: 'Rannañ dre 3'),
  ExerciseOptions(id: '4', label: 'Rannañ dre 4'),
  ExerciseOptions(id: '5', label: 'Rannañ dre 5'),
  ExerciseOptions(id: '9', label: 'Rannañ dre 9'),
  ExerciseOptions(id: '10', label: 'Rannañ dre 10'),
];

const scientificOptions = <ExerciseOptions>[
  ExerciseOptions(id: 'decimal', label: 'Niver degel da skrivad skiantel'),
  ExerciseOptions(id: 'normalize', label: 'Reizhañ ar mantissa'),
];

const expressionOptions = <ExerciseOptions>[
  ExerciseOptions(id: 'degree2', label: 'Eztaol derez 2'),
  ExerciseOptions(id: 'degree3', label: 'Eztaol derez 3'),
];

String _chooseOption(Set<String> selectedOptions) {
  final options = selectedOptions.toList();
  return options[Random().nextInt(options.length)];
}

Exercise? randomNumberLine(Set<String> selectedOptions) {
  if (selectedOptions.isEmpty) return null;
  final choice = _chooseOption(selectedOptions);
  final start = randomFromInterval(-10, 50);
  const subdivisions = [2, 4, 5, 10];
  final subdivision = subdivisions[randomFromInterval(0, subdivisions.length - 1)];
  final step = randomFromInterval(1, 5 * subdivision);
  final value = start + step / subdivision;
  final valueLatex = _decimal(value);
  final visual = ExerciseVisual(
    kind: ExerciseVisualKind.numberLine,
    numberValue: value,
    numberLineStart: start,
    numberLineRange: 5,
    numberLineSubdivisions: subdivision,
    showPointBeforeAnswer: choice == 'read',
  );

  if (choice == 'read') {
    return IllustratedExercise(
      question: '\\text{Lenn absisenn ar poent A ?}',
      answer: 'A($valueLatex)',
      help: 'Repère les graduations entières et compte les subdivisions jusqu’au point.',
      visual: visual,
    );
  }
  return IllustratedExercise(
    question: '\\text{Placer le point A}($valueLatex) \\text{ sur la droite graduée.}',
    answer: valueLatex,
    help: 'La droite commence en $start et chaque unité est partagée en $subdivision graduations.',
    details: 'A = $valueLatex',
    visual: visual,
  );
}

Exercise? randomExpansion(Set<String> selectedOptions) {
  if (selectedOptions.isEmpty) return null;
  final choice = _chooseOption(selectedOptions);
  if (choice == 'double') {
    final a = _nonZero(-12, 12);
    final b = _nonZero(-12, 12);
    final c = _nonZero(-12, 12);
    final d = _nonZero(-12, 12);
    final question = '(${_linearExpression(a, b)})(${_linearExpression(c, d)})';
    final coefficients = [b * d, a * d + b * c, a * c];
    return Exercise(
      question: '\\text{Développer } $question',
      answer: _polynomial(coefficients),
      help: 'Multiplie chaque terme de la première parenthèse par chaque terme de la seconde.',
      details: '$question = ${_polynomial(coefficients)}',
    );
  }

  final includeX = choice == 'collect';
  final a = choice == 'simple' ? randomFromInterval(1, 12) : _nonZero(-12, 12);
  final b = choice == 'simple' ? randomFromInterval(1, 12) : _nonZero(-12, 12);
  final c = _nonZero(-12, 12);
  final outer = includeX ? '${a}x' : '$a';
  final question = '$outer(${_linearExpression(b, c)})';
  final coefficients = includeX
      ? [0, a * c, a * b]
      : [a * c, a * b];
  return Exercise(
    question: '\\text{Développer } $question',
    answer: _polynomial(coefficients),
    help: 'Distribue le facteur devant chaque terme de la parenthèse.',
    details: '$question = ${_polynomial(coefficients)}',
  );
}

Exercise? randomPower(Set<String> selectedOptions) {
  if (selectedOptions.isEmpty) return null;
  final choice = _chooseOption(selectedOptions);
  final base = randomFromInterval(2, 12);
  final firstPower = randomFromInterval(-12, 12);
  if (choice == 'product') {
    final secondPower = randomFromInterval(-12, 12);
    final total = firstPower + secondPower;
    final question = '$base^{$firstPower} \\times $base^{$secondPower}';
    return Exercise(
      question: '\\text{Réduire en une puissance } $question',
      answer: _powerNotation(base, total),
      help: 'Dans un produit de puissances de même base, additionne les exposants.',
      details: '$question = $base^{$firstPower + ${_parenthesizedExponent(secondPower)}} = ${_powerNotation(base, total)}',
    );
  }
  if (choice == 'quotient') {
    final secondPower = randomFromInterval(-12, 12);
    final total = firstPower - secondPower;
    final question = '\\frac{$base^{$firstPower}}{$base^{$secondPower}}';
    return Exercise(
      question: '\\text{Réduire en une puissance } $question',
      answer: _powerNotation(base, total),
      help: 'Dans un quotient de puissances de même base, soustrais les exposants.',
      details: '$question = $base^{$firstPower-${_parenthesizedExponent(secondPower)}} = ${_powerNotation(base, total)}',
    );
  }
  if (choice == 'powerOfPower') {
    final secondPower = randomFromInterval(-12, 12);
    final total = firstPower * secondPower;
    final question = '\\left($base^{$firstPower}\\right)^{$secondPower}';
    return Exercise(
      question: '\\text{Réduire en une puissance } $question',
      answer: _powerNotation(base, total),
      help: 'Pour une puissance de puissance, multiplie les exposants.',
      details: '$question = $base^{$firstPower \\times ${_parenthesizedExponent(secondPower)}} = ${_powerNotation(base, total)}',
    );
  }

  final fraction = generateFraction(1, 12);
  final numerator = fraction[0];
  final denominator = fraction[1];
  final exponent = randomFromInterval(2, 4);
  final question = '\\left(\\frac{$numerator}{$denominator}\\right)^{$exponent}';
  return Exercise(
    question: '\\text{Écrire sous la forme d’une fraction } $question',
    answer: '\\frac{$numerator^{$exponent}}{$denominator^{$exponent}}',
    help: 'La puissance s’applique au numérateur et au dénominateur.',
    details: '$question = \\frac{$numerator^{$exponent}}{$denominator^{$exponent}}',
  );
}

Exercise? randomSquare(Set<String> selectedOptions) {
  if (selectedOptions.isEmpty) return null;
  final root = randomFromInterval(1, 12);
  if (_chooseOption(selectedOptions) == 'root') {
    return Exercise(
      question: '\\text{Calculer } \\sqrt{${root * root}}',
      answer: '$root',
      details: '\\sqrt{${root * root}} = $root \\text{ car } $root^2 = ${root * root}',
    );
  }
  return Exercise(
    question: '\\text{Calculer } $root^2',
    answer: '${root * root}',
    details: '$root^2 = $root \\times $root = ${root * root}',
  );
}

Exercise? randomEquation(Set<String> selectedOptions) {
  if (selectedOptions.isEmpty) return null;
  final choice = _chooseOption(selectedOptions);
  var a = _nonZero(-12, 12);
  while (a == 1) {
    a = _nonZero(-12, 12);
  }
  final b = _nonZero(-12, 12);
  final c = randomFromInterval(-12, 12);
  if (choice == 'additive') {
    final symbol = b < 0 ? '-' : '+';
    final absolute = b.abs();
    final x = c - b;
    return Exercise(
      question: '\\text{Résoudre } x $symbol $absolute = $c',
      answer: 'x = $x',
      help: 'Isole x en effectuant la même opération des deux côtés.',
      details: 'x $symbol $absolute = $c \\Longrightarrow x = $c ${b < 0 ? '+' : '-'} $absolute = $x',
    );
  }
  if (choice == 'multiplicative') {
    final answer = _fractionOrInteger(c, a);
    return Exercise(
      question: '\\text{Résoudre } ${a}x = $c',
      answer: 'x = $answer',
      details: '${a}x = $c \\Longrightarrow x = \\frac{$c}{$a} = $answer',
    );
  }
  final xNumerator = c - b;
  final answer = _fractionOrInteger(xNumerator, a);
  final symbol = b < 0 ? '-' : '+';
  return Exercise(
    question: '\\text{Résoudre } ${a}x $symbol ${b.abs()} = $c',
    answer: 'x = $answer',
    details: '${a}x $symbol ${b.abs()} = $c \\Longrightarrow ${a}x = $c ${b < 0 ? '+' : '-'} ${b.abs()} = $xNumerator \\Longrightarrow x = \\frac{$xNumerator}{$a} = $answer',
  );
}

Exercise? randomDivisibility(Set<String> selectedOptions) {
  if (selectedOptions.isEmpty) return null;
  final divisor = int.parse(_chooseOption(selectedOptions));
  final number = randomFromInterval(12, 10000);
  final divisible = number % divisor == 0;
  final rule = switch (divisor) {
    2 => 'Le chiffre des unités doit être pair.',
    3 => 'La somme des chiffres doit être divisible par 3.',
    4 => 'Le nombre formé par les deux derniers chiffres doit être divisible par 4.',
    5 => 'Le chiffre des unités doit être 0 ou 5.',
    9 => 'La somme des chiffres doit être divisible par 9.',
    _ => 'Le chiffre des unités doit être 0.',
  };
  return Exercise(
    question: '\\text{Le nombre } $number \\text{ est-il divisible par } $divisor ?',
    answer: divisible ? '\\text{Oui}' : '\\text{Non}',
    help: rule,
    details: '\\text{$number} \\text{ est } ${divisible ? '' : '\\text{pas} '}\\text{divisible par } $divisor.',
  );
}

Exercise? randomScientificNotation(Set<String> selectedOptions) {
  if (selectedOptions.isEmpty) return null;
  final choice = _chooseOption(selectedOptions);
  final exponent = randomFromInterval(-15, 12);
  if (choice == 'decimal') {
    final mantissa = randomFromInterval(10, 99) / 10;
    final mantissaLatex = _decimal(mantissa);
    final mantissaText = mantissaLatex.replaceAll('{,}', ',');
    final decimal = _shiftDecimalString(mantissaText, exponent);
    return Exercise(
      question: '\\text{Écrire } ${decimal.replaceAll(',', '{,}')} \\text{ en notation scientifique.}',
      answer: '$mantissaLatex \\times 10^{$exponent}',
      help: 'La mantisse doit être comprise entre 1 inclus et 10 exclu.',
      details: '${decimal.replaceAll(',', '{,}')} = $mantissaLatex \\times 10^{$exponent}',
    );
  }

  final largeMantissa = randomFromInterval(0, 1) == 0;
  final wrongMantissa = largeMantissa
      ? randomFromInterval(11, 99).toDouble()
      : randomFromInterval(1, 9) / 10;
  final shift = largeMantissa ? 1 : -1;
  final normalizedMantissa = largeMantissa ? wrongMantissa / 10 : wrongMantissa * 10;
  final normalizedExponent = exponent + shift;
  final wrong = _decimal(wrongMantissa);
  final normalized = _decimal(normalizedMantissa);
  return Exercise(
    question: '\\text{Mettre } $wrong \\times 10^{$exponent} \\text{ en notation scientifique.}',
    answer: '$normalized \\times 10^{$normalizedExponent}',
    help: 'Déplace la virgule pour obtenir une mantisse comprise entre 1 inclus et 10 exclu, puis compense avec l’exposant.',
    details: '$wrong = $normalized \\times 10^{$shift} \\quad\\Longrightarrow\\quad $wrong \\times 10^{$exponent} = $normalized \\times 10^{$normalizedExponent}',
  );
}

Exercise? randomExpression(Set<String> selectedOptions) {
  if (selectedOptions.isEmpty) return null;
  final choice = _chooseOption(selectedOptions);
  final degree = choice == 'degree3' ? 3 : 2;
  final x = degree == 3 ? randomFromInterval(-3, 3) : randomFromInterval(-12, 12);
  final safeX = x == 0 ? 1 : x;
  final coefficients = List<int>.generate(
    degree + 1,
    (_) => randomFromInterval(-12, 12),
  );
  if (coefficients.every((coefficient) => coefficient == 0)) {
    coefficients[degree] = 1;
  }
  var answer = 0;
  final evaluatedTerms = <int>[];
  final operations = <String>[];
  for (var power = 0; power <= degree; power++) {
    final coefficient = coefficients[power];
    final value = coefficient * pow(safeX, power).toInt();
    answer += value;
    evaluatedTerms.add(value);
    if (coefficient != 0) {
      final xTerm = power == 0
          ? ''
          : power == 1
              ? '\\times ${safeX < 0 ? '($safeX)' : safeX}'
              : '\\times (${safeX < 0 ? '($safeX)' : safeX})^{$power}';
      operations.add('${coefficient < 0 ? '- ' : '+ '}${coefficient.abs()} $xTerm');
    }
  }
  final expression = _polynomial(coefficients);
  final substituted = operations.join(' ').replaceFirst(RegExp(r'^\+ '), '');
  final reduced = _polynomial(evaluatedTerms);
  return Exercise(
    question: '\\text{Calculer } $expression \\text{ pour } x = ${safeX < 0 ? '($safeX)' : safeX}.',
    answer: '$answer',
    help: 'Remplace x par sa valeur, en mettant entre parenthèses un nombre négatif.',
    details: '$expression \\xrightarrow{x=${safeX < 0 ? '($safeX)' : safeX}} $substituted = $reduced = $answer',
  );
}

int _nonZero(int min, int max) {
  var value = randomFromInterval(min, max);
  while (value == 0) {
    value = randomFromInterval(min, max);
  }
  return value;
}

String _linearExpression(int coefficient, int constant) {
  final variableTerm = coefficient == 1
      ? 'x'
      : coefficient == -1
          ? '-x'
          : '${coefficient}x';
  final constantTerm = constant < 0 ? '- ${constant.abs()}' : '+ $constant';
  return '$variableTerm $constantTerm';
}

String _polynomial(List<int> coefficients) {
  final terms = <String>[];
  for (var power = coefficients.length - 1; power >= 0; power--) {
    final coefficient = coefficients[power];
    if (coefficient == 0) continue;
    final absolute = coefficient.abs();
    final variable = power == 0
        ? ''
        : power == 1
            ? 'x'
            : 'x^{$power}';
    final coefficientText = power > 0 && absolute == 1 ? '' : '$absolute';
    final term = '$coefficientText$variable';
    if (terms.isEmpty) {
      terms.add(coefficient < 0 ? '-$term' : term);
    } else {
      terms.add('${coefficient < 0 ? '-' : '+'} $term');
    }
  }
  return terms.isEmpty ? '0' : terms.join(' ');
}

String _powerNotation(int base, int exponent) => switch (exponent) {
      0 => '1',
      1 => '$base',
      _ => '$base^{$exponent}',
    };

String _parenthesizedExponent(int exponent) =>
    exponent < 0 ? '($exponent)' : '$exponent';

String _shiftDecimalString(String value, int places) {
  final normalized = value.replaceAll(',', '.');
  final decimalIndex = normalized.indexOf('.');
  final digits = normalized.replaceAll('.', '');
  final originalPosition = decimalIndex < 0 ? digits.length : decimalIndex;
  final newPosition = originalPosition + places;
  final shifted = newPosition <= 0
      ? '0.${List.filled(-newPosition, '0').join()}$digits'
      : newPosition >= digits.length
          ? '$digits${List.filled(newPosition - digits.length, '0').join()}'
          : '${digits.substring(0, newPosition)}.${digits.substring(newPosition)}';
  final parts = shifted.split('.');
  final integer = parts.first.replaceFirst(RegExp(r'^0+'), '');
  final whole = integer.isEmpty ? '0' : integer;
  final decimals = parts.length > 1
      ? parts[1].replaceFirst(RegExp(r'0+$'), '')
      : '';
  return decimals.isEmpty ? whole : '$whole,$decimals';
}

String _fractionOrInteger(int numerator, int denominator) {
  if (denominator == 0) return '\\text{indéfini}';
  var n = numerator;
  var d = denominator;
  if (d < 0) {
    n = -n;
    d = -d;
  }
  final divisor = gcd(n, d);
  n ~/= divisor;
  d ~/= divisor;
  if (d == 1) return '$n';
  return '\\frac{$n}{$d}';
}

String _decimal(num value) {
  var result = value.toStringAsFixed(6);
  result = result.replaceFirst(RegExp(r'0+$'), '');
  result = result.replaceFirst(RegExp(r'\.$'), '');
  return result.replaceAll('.', '{,}');
}

