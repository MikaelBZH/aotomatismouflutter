import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/exercise_visual.dart';
import '../theme/app_theme.dart';

class ExerciseVisualPanel extends StatelessWidget {
  const ExerciseVisualPanel({required this.visual, super.key});

  final ExerciseVisual visual;

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
        label: 'Schéma de géométrie associé à l’exercice',
        child: SizedBox(
          height: 210,
          width: double.infinity,
          child: CustomPaint(
            painter: _ExerciseDiagramPainter(visual),
          ),
        ),
      ),
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
                  height: 94,
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
                      Positioned(
                        top: 32,
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
                          '${visual.sourceValue}:${visual.targetValue}:$from:$to',
                        ),
                        tween: Tween<double>(
                          begin: from.toDouble(),
                          end: to.toDouble(),
                        ),
                        duration: const Duration(milliseconds: 1900),
                        curve: Curves.easeInOutBack,
                        builder: (context, column, child) => Positioned(
                          top: 54,
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
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${visual.sourceValue ?? ''} ${visual.sourceUnit ?? ''}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.arrow_forward, color: AppColors.orange),
                ),
                Text(
                  '${visual.targetValue ?? ''} ${visual.targetUnit ?? ''}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.teal,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ],
            ),
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
  const _ExerciseDiagramPainter(this.visual);

  final ExerciseVisual visual;

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
        _drawCoordinates(canvas, size, line, pointPaint);
        break;
      case ExerciseVisualKind.numberLine:
        _drawNumberLine(canvas, size, line, pointPaint);
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
    final a = Offset(size.width * .18, size.height * .78);
    final b = Offset(size.width * .82, size.height * .78);
    final c = Offset(size.width * .62, size.height * .16);
    canvas.drawLine(a, b, line);
    canvas.drawLine(b, c, line);
    canvas.drawLine(c, a, line);
    final foot = Offset(c.dx, a.dy);
    _drawDashedLine(canvas, c, foot, accent);
    _label(canvas, visual.labelA ?? 'base', Offset((a.dx + b.dx) / 2, a.dy + 10));
    _label(canvas, visual.labelB ?? 'hauteur', Offset(c.dx + 42, (c.dy + foot.dy) / 2));
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
    final a = Offset(size.width * .16, size.height * .82);
    final b = Offset(size.width * .84, size.height * .82);
    final c = Offset(size.width * .57, size.height * .13);
    final d = Offset(a.dx + (b.dx - a.dx) * .55, a.dy);
    final e = Offset(a.dx + (c.dx - a.dx) * .55, a.dy + (c.dy - a.dy) * .55);
    canvas.drawLine(a, b, line);
    canvas.drawLine(a, c, line);
    canvas.drawLine(c, b, line);
    canvas.drawLine(d, e, accent);
    _label(canvas, 'A', a + const Offset(-12, 4));
    _label(canvas, 'B', b + const Offset(12, 4));
    _label(canvas, 'C', c + const Offset(0, -12));
    _label(canvas, 'D', d + const Offset(0, 14));
    _label(canvas, 'E', e + const Offset(-14, 0));
    _label(canvas, visual.labelA ?? 'DE ∥ AB', Offset(size.width * .72, size.height * .34));
  }

  void _drawCoordinates(Canvas canvas, Size size, Paint line, Paint pointPaint) {
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
    final pointX = (visual.pointX ?? 3).clamp(-8, 8);
    final pointY = (visual.pointY ?? 2).clamp(-8, 8);
    final x = pointX.toDouble();
    final y = pointY.toDouble();
    final point = Offset(origin.dx + x * stepX, origin.dy - y * stepY);
    canvas.drawCircle(point, 6, pointPaint);
    _label(
      canvas,
      'A($pointX ; $pointY)',
      point + const Offset(0, -18),
      color: AppColors.teal,
    );
  }

  void _drawNumberLine(Canvas canvas, Size size, Paint line, Paint pointPaint) {
    final y = size.height * .57;
    final left = size.width * .08;
    final right = size.width * .92;
    canvas.drawLine(Offset(left, y), Offset(right, y), line);
    for (var i = 0; i <= 12; i++) {
      final x = left + (right - left) * i / 12;
      canvas.drawLine(Offset(x, y - 8), Offset(x, y + 8), line);
      if (i % 2 == 0) _label(canvas, '${i - 6}', Offset(x, y + 16));
    }
    final value = (visual.numberValue ?? .5).clamp(-6, 6).toDouble();
    final x = left + (value + 6) / 12 * (right - left);
    canvas.drawCircle(Offset(x, y), 6, pointPaint);
    _label(canvas, 'A', Offset(x, y - 24), color: AppColors.teal);
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
      oldDelegate.visual != visual;
}

