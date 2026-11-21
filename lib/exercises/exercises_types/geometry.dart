import 'dart:math';

import '../../functions/utils.dart';
import '../../models/exercises.dart';

const coordinateOptions = <ExerciseOptions>[
  ExerciseOptions(id: 'read', label: 'Lenn kenurzhiennoù'),
  ExerciseOptions(id: 'locate', label: 'Daveañ ur poent'),
];

const pythagorasOptions = <ExerciseOptions>[
  ExerciseOptions(id: 'hypotenuse', label: 'Kavout an hipotenuzenn'),
  ExerciseOptions(id: 'side', label: 'Kavout un tu all'),
];

const thalesOptions = <ExerciseOptions>[
  ExerciseOptions(id: 'direct', label: 'Kavout un hirder'),
  ExerciseOptions(id: 'reverse', label: 'Kavout ar c’heñver'),
];

const trigonometryOptions = <ExerciseOptions>[
  ExerciseOptions(id: 'angle', label: 'Kavout un ang'),
  ExerciseOptions(id: 'side', label: 'Kavout un tu'),
];

String _chooseGeometryOption(Set<String> selectedOptions) {
  final options = selectedOptions.toList();
  return options[Random().nextInt(options.length)];
}

Exercise? randomCoordinates(Set<String> selectedOptions) {
  if (selectedOptions.isEmpty) return null;
  final choice = _chooseGeometryOption(selectedOptions);
  final x = randomFromInterval(-8, 8);
  final y = randomFromInterval(-8, 8);
  if (choice == 'read') {
    return Exercise(
      question: '\\text{Un point A est à } $x \\text{ sur l’axe horizontal et } $y \\text{ sur l’axe vertical. Donner ses coordonnées.}',
      answer: 'A($x\\,;\\,$y)',
      help: 'On écrit d’abord l’abscisse, puis l’ordonnée.',
    );
  }
  final quadrant = x == 0 || y == 0
      ? 'sur un axe'
      : x > 0
          ? (y > 0 ? 'I' : 'IV')
          : (y > 0 ? 'II' : 'III');
  return Exercise(
    question: '\\text{Placer A}($x\\,;\\,$y) \\text{ dans un repère. Dans quel quadrant se trouve-t-il ?}',
    answer: quadrant == 'sur un axe' ? '\\text{Sur un axe}' : '\\text{Quadrant } $quadrant',
    help: 'Le signe de l’abscisse et de l’ordonnée indique le quadrant.',
  );
}

Exercise? randomPythagoras(Set<String> selectedOptions) {
  if (selectedOptions.isEmpty) return null;
  const triples = <(int, int, int)>[(3, 4, 5), (5, 12, 13), (8, 15, 17)];
  final triple = triples[randomFromInterval(0, triples.length - 1)];
  final scale = randomFromInterval(1, 4);
  final shortSide = triple.$1 * scale;
  final otherSide = triple.$2 * scale;
  final hypotenuse = triple.$3 * scale;
  if (_chooseGeometryOption(selectedOptions) == 'side') {
    return Exercise(
      question: '\\text{Un triangle rectangle a une hypoténuse de } ${hypotenuse}\\,cm \\text{ et un côté de } ${shortSide}\\,cm. \\text{Calculer l’autre côté.}',
      answer: '${otherSide}\\,cm',
      help: 'Avec Pythagore : côté² = hypoténuse² − autre côté².',
      details: '\\text{Autre côté}^2 = $hypotenuse^2 - $shortSide^2 = ${otherSide}^2',
    );
  }
  return Exercise(
    question: '\\text{Un triangle rectangle a des côtés de l’angle droit de } ${shortSide}\\,cm \\text{ et } ${otherSide}\\,cm. \\text{Calculer son hypoténuse.}',
    answer: '${hypotenuse}\\,cm',
    help: 'Le carré de l’hypoténuse est la somme des carrés des deux autres côtés.',
    details: 'c^2 = $shortSide^2 + $otherSide^2 = ${hypotenuse}^2',
  );
}

Exercise? randomThales(Set<String> selectedOptions) {
  if (selectedOptions.isEmpty) return null;
  final smallLength = randomFromInterval(2, 8);
  final ratio = randomFromInterval(2, 5);
  if (_chooseGeometryOption(selectedOptions) == 'reverse') {
    return Exercise(
      question: '\\text{Dans une configuration de Thalès, } AB = $smallLength\\,cm \\text{ et } AC = ${smallLength * ratio}\\,cm. \\text{Calculer } \\frac{AC}{AB}.',
      answer: '$ratio',
      help: 'Compare les longueurs correspondantes : AC ÷ AB.',
      details: '\\frac{AC}{AB} = \\frac{${smallLength * ratio}}{$smallLength} = $ratio',
    );
  }
  final largeLength = randomFromInterval(3, 12) * ratio;
  return Exercise(
    question: '\\text{Deux triangles sont en configuration de Thalès. Le rapport de réduction est } \\frac{1}{$ratio} \\text{ et le grand côté mesure } ${largeLength}\\,cm. \\text{Quelle est la longueur correspondante dans le petit triangle ?}',
    answer: '${largeLength ~/ ratio}\\,cm',
    help: 'Les longueurs correspondantes sont proportionnelles.',
    details: '${largeLength} \\times \\frac{1}{$ratio} = ${largeLength ~/ ratio}\\,cm',
  );
}

Exercise? randomTrigonometry(Set<String> selectedOptions) {
  if (selectedOptions.isEmpty) return null;
  if (_chooseGeometryOption(selectedOptions) == 'angle') {
    const triples = <(double, double, double)>[(3, 4, 5), (5, 12, 13), (8, 15, 17)];
    final values = triples[randomFromInterval(0, triples.length - 1)];
    final angle = (asin(values.$1 / values.$3) * 180 / pi).round();
    return Exercise(
      question: '\\text{Dans un triangle rectangle, le côté opposé à l’angle A mesure } ${values.$1}\\,cm \\text{ et l’hypoténuse } ${values.$3}\\,cm. \\text{Calculer A au degré près.}',
      answer: '${angle}^\\circ',
      help: '\\sin(A) = \\frac{\\text{côté opposé}}{\\text{hypoténuse}}.',
      details: '\\sin(A) = \\frac{${values.$1}}{${values.$3}} \\Longrightarrow A \\approx ${angle}^\\circ',
    );
  }
  final hypotenuse = randomFromInterval(2, 12) * 2;
  return Exercise(
    question: '\\text{Dans un triangle rectangle, A mesure } 30^\\circ \\text{ et l’hypoténuse } ${hypotenuse}\\,cm. \\text{Calculer le côté opposé à A.}',
    answer: '\\frac{$hypotenuse}{2}\\,cm',
    help: '\\sin(30^\\circ) = \\frac{1}{2}.',
    details: '\\text{Côté opposé} = ${hypotenuse} \\times \\sin(30^\\circ) = \\frac{$hypotenuse}{2}\\,cm',
  );
}

