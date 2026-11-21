import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/exercise_visual.dart';
import '../theme/app_theme.dart';

class ExerciseVisualPanel extends StatelessWidget {
  const ExerciseVisualPanel({
    required this.visual,
    this.revealSolution = false,
    super.key,
  });

  final ExerciseVisual visual;
  final bool revealSolution;

  @override
  Widget build(BuildContext context) {
    if (visual.kind == ExerciseVisualKind.conversion) {
      return _ConversionMovement(visual: visual);
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Semantics(
        label: visual.showPointBeforeAnswer
            ? 'Schéma associé à l’exercice'
            : 'Schéma interactif : toucher pour placer un point',
        child: _ExerciseDiagramPanel(
          visual: visual,
          revealSolution: revealSolution,
        ),
      ),
    );
  }
}

class _ExerciseDiagramPanel extends StatefulWidget {
  const _ExerciseDiagramPanel({
    required this.visual,
    required this.revealSolution,
  });

  final ExerciseVisual visual;
  final bool revealSolution;

  @override
  State<_ExerciseDiagramPanel> createState() => _ExerciseDiagramPanelState();
}

class _ExerciseDiagramPanelState extends State<_ExerciseDiagramPanel> {
  double? selectedNumberValue;
  Offset? selectedCoordinates;

  bool get isPlacementExercise =>
      !widget.visual.showPointBeforeAnswer &&
      (widget.visual.kind == ExerciseVisualKind.coordinates ||
          widget.visual.kind == ExerciseVisualKind.numberLine);

  void _selectPoint(Offset position, Size size) {
    if (!isPlacementExercise || widget.revealSolution) return;

    setState(() {
      if (widget.visual.kind == ExerciseVisualKind.coordinates) {
        final origin = Offset(size.width * .5, size.height * .52);
        final stepX = size.width * .44 / 8;
        final stepY = size.height * .42 / 8;
        final x = ((position.dx - origin.dx) / stepX)
            .round()
            .clamp(-8, 8)
            .toDouble();
        final y = ((origin.dy - position.dy) / stepY)
            .round()
            .clamp(-8, 8)
            .toDouble();
        if (selectedCoordinates?.dx == x && selectedCoordinates?.dy == y) {
          selectedCoordinates = null;
        } else {
          selectedCoordinates = Offset(x, y);
        }
        return;
      }

      final start = widget.visual.numberLineStart;
      final range = math.max(1, widget.visual.numberLineRange).toInt();
      final subdivisions =
          math.max(1, widget.visual.numberLineSubdivisions).toInt();
      final left = size.width * .08;
      final right = size.width * .92;
      final rawValue = start + (position.dx - left) / (right - left) * range;
      final stepCount = ((rawValue - start) * subdivisions).round();
      selectedNumberValue = (start + stepCount / subdivisions)
          .clamp(start.toDouble(), (start + range).toDouble())
          .toDouble();
    });
  }

  bool? get placementIsCorrect {
    if (!widget.revealSolution || !isPlacementExercise) return null;
    if (widget.visual.kind == ExerciseVisualKind.coordinates) {
      final selected = selectedCoordinates;
      if (selected == null) return null;
      return selected.dx == (widget.visual.pointX ?? 3).toDouble() &&
          selected.dy == (widget.visual.pointY ?? 2).toDouble();
    }

    final selected = selectedNumberValue;
    if (selected == null) return null;
    return (selected - (widget.visual.numberValue ??
                widget.visual.numberLineStart + .5))
            .abs() <
        .001;
  }

  @override
  Widget build(BuildContext context) {
    final visual = widget.visual;
    final canPlacePoint = isPlacementExercise && !widget.revealSolution;
    return LayoutBuilder(
      builder: (context, constraints) {
        final diagramSize = Size(constraints.maxWidth, 210);
        return Column(
          children: [
            SizedBox(
              height: diagramSize.height,
              width: double.infinity,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: canPlacePoint
                    ? (details) => _selectPoint(
                          details.localPosition,
                          diagramSize,
                        )
                    : null,
                child: CustomPaint(
                  painter: _ExerciseDiagramPainter(
                    visual,
                    widget.revealSolution,
                    selectedNumberValue: selectedNumberValue,
                    selectedCoordinates: selectedCoordinates,
                  ),
                ),
              ),
            ),
            if (canPlacePoint) ...[
              const SizedBox(height: 4),
              Text(
                visual.kind == ExerciseVisualKind.numberLine
                    ? 'Touchez une graduation pour placer le point.'
                    : 'Touchez le repère pour placer le point.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.muted,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
            if (widget.revealSolution && isPlacementExercise) ...[
              const SizedBox(height: 4),
              Text(
                placementIsCorrect == null
                    ? 'Le point vert indique la solution.'
                    : placementIsCorrect!
                        ? 'C’est correct !'
                        : 'Ce n’est pas exact. Le point vert montre la solution.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: placementIsCorrect == true
                          ? AppColors.teal
                          : AppColors.orangeDark,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _ConversionMovement extends StatelessWidget {
  const _ConversionMovement({required this.visual});

  final ExerciseVisual visual;

  @override
  Widget build(BuildContext context) {
    final columnsPerUnit = math.max(1, visual.columnsPerUnit).toInt();
    // Leave room around the seven unit groups, as in the site's conversion
    // table. fromColumn/toColumn identify units, not individual digit cells.
    final totalColumns = (visual.units.length + 5) * columnsPerUnit;
    final fromUnit =
        (visual.fromColumn ?? 0).clamp(0, visual.units.length - 1).toInt();
    final toUnit =
        (visual.toColumn ?? fromUnit).clamp(0, visual.units.length - 1).toInt();
    final from = (fromUnit + 3) * columnsPerUnit;
    final to = (toUnit + 3) * columnsPerUnit;
    final hasSecondaryUnits = visual.secondaryUnitLabels.isNotEmpty;
    final digitsTop = hasSecondaryUnits ? 54.0 : 32.0;
    final tableHeight = hasSecondaryUnits ? 116.0 : 94.0;
    final valueParts = (visual.sourceValue ?? '').split(',');
    final integerDigits = valueParts.first.split('');
    final decimalDigits = valueParts.length > 1 ? valueParts[1].split('') : <String>[];

    return Container(
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            'Mouvement de la virgule',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) {
              final cellWidth = constraints.maxWidth / totalColumns;
              final tableWidth = cellWidth * totalColumns;
              return Center(
                child: SizedBox(
                  width: tableWidth,
                  height: tableHeight,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: 32,
                        child: Row(
                          children: [
                            SizedBox(width: cellWidth * 2 * columnsPerUnit),
                            for (final unit in visual.units)
                              Container(
                                width: cellWidth * columnsPerUnit,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.cream,
                                  border: Border.all(color: AppColors.line),
                                ),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    unit,
                                    style: const TextStyle(
                                      color: AppColors.ink,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                            SizedBox(width: cellWidth * 3 * columnsPerUnit),
                          ],
                        ),
                      ),
                      if (hasSecondaryUnits)
                        Positioned(
                          top: 32,
                          left: 0,
                          right: 0,
                          height: 22,
                          child: Row(
                            children: [
                              for (var column = 0;
                                  column < totalColumns;
                                  column++)
                                Container(
                                  width: cellWidth,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: column >= 2 * columnsPerUnit &&
                                            column <
                                                (visual.units.length + 2) *
                                                    columnsPerUnit
                                        ? Border.all(color: AppColors.line)
                                        : null,
                                  ),
                                  child: visual.secondaryUnitLabels[column] == null
                                      ? null
                                      : FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            visual.secondaryUnitLabels[column]!,
                                            style: const TextStyle(
                                              color: AppColors.muted,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                ),
                            ],
                          ),
                        ),
                      Positioned(
                        top: digitsTop,
                        left: 0,
                        right: 0,
                        height: 40,
                        child: Row(
                          children: [
                            for (var column = 0;
                                column < totalColumns;
                                column++)
                              Container(
                                width: cellWidth,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: column >= 2 * columnsPerUnit &&
                                          column <
                                              (visual.units.length + 2) *
                                                  columnsPerUnit
                                      ? Border.all(color: AppColors.line)
                                      : null,
                                ),
                                child: _conversionDigit(
                                  column,
                                  from,
                                  integerDigits,
                                  decimalDigits,
                                ),
                              ),
                          ],
                        ),
                      ),
                      TweenAnimationBuilder<double>(
                        key: ValueKey(
                          '${visual.sourceValue}:${visual.sourceUnit}:${visual.targetUnit}:$from:$to',
                        ),
                        tween: Tween<double>(
                          begin: from.toDouble(),
                          end: to.toDouble(),
                        ),
                        duration: const Duration(milliseconds: 1900),
                        curve: Curves.easeInOutBack,
                        builder: (context, column, child) => Positioned(
                          top: digitsTop + 22,
                          left: column * cellWidth - 4,
                          child: const Text(
                            ',',
                            style: TextStyle(
                              color: AppColors.orangeDark,
                              fontSize: 34,
                              height: 1,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget? _conversionDigit(
    int column,
    int commaColumn,
    List<String> integerDigits,
    List<String> decimalDigits,
  ) {
    final lastIntegerColumn = commaColumn - 1;
    final firstIntegerColumn = lastIntegerColumn - integerDigits.length + 1;
    if (column >= firstIntegerColumn && column <= lastIntegerColumn) {
      return FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          integerDigits[column - firstIntegerColumn],
          style: const TextStyle(
            color: AppColors.ink,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }
    final decimalIndex = column - commaColumn;
    if (decimalIndex >= 0 && decimalIndex < decimalDigits.length) {
      return FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          decimalDigits[decimalIndex],
          style: const TextStyle(
            color: AppColors.ink,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }
    return null;
  }
}

class _ExerciseDiagramPainter extends CustomPainter {
  const _ExerciseDiagramPainter(
    this.visual,
    this.revealSolution, {
    this.selectedNumberValue,
    this.selectedCoordinates,
  });

  final ExerciseVisual visual;
  final bool revealSolution;
  final double? selectedNumberValue;
  final Offset? selectedCoordinates;

  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = AppColors.muted
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke;
    final accent = Paint()
      ..color = AppColors.orange
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final pointPaint = Paint()
      ..color = AppColors.teal
      ..style = PaintingStyle.fill;
    final selectionPaint = Paint()
      ..color = AppColors.orange
      ..style = PaintingStyle.fill;
    final solutionPaint = Paint()
      ..color = const Color(0xFF278A52)
      ..style = PaintingStyle.fill;

    switch (visual.kind) {
      case ExerciseVisualKind.rectangle:
        _drawRectangle(canvas, size, line, accent);
        break;
      case ExerciseVisualKind.circle:
        _drawCircle(canvas, size, line, accent);
        break;
      case ExerciseVisualKind.triangle:
        _drawTriangle(canvas, size, line, accent);
        break;
      case ExerciseVisualKind.rightTriangle:
        _drawRightTriangle(canvas, size, line, accent);
        break;
      case ExerciseVisualKind.thales:
        _drawThales(canvas, size, line, accent);
        break;
      case ExerciseVisualKind.coordinates:
        _drawCoordinates(
          canvas,
          size,
          line,
          pointPaint,
          selectionPaint,
          solutionPaint,
        );
        break;
      case ExerciseVisualKind.numberLine:
        _drawNumberLine(
          canvas,
          size,
          line,
          pointPaint,
          selectionPaint,
          solutionPaint,
        );
        break;
      case ExerciseVisualKind.conversion:
        break;
    }
  }

  void _drawRectangle(Canvas canvas, Size size, Paint line, Paint accent) {
    final rect = Rect.fromLTWH(
      size.width * .24,
      size.height * .2,
      size.width * .52,
      size.height * .56,
    );
    canvas.drawRect(rect, line);
    canvas.drawLine(
      rect.center,
      Offset(rect.center.dx, rect.bottom),
      accent,
    );
    _label(canvas, visual.labelA ?? 'longueur', Offset(rect.center.dx, rect.bottom + 12));
    _label(canvas, visual.labelB ?? 'largeur', Offset(rect.right + 26, rect.center.dy));
  }

  void _drawCircle(Canvas canvas, Size size, Paint line, Paint accent) {
    final center = Offset(size.width * .5, size.height * .5);
    final radius = math.min(size.width * .26, size.height * .38).toDouble();
    canvas.drawCircle(center, radius, line);
    canvas.drawLine(center, Offset(center.dx + radius, center.dy), accent);
    canvas.drawCircle(center, 4, accent..style = PaintingStyle.fill);
    accent.style = PaintingStyle.stroke;
    _label(canvas, visual.labelA ?? 'r', Offset(center.dx + radius / 2, center.dy - 14));
  }

  void _drawTriangle(Canvas canvas, Size size, Paint line, Paint accent) {
    final base = (visual.triangleBase ?? 10).toDouble();
    final foot = (visual.triangleFoot ?? base * .6875).toDouble();
    final height = (visual.triangleHeight ?? 6).toDouble();
    final minX = math.min(0.0, math.min(base, foot)).toDouble();
    final maxX = math.max(0.0, math.max(base, foot)).toDouble();
    final spanX = maxX - minX;
    final scale = math.min(
      size.width * .66 / spanX,
      size.height * .58 / height,
    ).toDouble();
    final left = (size.width - spanX * scale) / 2;
    final baseline = size.height * .8;
    Offset project(double x, double y) =>
        Offset(left + (x - minX) * scale, baseline - y * scale);

    final a = project(0, 0);
    final b = project(base, 0);
    final c = project(foot, height);
    final d = project(foot, 0);
    canvas.drawLine(a, b, line);
    canvas.drawLine(b, c, line);
    canvas.drawLine(c, a, line);
    if (foot < 0) {
      _drawDashedLine(canvas, a, d, accent);
    } else if (foot > base) {
      _drawDashedLine(canvas, b, d, accent);
    }
    _drawDashedLine(canvas, c, d, accent);
    final rightAngle = Path()
      ..moveTo(d.dx + 9, d.dy)
      ..lineTo(d.dx + 9, d.dy - 9)
      ..lineTo(d.dx, d.dy - 9);
    canvas.drawPath(rightAngle, accent);
    _label(canvas, 'A', a + const Offset(-10, 10), color: AppColors.teal);
    _label(canvas, 'B', b + const Offset(10, 10), color: AppColors.teal);
    _label(canvas, 'C', c + const Offset(0, -12), color: AppColors.teal);
    _label(canvas, 'D', d + const Offset(10, 8), color: AppColors.teal);
    _label(
      canvas,
      visual.labelA ?? 'base',
      Offset((a.dx + b.dx) / 2, a.dy + 10),
    );
    final heightLabelDirection = d.dx > size.width * .68 ? -1 : 1;
    _label(
      canvas,
      visual.labelB ?? 'hauteur',
      Offset(
        d.dx + heightLabelDirection * 38,
        (c.dy + d.dy) / 2,
      ),
    );
    if (visual.labelC != null) {
      _label(
        canvas,
        visual.labelC!,
        Offset((a.dx + c.dx) / 2 - 16, (a.dy + c.dy) / 2 - 4),
      );
    }
  }

  void _drawRightTriangle(Canvas canvas, Size size, Paint line, Paint accent) {
    final a = Offset(size.width * .2, size.height * .8);
    final b = Offset(size.width * .8, size.height * .8);
    final c = Offset(size.width * .2, size.height * .18);
    canvas.drawLine(a, b, line);
    canvas.drawLine(a, c, line);
    canvas.drawLine(c, b, line);
    final corner = Path()
      ..moveTo(a.dx + 16, a.dy)
      ..lineTo(a.dx + 16, a.dy - 16)
      ..lineTo(a.dx, a.dy - 16);
    canvas.drawPath(corner, accent);
    _label(canvas, visual.labelA ?? 'a', Offset((a.dx + b.dx) / 2, a.dy + 10));
    _label(canvas, visual.labelB ?? 'b', Offset(a.dx - 18, (a.dy + c.dy) / 2));
    _label(canvas, visual.labelC ?? 'c', Offset((b.dx + c.dx) / 2 + 10, (b.dy + c.dy) / 2 - 4));
  }

  void _drawThales(Canvas canvas, Size size, Paint line, Paint accent) {
    final ratio = visual.thalesRatio.clamp(.5, 3).toDouble();
    final raw = visual.thalesButterfly
        ? <String, Offset>{
            'A': Offset.zero,
            'B': const Offset(-1, 0),
            'C': const Offset(-.52, -.75),
            'D': Offset(ratio, 0),
            'E': Offset(.52 * ratio, .75 * ratio),
          }
        : <String, Offset>{
            'A': Offset.zero,
            'B': const Offset(1, 0),
            'C': const Offset(.52, -.75),
            'D': Offset(ratio, 0),
            'E': Offset(.52 * ratio, -.75 * ratio),
          };
    final xs = raw.values.map((point) => point.dx).toList();
    final ys = raw.values.map((point) => point.dy).toList();
    final minX = xs.reduce((a, b) => a < b ? a : b);
    final maxX = xs.reduce((a, b) => a > b ? a : b);
    final minY = ys.reduce((a, b) => a < b ? a : b);
    final maxY = ys.reduce((a, b) => a > b ? a : b);
    final scale = math.min(
      (size.width - 76) / (maxX - minX),
      (size.height - 52) / (maxY - minY),
    );
    final center = Offset(size.width / 2, size.height / 2);
    final points = <String, Offset>{
      for (final entry in raw.entries)
        entry.key: Offset(
          center.dx + (entry.value.dx - (minX + maxX) / 2) * scale,
          center.dy - (entry.value.dy - (minY + maxY) / 2) * scale,
        ),
    };

    final segments = <String, (String, String)>{
      'AB': ('A', 'B'),
      'AC': ('A', 'C'),
      'BC': ('B', 'C'),
      'AD': ('A', 'D'),
      'AE': ('A', 'E'),
      'DE': ('D', 'E'),
    };
    for (final segment in segments.entries) {
      final start = points[segment.value.$1]!;
      final end = points[segment.value.$2]!;
      canvas.drawLine(
        start,
        end,
        (segment.key == 'BC' || segment.key == 'DE') ? accent : line,
      );
      final label = visual.segmentLabels[segment.key];
      if (label != null) {
        final delta = end - start;
        final normal = Offset(-delta.dy, delta.dx);
        final normalLength = normal.distance;
        final offset = normalLength == 0
            ? Offset.zero
            : normal / normalLength * 12;
        _label(canvas, label, (start + end) / 2 + offset);
      }
    }

    for (final name in raw.keys) {
      final point = points[name]!;
      final direction = point - center;
      final distance = direction.distance;
      final offset = distance == 0
          ? const Offset(-10, 12)
          : direction / distance * 14;
      _label(canvas, name, point + offset, color: AppColors.teal);
    }
  }

  void _drawCoordinates(
    Canvas canvas,
    Size size,
    Paint line,
    Paint pointPaint,
    Paint selectionPaint,
    Paint solutionPaint,
  ) {
    final origin = Offset(size.width * .5, size.height * .52);
    final stepX = size.width * .44 / 8;
    final stepY = size.height * .42 / 8;
    final grid = Paint()
      ..color = AppColors.line
      ..strokeWidth = 1;
    for (var i = -8; i <= 8; i++) {
      final dx = origin.dx + i * stepX;
      final dy = origin.dy + i * stepY;
      canvas.drawLine(Offset(dx, 8), Offset(dx, size.height - 8), grid);
      canvas.drawLine(Offset(8, dy), Offset(size.width - 8, dy), grid);
    }
    canvas.drawLine(Offset(8, origin.dy), Offset(size.width - 8, origin.dy), line);
    canvas.drawLine(Offset(origin.dx, size.height - 8), Offset(origin.dx, 8), line);
    for (var i = -8; i <= 8; i++) {
      final x = origin.dx + i * stepX;
      final y = origin.dy - i * stepY;
      canvas.drawLine(Offset(x, origin.dy - 3), Offset(x, origin.dy + 3), line);
      canvas.drawLine(Offset(origin.dx - 3, y), Offset(origin.dx + 3, y), line);
      if (i != 0 && i.isEven) {
        _label(canvas, '$i', Offset(x, origin.dy + 13));
        _label(canvas, '$i', Offset(origin.dx - 14, y));
      }
    }
    _label(canvas, 'O', origin + const Offset(-10, 10));
    final targetX = (visual.pointX ?? 3).clamp(-8, 8).toDouble();
    final targetY = (visual.pointY ?? 2).clamp(-8, 8).toDouble();
    if (visual.showPointBeforeAnswer) {
      final point = Offset(
        origin.dx + targetX * stepX,
        origin.dy - targetY * stepY,
      );
      canvas.drawCircle(point, 6, pointPaint);
      _label(canvas, 'A', point + const Offset(0, -18), color: AppColors.teal);
    } else {
      final selected = selectedCoordinates;
      if (selected != null) {
        final userPoint = Offset(
          origin.dx + selected.dx * stepX,
          origin.dy - selected.dy * stepY,
        );
        canvas.drawCircle(userPoint, 6, selectionPaint);
      }
      if (revealSolution) {
        final target = Offset(
          origin.dx + targetX * stepX,
          origin.dy - targetY * stepY,
        );
        canvas.drawCircle(target, 7, solutionPaint);
      }
    }
  }

  void _drawNumberLine(
    Canvas canvas,
    Size size,
    Paint line,
    Paint pointPaint,
    Paint selectionPaint,
    Paint solutionPaint,
  ) {
    final y = size.height * .57;
    final left = size.width * .08;
    final right = size.width * .92;
    canvas.drawLine(Offset(left, y), Offset(right, y), line);
    canvas.drawLine(Offset(right - 8, y - 5), Offset(right, y), line);
    canvas.drawLine(Offset(right - 8, y + 5), Offset(right, y), line);
    final range = math.max(1, visual.numberLineRange).toInt();
    final subdivisions = math.max(1, visual.numberLineSubdivisions).toInt();
    final stepCount = range * subdivisions;
    for (var i = 0; i <= stepCount; i++) {
      final x = left + (right - left) * i / stepCount;
      final isMain = i % subdivisions == 0;
      canvas.drawLine(
        Offset(x, y - (isMain ? 9 : 5)),
        Offset(x, y + (isMain ? 9 : 5)),
        line,
      );
      if (isMain) {
        _label(canvas, '${visual.numberLineStart + i ~/ subdivisions}', Offset(x, y + 20));
      }
    }
    final targetValue = visual.numberValue ?? visual.numberLineStart + .5;
    if (visual.showPointBeforeAnswer) {
      final x = left + (targetValue - visual.numberLineStart) / range * (right - left);
      canvas.drawCircle(Offset(x, y), 6, pointPaint);
      _label(canvas, 'A', Offset(x, y - 24), color: AppColors.teal);
    } else {
      final selected = selectedNumberValue;
      if (selected != null) {
        final x = left + (selected - visual.numberLineStart) / range * (right - left);
        canvas.drawCircle(Offset(x, y), 6, selectionPaint);
      }
      if (revealSolution) {
        final x = left + (targetValue - visual.numberLineStart) / range * (right - left);
        canvas.drawCircle(Offset(x, y), 7, solutionPaint);
      }
    }
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    final delta = end - start;
    final length = delta.distance;
    if (length == 0) return;
    final direction = delta / length;
    for (double offset = 0; offset < length; offset += 10) {
      final segmentEnd = math.min(offset + 5, length).toDouble();
      canvas.drawLine(start + direction * offset, start + direction * segmentEnd, paint);
    }
  }

  void _label(Canvas canvas, String text, Offset center, {Color color = AppColors.ink}) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout();
    painter.paint(canvas, center - Offset(painter.width / 2, painter.height / 2));
  }

  @override
  bool shouldRepaint(covariant _ExerciseDiagramPainter oldDelegate) =>
      oldDelegate.visual != visual ||
      oldDelegate.revealSolution != revealSolution ||
      oldDelegate.selectedNumberValue != selectedNumberValue ||
      oldDelegate.selectedCoordinates != selectedCoordinates;
}

