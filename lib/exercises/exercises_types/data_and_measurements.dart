import 'dart:math';

import '../../functions/utils.dart';
import '../../models/exercises.dart';
import '../../models/exercise_visual.dart';

const percentageOptions = <ExerciseOptions>[
  ExerciseOptions(id: 'ofNumber', label: 'Dregantad un niver'),
  ExerciseOptions(id: 'change', label: 'Kresk pe digresk'),
];

const areaOptions = <ExerciseOptions>[
  ExerciseOptions(id: 'rectangle', label: 'Skouergornek'),
  ExerciseOptions(id: 'triangle', label: "Tric'horn"),
  ExerciseOptions(id: 'circle', label: 'Disk'),
];

const conversionOptions = <ExerciseOptions>[
  ExerciseOptions(id: 'length', label: 'Hirderioù'),
  ExerciseOptions(id: 'area', label: 'Gorreadoù'),
  ExerciseOptions(id: 'volume', label: 'Volumoù hep litr'),
  ExerciseOptions(id: 'litre', label: 'Volumoù gant litr'),
];

String _chooseDataOption(Set<String> selectedOptions) {
  final options = selectedOptions.toList();
  return options[Random().nextInt(options.length)];
}

Exercise? randomPercentage(Set<String> selectedOptions) {
  if (selectedOptions.isEmpty) return null;
  if (_chooseDataOption(selectedOptions) == 'ofNumber') {
    final percent = [1, 10, 25, 50, 100][randomFromInterval(0, 4)];
    final number = randomFromInterval(1, 150);
    final result = percent * number / 100;
    final multiplier = switch (percent) {
      1 => '0{,}01',
      10 => '0{,}1',
      25 => '\\frac{1}{4}',
      50 => '\\frac{1}{2}',
      _ => '1',
    };
    final multiplierText = switch (percent) {
      1 => '0,01',
      10 => '0,1',
      25 => '1/4',
      50 => '1/2',
      _ => '1',
    };
    return Exercise(
      question: '\\text{Calculer } $percent\\% \\text{ de } $number',
      answer: _decimal(result),
      help: '$percent % = $multiplierText.',
      // 100 % : la réponse est le nombre lui-même, rien à détailler.
      details: percent == 100
          ? null
          : _percentOfNumberSteps(percent, number, multiplier, _decimal(result)),
    );
  }

  final percent = randomFromInterval(1, 10) * 10;
  final original = randomFromInterval(1, 5) * 100;
  final increase = randomFromInterval(0, 1) == 0;
  final multiplier = 1 + (increase ? percent : -percent) / 100;
  final change = original * percent / 100;
  final result = original * multiplier;
  return Exercise(
    question: '\\text{Calculer } $original \\text{ } ${increase ? 'augmenté' : 'diminué'} \\text{ de } $percent\\%.',
    answer: _decimal(result),
    help: 'Utilise le coefficient multiplicateur correspondant à l’augmentation ou à la diminution.',
    details: _percentChangeSteps(original, percent, increase, multiplier, change, result),
  );
}

Exercise? randomArea(Set<String> selectedOptions) {
  if (selectedOptions.isEmpty) return null;
  final shape = _chooseDataOption(selectedOptions);
  if (shape == 'triangle') {
    final m = randomFromInterval(2, 5);
    var n = randomFromInterval(1, m - 1);
    while (gcd(m, n) != 1 || (m - n).isEven) {
      n = randomFromInterval(1, m - 1);
    }
    const scales = [0.5, 1.5, 2.0, 2.5];
    final scale = scales[randomFromInterval(0, scales.length - 1)];
    final baseFoot = (m * m - n * n) * scale;
    final height = 2 * m * n * scale;
    final side = (m * m + n * n) * scale;
    var signedBase = baseFoot + randomFromInterval(-5, 10);
    while (signedBase == 0) {
      signedBase = baseFoot + randomFromInterval(-5, 10);
    }
    final base = signedBase.abs();
    final diagramFoot = signedBase < 0 ? -baseFoot : baseFoot;
    final area = base * height / 2;
    return IllustratedExercise(
      question: '\\text{Calculer l’aire du triangle ABC sachant que } AB = ${_decimal(base)}\\,cm, CD = ${_decimal(height)}\\,cm, AC = ${_decimal(side)}\\,cm \\text{ et } AB \\perp CD.',
      answer: '${_decimal(area)}\\,cm^2',
      help: 'Repère la base et la hauteur perpendiculaire. La troisième longueur est une donnée à distinguer.',
      details: '\\mathcal{A}_{ABC} = \\frac{AB \\times CD}{2} = \\frac{${_decimal(base)} \\times ${_decimal(height)}}{2} = ${_decimal(area)}\\,cm^2',
      visual: ExerciseVisual(
        kind: ExerciseVisualKind.triangle,
        labelA: 'AB = ${_plainDecimal(base)} cm',
        labelB: 'CD = ${_plainDecimal(height)} cm',
        labelC: 'AC = ${_plainDecimal(side)} cm',
        triangleBase: base,
        triangleFoot: diagramFoot,
        triangleHeight: height,
      ),
    );
  }
  if (shape == 'circle') {
    final giveRadius = randomFromInterval(0, 1) == 0;
    final radius = randomFromInterval(1, 12);
    final diameter = radius * 2;
    final question = giveRadius
        ? '\\text{Calculer l’aire du disque de centre B sachant que son rayon } AB = ${radius}\\,cm.'
        : '\\text{Calculer l’aire du disque de centre B sachant que son diamètre } AC = ${diameter}\\,cm.';
    final radiusDetails = giveRadius
        ? 'AB = $radius\\,cm'
        : 'AB = AC \\div 2 = $diameter \\div 2 = $radius\\,cm';
    return Exercise(
      question: question,
      answer: '${radius * radius}\\pi\\,cm^2',
      help: 'L’aire exacte d’un disque s’écrit pi multiplié par le rayon au carré. Si le diamètre est donné, commence par trouver le rayon.',
      details: '$radiusDetails \\quad \\mathcal{A} = \\pi \\times $radius^2 = \\pi \\times ${radius * radius} = ${radius * radius}\\pi\\,cm^2',
    );
  }
  final length = randomFromInterval(2, 12);
  final width = randomFromInterval(2, 12);
  return Exercise(
    question: '\\text{Calculer l’aire du rectangle ABCD sachant que } AB = ${length}\\,cm \\text{ et } BC = ${width}\\,cm.',
    answer: '${length * width}\\,cm^2',
    help: 'Un rectangle a deux dimensions perpendiculaires : sa longueur et sa largeur.',
    details: '\\mathcal{A}_{ABCD} = AB \\times BC = $length \\times $width = ${length * width}\\,cm^2',
  );
}

Exercise? randomConversion(Set<String> selectedOptions) {
  if (selectedOptions.isEmpty) return null;
  final type = _chooseDataOption(selectedOptions);
  final units = switch (type) {
    'length' => const ['km', 'hm', 'dam', 'm', 'dm', 'cm', 'mm'],
    'area' => const ['km²', 'hm²', 'dam²', 'm²', 'dm²', 'cm²', 'mm²'],
    'volume' => const ['km³', 'hm³', 'dam³', 'm³', 'dm³', 'cm³', 'mm³'],
    _ => const ['(kL)', 'hL', 'daL', 'L', 'dL', 'cL', 'mL'],
  };
  final columnsPerUnit = type == 'area' ? 2 : type == 'volume' ? 3 : 1;
  final from = randomFromInterval(0, units.length - 1);
  var to = randomFromInterval(0, units.length - 1);
  while (to == from) {
    to = randomFromInterval(0, units.length - 1);
  }

  final decimalPlaces = randomFromInterval(0, 3);
  final scale = pow(10, decimalPlaces).toInt();
  final rawValue = randomFromInterval(0, 999 * scale);
  final sourceValue = (rawValue / scale).toStringAsFixed(decimalPlaces);
  final sourceText = _trimDecimal(sourceValue);
  final shift = (to - from) * columnsPerUnit;
  final targetText = _shiftDecimal(sourceText, shift);
  var sourceUnitText = units[from];
  var targetUnitText = units[to];
  if (type == 'litre') {
    if (from == 0) sourceUnitText = 'm³';
    if (to == 0) targetUnitText = 'm³';
    if ((from == 3 || to == 3) && Random().nextBool()) {
      if (from == 3) sourceUnitText = 'dm³';
      if (to == 3) targetUnitText = 'dm³';
    }
    if ((from == 6 || to == 6) && Random().nextBool()) {
      if (from == 6) sourceUnitText = 'cm³';
      if (to == 6) targetUnitText = 'cm³';
    }
  }
  final sourceUnit = _unitLatex(sourceUnitText, type);
  final targetUnit = _unitLatex(targetUnitText, type);
  final sourceLatex = sourceText.replaceAll(',', '{,}');
  final targetLatex = targetText.replaceAll(',', '{,}');
  final help = switch (columnsPerUnit) {
    2 => 'Dans un tableau d’aires, chaque changement d’unité déplace la virgule de deux rangs.',
    3 => 'Dans un tableau de volumes, chaque changement d’unité déplace la virgule de trois rangs.',
    _ => 'Place le nombre dans la colonne de l’unité de départ, puis déplace la virgule jusqu’à l’unité demandée.',
  };

  return IllustratedExercise(
    question: '\\text{Convertir } $sourceLatex\\,${sourceUnit} \\text{ en } $targetUnit.',
    answer: '$targetLatex\\,${targetUnit}',
    help: help,
    visual: ExerciseVisual(
      kind: ExerciseVisualKind.conversion,
      units: units,
      secondaryUnitLabels: type == 'litre'
          ? const {2: 'm³', 5: 'dm³', 8: 'cm³'}
          : const {},
      columnsPerUnit: columnsPerUnit,
      fromColumn: from,
      toColumn: to,
      sourceValue: sourceText,
      targetValue: targetText,
      sourceUnit: sourceUnitText,
      targetUnit: targetUnitText,
    ),
  );
}

// 25 % → « n × 1/4 = n ÷ 4 », 50 % → « n ÷ 2 » ; 1 % et 10 % : produit direct.
String _percentOfNumberSteps(
  int percent,
  int number,
  String multiplier,
  String result,
) {
  final divisor = switch (percent) {
    25 => 4,
    50 => 2,
    _ => 0,
  };
  final calculation = divisor == 0
      ? '$number \\times $multiplier = $result'
      : '$number \\times $multiplier = $number \\div $divisor = $result';
  return '\\begin{aligned}& $percent\\% = \\frac{$percent}{100} = $multiplier \\\\ & $calculation\\end{aligned}';
}

// n × (1 ± p/100) = n × coefficient (= n ± n × p/100) = résultat (= n ± variation).
String _percentChangeSteps(
  int original,
  int percent,
  bool increase,
  num multiplier,
  num change,
  num result,
) {
  final sign = increase ? '+' : '-';
  final rate = _decimal(percent / 100);
  return '\\begin{aligned}'
      '& $original \\times \\left(1 $sign \\frac{$percent}{100}\\right) \\\\ '
      '&= $original \\times ${_decimal(multiplier)} \\left(= $original $sign $original \\times $rate\\right) \\\\ '
      '&= ${_decimal(result)} \\left(= $original $sign ${_decimal(change)}\\right)'
      '\\end{aligned}';
}

String _unitLatex(String unit, String type) => switch (type) {
      'area' => unit.replaceAll('²', '^{2}'),
      'volume' => unit.replaceAll('³', '^{3}'),
      'litre' => unit.replaceAll('³', '^{3}'),
      _ => unit,
    };

String _trimDecimal(String value) {
  final parts = value.replaceAll(',', '.').split('.');
  final integer = parts.first.replaceFirst(RegExp(r'^0+'), '');
  final whole = integer.isEmpty ? '0' : integer;
  final decimals = parts.length > 1
      ? parts[1].replaceFirst(RegExp(r'0+$'), '')
      : '';
  return decimals.isEmpty ? whole : '$whole,$decimals';
}

String _shiftDecimal(String value, int places) {
  final normalized = value.replaceAll(',', '.');
  final decimalIndex = normalized.indexOf('.');
  final digits = normalized.replaceAll('.', '');
  final originalPosition = decimalIndex < 0 ? digits.length : decimalIndex;
  final newPosition = originalPosition + places;
  final shifted = newPosition <= 0
      ? '0.${_zeroes(-newPosition)}$digits'
      : newPosition >= digits.length
          ? '$digits${_zeroes(newPosition - digits.length)}'
          : '${digits.substring(0, newPosition)}.${digits.substring(newPosition)}';
  return _trimDecimal(shifted);
}

String _zeroes(int count) => List.filled(count, '0').join();

String _decimal(num value) {
  var result = value.toStringAsFixed(2);
  result = result.replaceFirst(RegExp(r'0+$'), '');
  result = result.replaceFirst(RegExp(r'\.$'), '');
  return result.replaceAll('.', '{,}');
}

String _plainDecimal(num value) =>
    _decimal(value).replaceAll('{,}', ',');


