import 'dart:math';

import '../../functions/utils.dart';
import '../../models/exercises.dart';

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
    final percent = [10, 20, 25, 50, 75][randomFromInterval(0, 4)];
    final number = [80, 120, 200, 240, 360][randomFromInterval(0, 4)];
    final result = percent * number ~/ 100;
    return Exercise(
      question: '\\text{Calculer } $percent\\% \\text{ de } $number',
      answer: '$result',
      help: '$percent\\% = \\frac{$percent}{100}.',
      details: '$percent\\% \\text{ de } $number = \\frac{$percent}{100} \\times $number = $result',
    );
  }

  final percent = [10, 20, 25, 30, 40, 50][randomFromInterval(0, 5)];
  final original = [100, 200, 400, 500][randomFromInterval(0, 3)];
  final increase = randomFromInterval(0, 1) == 0;
  final coefficient = 100 + (increase ? percent : -percent);
  final result = original * coefficient ~/ 100;
  return Exercise(
    question: '\\text{Calculer } $original \\text{ } ${increase ? 'augmenté' : 'diminué'} \\text{ de } $percent\\%.',
    answer: '$result',
    help: 'Utilise le coefficient multiplicateur correspondant à l’augmentation ou à la diminution.',
    details: '$original \\times \\frac{$coefficient}{100} = $result',
  );
}

Exercise? randomArea(Set<String> selectedOptions) {
  if (selectedOptions.isEmpty) return null;
  final shape = _chooseDataOption(selectedOptions);
  if (shape == 'triangle') {
    final base = randomFromInterval(4, 20);
    final height = randomFromInterval(2, 16);
    return Exercise(
      question: '\\text{Un triangle a une base de } ${base}\\,cm \\text{ et une hauteur de } ${height}\\,cm. \\text{Calculer son aire.}',
      answer: '\\frac{${base * height}}{2}\\,cm^2',
      help: 'Aire du triangle = base × hauteur ÷ 2.',
      details: '\\mathcal{A} = \\frac{$base \\times $height}{2} = \\frac{${base * height}}{2}\\,cm^2',
    );
  }
  if (shape == 'circle') {
    final radius = randomFromInterval(2, 12);
    final area = (3.14 * radius * radius * 100).round() / 100;
    return Exercise(
      question: '\\text{Un disque a un rayon de } ${radius}\\,cm. \\text{Calculer son aire avec } \\pi \\approx 3{,}14.',
      answer: '${_decimal(area)}\\,cm^2',
      help: 'Aire du disque = π × rayon².',
      details: '\\mathcal{A} = 3{,}14 \\times $radius^2 \\approx ${_decimal(area)}\\,cm^2',
    );
  }
  final length = randomFromInterval(3, 20);
  final width = randomFromInterval(2, 15);
  return Exercise(
    question: '\\text{Un rectangle mesure } ${length}\\,cm \\text{ sur } ${width}\\,cm. \\text{Calculer son aire.}',
    answer: '${length * width}\\,cm^2',
    help: 'Aire du rectangle = longueur × largeur.',
    details: '\\mathcal{A} = $length \\times $width = ${length * width}\\,cm^2',
  );
}

Exercise? randomConversion(Set<String> selectedOptions) {
  if (selectedOptions.isEmpty) return null;
  switch (_chooseDataOption(selectedOptions)) {
    case 'length':
      final amount = randomFromInterval(2, 95) * 10;
      return Exercise(
        question: '\\text{Convertir } ${amount}\\,cm \\text{ en mètres.}',
        answer: '\\frac{$amount}{100}\\,m',
        help: '1 m = 100 cm.',
        details: '${amount}\\,cm = \\frac{$amount}{100}\\,m',
      );
    case 'area':
      final amount = randomFromInterval(2, 80);
      return Exercise(
        question: '\\text{Convertir } ${amount * 10000}\\,cm^2 \\text{ en } m^2.',
        answer: '${amount}\\,m^2',
        help: '1 m² = 10 000 cm² : pour les aires, le facteur est au carré.',
        details: '${amount * 10000}\\,cm^2 = ${amount}\\,m^2',
      );
    case 'volume':
      final amount = randomFromInterval(2, 50);
      return Exercise(
        question: '\\text{Convertir } ${amount * 1000000}\\,cm^3 \\text{ en } m^3.',
        answer: '${amount}\\,m^3',
        help: '1 m³ = 1 000 000 cm³ : pour les volumes, le facteur est au cube.',
        details: '${amount * 1000000}\\,cm^3 = ${amount}\\,m^3',
      );
    default:
      final amount = randomFromInterval(2, 50);
      return Exercise(
        question: '\\text{Convertir } ${amount * 1000}\\,mL \\text{ en litres.}',
        answer: '${amount}\\,L',
        help: '1 L = 1 000 mL.',
        details: '${amount * 1000}\\,mL = ${amount}\\,L',
      );
  }
}

String _decimal(num value) {
  var result = value.toStringAsFixed(2);
  result = result.replaceFirst(RegExp(r'0+$'), '');
  result = result.replaceFirst(RegExp(r'\.$'), '');
  return result.replaceAll('.', '{,}');
}

