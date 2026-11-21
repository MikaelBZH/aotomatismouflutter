import 'dart:math';

import '../../functions/utils.dart';
import '../../models/exercises.dart';
import '../../models/exercise_visual.dart';

const coordinateOptions = <ExerciseOptions>[
  ExerciseOptions(id: 'read', label: 'Lenn kenurzhiennoù'),
  ExerciseOptions(id: 'locate', label: 'Daveañ ur poent'),
];

const pythagorasOptions = <ExerciseOptions>[
  ExerciseOptions(id: 'relation', label: 'Skrivañ al liammadur'),
];

const thalesOptions = <ExerciseOptions>[
  ExerciseOptions(id: 'missingLength', label: 'Kavout un hirder'),
];

const trigonometryOptions = <ExerciseOptions>[
  ExerciseOptions(id: 'formula', label: 'Dibab ur formulenn'),
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
    return IllustratedExercise(
      question: '\\text{Lire les coordonnées du point A.}',
      answer: 'A($x\\,;\\,$y)',
      help: 'On écrit d’abord l’abscisse, puis l’ordonnée.',
      visual: ExerciseVisual(
        kind: ExerciseVisualKind.coordinates,
        pointX: x,
        pointY: y,
      ),
    );
  }
  return IllustratedExercise(
    question: '\\text{Placer le point A}($x\\,;\\,$y) \\text{ dans le repère.}',
    answer: 'A($x\\,;\\,$y)',
    help: 'Pars de l’origine : avance selon l’abscisse, puis selon l’ordonnée.',
    visual: ExerciseVisual(
      kind: ExerciseVisualKind.coordinates,
      pointX: x,
      pointY: y,
      showPointBeforeAnswer: false,
    ),
  );
}

Exercise? randomPythagoras(Set<String> selectedOptions) {
  if (selectedOptions.isEmpty) return null;
  const vertices = ['A', 'B', 'C'];
  final rightIndex = randomFromInterval(0, 2);
  final rightVertex = vertices[rightIndex];
  final acuteVertices = vertices.toList();
  acuteVertices.remove(rightVertex);
  String segment(String first, String second) =>
      ([first, second]..sort()).join();

  final hypotenuse = segment(acuteVertices[0], acuteVertices[1]);
  final firstLeg = segment(rightVertex, acuteVertices[0]);
  final secondLeg = segment(rightVertex, acuteVertices[1]);
  final target = <String>[hypotenuse, firstLeg, secondLeg][randomFromInterval(0, 2)];
  final otherLeg = target == firstLeg ? secondLeg : firstLeg;
  final relation = target == hypotenuse
      ? '$hypotenuse^2 = $firstLeg^2 + $secondLeg^2'
      : '$target^2 = $hypotenuse^2 - $otherLeg^2';

  return Exercise(
    question: '\\text{ABC est rectangle en } $rightVertex. \\text{Quelle relation de Pythagore permet de calculer } $target\\,?',
    answer: relation,
    help: 'L’hypoténuse est le côté opposé à l’angle droit. Son carré est égal à la somme des carrés des deux autres côtés.',
    details: relation,
  );
}

Exercise? randomThales(Set<String> selectedOptions) {
  if (selectedOptions.isEmpty) return null;
  const sideChoices = [2, 3, 4, 5, 6, 8, 10];
  const ratios = [0.5, 1.5, 2.0, 2.5, 3.0];
  final ratio = ratios[randomFromInterval(0, ratios.length - 1)];
  final ab = sideChoices[randomFromInterval(0, sideChoices.length - 1)].toDouble();
  final acChoices = sideChoices.where((value) => value != ab).toList();
  final ac = acChoices[randomFromInterval(0, acChoices.length - 1)].toDouble();
  final possibleBc = sideChoices
      .where((value) => value > (ab - ac).abs() && value < ab + ac)
      .toList();
  final bc = possibleBc.isEmpty
      ? (ab + ac) / 2
      : possibleBc[randomFromInterval(0, possibleBc.length - 1)].toDouble();
  final lengths = <String, double>{
    'AB': ab,
    'AC': ac,
    'BC': bc,
    'AD': ab * ratio,
    'AE': ac * ratio,
    'DE': bc * ratio,
  };
  const segmentNames = ['AB', 'AC', 'BC', 'AD', 'AE', 'DE'];
  final target = segmentNames[randomFromInterval(0, segmentNames.length - 1)];
  final labels = <String, String>{
    for (final name in segmentNames)
      name: name == target ? '?' : '${_formatLength(lengths[name]!)} cm',
  };
  final known = segmentNames.where((name) => name != target).toList();
  final line1 = known.take(3).map((name) => '$name = ${_formatLength(lengths[name]!)}').join(', ');
  final line2 = known.skip(3).map((name) => '$name = ${_formatLength(lengths[name]!)}').join(', ');
  final formula = _thalesDetails(target, lengths);

  return IllustratedExercise(
    question: '\\begin{aligned}&\\text{Sur la figure, } (BC) \\parallel (DE).\\\\&\\text{Calculer } $target.\\\\&$line1\\\\&$line2\\end{aligned}',
    answer: '${_formatLength(lengths[target]!)}\\,cm',
    help: 'Les côtés correspondants sont proportionnels. Identifie les deux triangles et les rapports égaux.',
    details: formula,
    visual: ExerciseVisual(
      kind: ExerciseVisualKind.thales,
      thalesRatio: ratio,
      thalesButterfly: randomFromInterval(0, 1) == 1,
      segmentLabels: labels,
    ),
  );
}

Exercise? randomTrigonometry(Set<String> selectedOptions) {
  if (selectedOptions.isEmpty) return null;
  const vertices = ['A', 'B', 'C'];
  final rightIndex = randomFromInterval(0, 2);
  final rightVertex = vertices[rightIndex];
  final acuteVertices = vertices.where((vertex) => vertex != rightVertex).toList();
  final angleVertex = acuteVertices[randomFromInterval(0, 1)];
  final otherAcute = acuteVertices.firstWhere((vertex) => vertex != angleVertex);
  String segment(String first, String second) =>
      ([first, second]..sort()).join();

  final hypotenuse = segment(acuteVertices[0], acuteVertices[1]);
  final adjacent = segment(angleVertex, rightVertex);
  final opposite = segment(otherAcute, rightVertex);
  final sides = [hypotenuse, adjacent, opposite];
  final known = sides[randomFromInterval(0, sides.length - 1)];
  var target = sides[randomFromInterval(0, sides.length - 1)];
  while (target == known) {
    target = sides[randomFromInterval(0, sides.length - 1)];
  }

  final trig = (known == hypotenuse || target == hypotenuse) &&
          (known == adjacent || target == adjacent)
      ? 'cos'
      : (known == hypotenuse || target == hypotenuse) &&
              (known == opposite || target == opposite)
          ? 'sin'
          : 'tan';
  final relation = switch (trig) {
    'cos' => '\\cos(\\widehat{$angleVertex}) = \\frac{$adjacent}{$hypotenuse}',
    'sin' => '\\sin(\\widehat{$angleVertex}) = \\frac{$opposite}{$hypotenuse}',
    _ => '\\tan(\\widehat{$angleVertex}) = \\frac{$opposite}{$adjacent}',
  };
  final isolated = trig == 'cos'
      ? target == adjacent
          ? '$adjacent = $hypotenuse \\times \\cos(\\widehat{$angleVertex})'
          : '$hypotenuse = \\frac{$adjacent}{\\cos(\\widehat{$angleVertex})}'
      : trig == 'sin'
          ? target == opposite
              ? '$opposite = $hypotenuse \\times \\sin(\\widehat{$angleVertex})'
              : '$hypotenuse = \\frac{$opposite}{\\sin(\\widehat{$angleVertex})}'
          : target == opposite
              ? '$opposite = $adjacent \\times \\tan(\\widehat{$angleVertex})'
              : '$adjacent = \\frac{$opposite}{\\tan(\\widehat{$angleVertex})}';

  return Exercise(
    question: '\\begin{aligned}&\\text{ABC est rectangle en } $rightVertex.\\\\&\\text{On connaît } \\widehat{$angleVertex} \\text{ et } $known.\\\\&\\text{On cherche } $target.\\\\&\\text{Quelle formule trigonométrique utiliser ?}\\end{aligned}',
    answer: '\\begin{aligned}$relation\\\\$isolated\\end{aligned}',
    help: 'Par rapport à l’angle connu, repère l’hypoténuse, le côté opposé et le côté adjacent.',
    details: '\\begin{aligned}$relation\\\\$isolated\\end{aligned}',
  );
}

String _formatLength(num value) =>
    value.toStringAsFixed(value % 1 == 0 ? 0 : 1).replaceAll('.', ',');

String _thalesDetails(String target, Map<String, double> lengths) {
  const proportions = '\\frac{AB}{AD} = \\frac{AC}{AE} = \\frac{BC}{DE}';
  final computed = switch (target) {
    'AB' => '\\frac{${_formatLength(lengths['AD']!)} \\times ${_formatLength(lengths['AC']!)}}{${_formatLength(lengths['AE']!)}}',
    'AD' => '\\frac{${_formatLength(lengths['AB']!)} \\times ${_formatLength(lengths['AE']!)}}{${_formatLength(lengths['AC']!)}}',
    'AC' => '\\frac{${_formatLength(lengths['AE']!)} \\times ${_formatLength(lengths['AB']!)}}{${_formatLength(lengths['AD']!)}}',
    'AE' => '\\frac{${_formatLength(lengths['AC']!)} \\times ${_formatLength(lengths['AD']!)}}{${_formatLength(lengths['AB']!)}}',
    'BC' => '\\frac{${_formatLength(lengths['DE']!)} \\times ${_formatLength(lengths['AB']!)}}{${_formatLength(lengths['AD']!)}}',
    _ => '\\frac{${_formatLength(lengths['BC']!)} \\times ${_formatLength(lengths['AD']!)}}{${_formatLength(lengths['AB']!)}}',
  };
  return '$proportions \\quad $target = $computed = ${_formatLength(lengths[target]!)}\\,cm';
}

