import 'exercises.dart';

enum ExerciseVisualKind {
  rectangle,
  circle,
  triangle,
  rightTriangle,
  thales,
  coordinates,
  numberLine,
  conversion,
}

class ExerciseVisual {
  const ExerciseVisual({
    required this.kind,
    this.labelA,
    this.labelB,
    this.labelC,
    this.pointX,
    this.pointY,
    this.numberValue,
    this.units = const [],
    this.fromColumn,
    this.toColumn,
    this.columnsPerUnit = 1,
    this.sourceValue,
    this.targetValue,
    this.sourceUnit,
    this.targetUnit,
  });

  final ExerciseVisualKind kind;
  final String? labelA;
  final String? labelB;
  final String? labelC;
  final int? pointX;
  final int? pointY;
  final double? numberValue;
  final List<String> units;
  final int? fromColumn;
  final int? toColumn;
  final int columnsPerUnit;
  final String? sourceValue;
  final String? targetValue;
  final String? sourceUnit;
  final String? targetUnit;
}

class IllustratedExercise extends Exercise {
  const IllustratedExercise({
    required super.question,
    required super.answer,
    required this.visual,
    super.help,
    super.details,
  });

  final ExerciseVisual visual;
}

