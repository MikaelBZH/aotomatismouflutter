import 'dart:math';

import '../../functions/utils.dart';
import '../../models/exercises.dart';
import '../../models/exercise_visual.dart';

const numberLineOptions = <ExerciseOptions>[
  ExerciseOptions(id: 'read', label: 'Lenn ar poent'),
  ExerciseOptions(id: 'place', label: 'Daveañ ur poent'),
];

const expansionOptions = <ExerciseOptions>[
  ExerciseOptions(id: 'simple', label: 'Dispakañ simpl 1'),
  ExerciseOptions(id: 'collect', label: 'Dispakañ simpl 2'),
  ExerciseOptions(id: 'double', label: 'Dispakañ doubl'),
];

const powerOptions = <ExerciseOptions>[
  ExerciseOptions(id: 'calculate', label: 'Jedañ ur galloud'),
  ExerciseOptions(id: 'product', label: 'Liesaat galloudoù'),
  ExerciseOptions(id: 'quotient', label: 'Rannañ galloudoù'),
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
  ExerciseOptions(id: '5', label: 'Rannañ dre 5'),
  ExerciseOptions(id: '9', label: 'Rannañ dre 9'),
  ExerciseOptions(id: '10', label: 'Rannañ dre 10'),
];

const scientificOptions = <ExerciseOptions>[
  ExerciseOptions(id: 'decimal', label: 'Diwar un niver degel'),
  ExerciseOptions(id: 'power', label: 'Diwar un niver gant ur galloud eus 10'),
  ExerciseOptions(id: 'volume', label: 'Volumoù hep litr'),
  ExerciseOptions(id: 'litre', label: 'Volumoù gant litr'),
];

const expressionOptions = <ExerciseOptions>[
  ExerciseOptions(id: 'numeric', label: 'Eztaol hep x'),
  ExerciseOptions(id: 'algebraic', label: 'Eztaol gant x'),
  ExerciseOptions(id: 'volume', label: 'Volumoù hep litr'),
  ExerciseOptions(id: 'litre', label: 'Volumoù gant litr'),
];

String _chooseOption(Set<String> selectedOptions) {
  final options = selectedOptions.toList();
  return options[Random().nextInt(options.length)];
}

Exercise? randomNumberLine(Set<String> selectedOptions) {
  if (selectedOptions.isEmpty) return null;
  final choice = _chooseOption(selectedOptions);
  final denominator = [2, 4, 5, 10][randomFromInterval(0, 3)];
  final numerator = randomFromInterval(-12, 12);
  final reduction = gcd(numerator, denominator);
  final simpleNumerator = numerator ~/ reduction;
  final simpleDenominator = denominator ~/ reduction;
  final answer = simpleDenominator == 1
      ? '$simpleNumerator'
      : '\\frac{$simpleNumerator}{$simpleDenominator}';

  if (choice == 'read') {
    return IllustratedExercise(
      question: '\\text{Un point est à } $numerator \\text{ graduations de } \\frac{1}{$denominator}.\\text{ Quelle est son abscisse ?}',
      answer: answer,
      help: 'Chaque graduation représente une fraction de l’unité.',
      details: '\\frac{$numerator}{$denominator} = $answer',
      visual: ExerciseVisual(
        kind: ExerciseVisualKind.numberLine,
        numberValue: numerator / denominator,
      ),
    );
  }
  return Exercise(
    question: '\\text{Sur une droite graduée au dixième, place } A($answer).',
    answer: 'A($answer)',
    help: 'Les nombres négatifs se placent à gauche de zéro.',
  );
}

Exercise? randomExpansion(Set<String> selectedOptions) {
  if (selectedOptions.isEmpty) return null;
  final choice = _chooseOption(selectedOptions);
  final a = randomFromInterval(2, 8);
  final b = randomFromInterval(2, 8);
  final c = randomFromInterval(1, 9);

  if (choice == 'collect') {
    final first = randomFromInterval(2, 8);
    final second = randomFromInterval(2, 8);
    return Exercise(
      question: '\\text{Réduire } ${first}x + ${second}x - $c',
      answer: '${first + second}x - $c',
      details: '${first}x + ${second}x - $c = ${first + second}x - $c',
    );
  }
  if (choice == 'double') {
    final result = a + b;
    return Exercise(
      question: '\\text{Développer } (x + $a)(x + $b)',
      answer: 'x^2 + ${result}x + ${a * b}',
      details: '(x + $a)(x + $b) = x^2 + ${result}x + ${a * b}',
    );
  }
  return Exercise(
    question: '\\text{Développer } $a($b x + $c)',
    answer: '${a * b}x + ${a * c}',
    details: '$a($b x + $c) = ${a * b}x + ${a * c}',
  );
}

Exercise? randomPower(Set<String> selectedOptions) {
  if (selectedOptions.isEmpty) return null;
  final choice = _chooseOption(selectedOptions);
  final base = randomFromInterval(2, 5);
  final firstPower = randomFromInterval(2, 4);
  if (choice == 'product') {
    final secondPower = randomFromInterval(1, 4);
    final total = firstPower + secondPower;
    return Exercise(
      question: '\\text{Calculer } $base^{$firstPower} \\times $base^{$secondPower}',
      answer: '$base^{$total} = ${pow(base, total)}',
      help: 'Dans un produit de puissances de même base, additionne les exposants.',
      details: '$base^{$firstPower} \\times $base^{$secondPower} = $base^{$total} = ${pow(base, total)}',
    );
  }
  if (choice == 'quotient') {
    final secondPower = randomFromInterval(firstPower + 1, 8);
    final total = firstPower - secondPower;
    return Exercise(
      question: '\\text{Calculer } \\frac{$base^{$firstPower}}{$base^{$secondPower}}',
      answer: '$base^{$total}',
      help: 'Dans un quotient de puissances de même base, soustrais les exposants.',
      details: '\\frac{$base^{$firstPower}}{$base^{$secondPower}} = $base^{$firstPower-$secondPower} = $base^{$total}',
    );
  }
  final exponent = randomFromInterval(2, 5);
  return Exercise(
    question: '\\text{Calculer } $base^{$exponent}',
    answer: '${pow(base, exponent)}',
    details: '$base^{$exponent} = ${List.filled(exponent, '$base').join(' \\times ')}',
  );
}

Exercise? randomSquare(Set<String> selectedOptions) {
  if (selectedOptions.isEmpty) return null;
  final root = randomFromInterval(2, 15);
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
  final x = randomFromInterval(-9, 12);
  final a = randomFromInterval(2, 9);
  final b = randomFromInterval(-12, 12);
  if (choice == 'additive') {
    final right = x + b;
    final symbol = b < 0 ? '-' : '+';
    final absolute = b.abs();
    return Exercise(
      question: '\\text{Résoudre } x $symbol $absolute = $right',
      answer: 'x = $x',
      help: 'Isole x en effectuant la même opération des deux côtés.',
      details: 'x $symbol $absolute = $right \\Longrightarrow x = $x',
    );
  }
  if (choice == 'multiplicative') {
    return Exercise(
      question: '\\text{Résoudre } ${a}x = ${a * x}',
      answer: 'x = $x',
      details: '${a}x = ${a * x} \\Longrightarrow x = \\frac{${a * x}}{$a} = $x',
    );
  }
  final right = a * x + b;
  final symbol = b < 0 ? '-' : '+';
  return Exercise(
    question: '\\text{Résoudre } ${a}x $symbol ${b.abs()} = $right',
    answer: 'x = $x',
    details: '${a}x $symbol ${b.abs()} = $right \\Longrightarrow ${a}x = ${a * x} \\Longrightarrow x = $x',
  );
}

Exercise? randomDivisibility(Set<String> selectedOptions) {
  if (selectedOptions.isEmpty) return null;
  final divisor = int.parse(_chooseOption(selectedOptions));
  final number = randomFromInterval(100, 999);
  final divisible = number % divisor == 0;
  final rule = switch (divisor) {
    2 => 'Le chiffre des unités doit être pair.',
    3 => 'La somme des chiffres doit être divisible par 3.',
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
  final coefficient = randomFromInterval(100, 987);
  final exponent = randomFromInterval(-3, 7);
  final number = coefficient * pow(10, exponent).toDouble();
  final mantissa = coefficient / 100;
  final scientificExponent = exponent + 2;
  final unit = choice == 'litre' ? '\\,L' : '\\,m^3';

  if (choice == 'power' || choice == 'litre') {
    return Exercise(
      question: '\\text{Écrire } ${_decimal(mantissa)} \\times 10^{$scientificExponent}$unit \\text{ en écriture décimale.}',
      answer: '${_decimal(number)}$unit',
      details: '${_decimal(mantissa)} \\times 10^{$scientificExponent} = ${_decimal(number)}',
    );
  }
  return Exercise(
    question: '\\text{Écrire } ${_decimal(number)}${choice == 'volume' ? unit : ''} \\text{ en notation scientifique.}',
    answer: '${_decimal(mantissa)} \\times 10^{$scientificExponent}${choice == 'volume' ? unit : ''}',
    help: 'La mantisse doit être supérieure ou égale à 1 et strictement inférieure à 10.',
    details: '${_decimal(number)} = ${_decimal(mantissa)} \\times 10^{$scientificExponent}',
  );
}

Exercise? randomExpression(Set<String> selectedOptions) {
  if (selectedOptions.isEmpty) return null;
  final choice = _chooseOption(selectedOptions);
  final a = randomFromInterval(2, 9);
  final b = randomFromInterval(2, 9);
  final c = randomFromInterval(2, 9);

  if (choice == 'algebraic') {
    final x = randomFromInterval(2, 8);
    return Exercise(
      question: '\\text{Calculer } 3x + 2 \\text{ pour } x = $x',
      answer: '${3 * x + 2}',
      details: '3 \\times $x + 2 = ${3 * x + 2}',
    );
  }
  if (choice == 'volume' || choice == 'litre') {
    final side = randomFromInterval(2, 8);
    final volume = a * b * side;
    return Exercise(
      question: choice == 'litre'
          ? '\\text{Un pavé mesure } $a\\,cm \\times $b\\,cm \\times $side\\,cm. \\text{Exprimer son volume en litres.}'
          : '\\text{Un pavé mesure } $a\\,cm \\times $b\\,cm \\times $side\\,cm. \\text{Calculer son volume en } cm^3.',
      answer: choice == 'litre' ? '\\frac{$volume}{1000}\\,L' : '${volume}\\,cm^3',
      help: 'Multiplie longueur, largeur et hauteur. 1 L = 1 000 cm³.',
      details: '$a \\times $b \\times $side = $volume \\text{ cm}^3',
    );
  }
  return Exercise(
    question: '\\text{Calculer } ($a + $b) \\times $c - $a',
    answer: '${(a + b) * c - a}',
    help: 'Respecte les priorités opératoires : parenthèses, multiplication, puis soustraction.',
    details: '($a + $b) \\times $c - $a = ${(a + b) * c} - $a = ${(a + b) * c - a}',
  );
}

String _decimal(num value) {
  var result = value.toStringAsFixed(6);
  result = result.replaceFirst(RegExp(r'0+$'), '');
  result = result.replaceFirst(RegExp(r'\.$'), '');
  return result.replaceAll('.', '{,}');
}

