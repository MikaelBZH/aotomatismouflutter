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
    this.triangleBase,
    this.triangleFoot,
    this.triangleHeight,
    this.pointX,
    this.pointY,
    this.numberValue,
    this.numberLineStart = -10,
    this.numberLineRange = 20,
    this.numberLineSubdivisions = 1,
    this.showPointBeforeAnswer = true,
    this.units = const [],
    this.secondaryUnitLabels = const {},
    this.fromColumn,
    this.toColumn,
    this.columnsPerUnit = 1,
    this.thalesRatio = 0.5,
    this.thalesButterfly = false,
    this.segmentLabels = const {},
    this.sourceValue,
    this.targetValue,
    this.sourceUnit,
    this.targetUnit,
  });

  final ExerciseVisualKind kind;
  final String? labelA;
  final String? labelB;
  final String? labelC;
  final double? triangleBase;
  final double? triangleFoot;
  final double? triangleHeight;
  final int? pointX;
  final int? pointY;
  final double? numberValue;
  final int numberLineStart;
  final int numberLineRange;
  final int numberLineSubdivisions;
  final bool showPointBeforeAnswer;
  final List<String> units;
  final Map<int, String> secondaryUnitLabels;
  final int? fromColumn;
  final int? toColumn;
  final int columnsPerUnit;
  final double thalesRatio;
  final bool thalesButterfly;
  final Map<String, String> segmentLabels;
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

