import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../models/exercises.dart';
import '../models/exercise_visual.dart';
import '../theme/app_theme.dart';
import '../widgets/menu.dart';
import '../widgets/exercise_visual.dart';

class ExercisesPage extends StatefulWidget {
  const ExercisesPage({required this.module, super.key});

  final ExerciseModule module;

  @override
  State<ExercisesPage> createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  late final Set<String> selectedOptions;
  final ExpansibleController optionsController = ExpansibleController();
  Exercise? exercise;
  bool displayAnswer = false;

  @override
  void initState() {
    super.initState();
    selectedOptions = widget.module.options.map((option) => option.id).toSet();
    exercise = widget.module.generateExercise(selectedOptions);
  }

  void _updateOption(String id, bool selected) {
    setState(() {
      if (selected) {
        selectedOptions.add(id);
      } else {
        selectedOptions.remove(id);
      }
      exercise = widget.module.generateExercise(selectedOptions);
      displayAnswer = false;
    });
  }

  void _generateNext() {
    setState(() {
      exercise = widget.module.generateExercise(selectedOptions);
      displayAnswer = false;
    });
  }

  Future<void> _showHelp() async {
    final help = exercise?.help;
    if (help == null) return;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => _InformationDialog(
        title: 'Skoazell',
        content: Text(help, style: Theme.of(dialogContext).textTheme.bodyLarge),
        icon: Icons.lightbulb_outline,
        color: AppColors.teal,
      ),
    );
  }

  Future<void> _showDetails() async {
    final details = exercise?.details;
    if (details == null) return;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => _InformationDialog(
        title: 'Difaziadenn',
        content: Math.tex(
          details,
          textStyle: Theme.of(dialogContext).textTheme.bodyLarge,
        ),
        icon: Icons.fact_check_outlined,
        color: AppColors.teal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentExercise = exercise;
    final visual = currentExercise is IllustratedExercise
        ? currentExercise.visual
        : null;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Aotomatismoù'),
            Text(
              widget.module.title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.muted,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
      drawer: const Menu(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 600;
          return SingleChildScrollView(
            padding: EdgeInsets.all(compact ? 14 : 28),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 920),
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(compact ? 18 : 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'OBERIADENNOÙ',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: AppColors.teal,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.6,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.module.title,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        if (widget.module.options.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: AppColors.line),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: ExpansionTile(
                              controller: optionsController,
                              shape: const Border(),
                              collapsedShape: const Border(),
                              leading: const Icon(
                                Icons.tune,
                                color: AppColors.teal,
                              ),
                              title: const Text('Dibaboù posupl'),
                              children: [
                                for (final option in widget.module.options)
                                  CheckboxListTile(
                                    dense: true,
                                    value: selectedOptions.contains(option.id),
                                    title: Text(option.label),
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    onChanged: (value) => _updateOption(
                                      option.id,
                                      value ?? false,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                        _ExerciseSurface(
                          child: currentExercise == null
                              ? const Text(
                                  "Dibab un oberiadenn d'an nebeutañ",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 19,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              : FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Math.tex(
                                    currentExercise.question,
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: compact ? 29 : 38,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                          action: currentExercise?.help == null
                              ? null
                              : IconButton(
                                  tooltip: 'Skoazell',
                                  color: Colors.white,
                                  onPressed: _showHelp,
                                  icon: const Icon(Icons.help_outline),
                                ),
                        ),
                        if (visual != null)
                          ExerciseVisualPanel(
                            key: ValueKey(currentExercise?.question),
                            visual: visual,
                          ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          alignment: WrapAlignment.center,
                          children: [
                            FilledButton.icon(
                              onPressed: currentExercise == null
                                  ? null
                                  : () {
                                      if (optionsController.isExpanded) {
                                        optionsController.collapse();
                                      }
                                      setState(
                                        () => displayAnswer = !displayAnswer,
                                      );
                                    },
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.teal,
                                foregroundColor: Colors.white,
                              ),
                              icon: Icon(displayAnswer
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined),
                              label: Text(
                                displayAnswer ? 'Kuzhaat ar respont' : 'Respont',
                              ),
                            ),
                            FilledButton.icon(
                              onPressed: selectedOptions.isEmpty
                                  ? null
                                  : _generateNext,
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.orange,
                                foregroundColor: Colors.white,
                              ),
                              icon: const Icon(Icons.refresh),
                              label: const Text('Nevez'),
                            ),
                          ],
                        ),
                        if (displayAnswer && currentExercise != null) ...[
                          const SizedBox(height: 16),
                          _ExerciseSurface(
                            color: AppColors.mint,
                            borderColor: const Color(0xFFA6D2C9),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Math.tex(
                                currentExercise.answer,
                                textStyle: const TextStyle(
                                  color: AppColors.ink,
                                  fontSize: 34,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            action: currentExercise.details == null
                                ? null
                                : IconButton(
                                    tooltip: 'Difaziadenn',
                                    color: AppColors.teal,
                                    onPressed: _showDetails,
                                    icon: const Icon(
                                      Icons.fact_check_outlined,
                                    ),
                                  ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ExerciseSurface extends StatelessWidget {
  const _ExerciseSurface({
    required this.child,
    this.color = AppColors.ink,
    this.borderColor,
    this.action,
  });

  final Widget child;
  final Color color;
  final Color? borderColor;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 160),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        color: color,
        border: borderColor == null ? null : Border.all(color: borderColor!),
        borderRadius: BorderRadius.circular(18),
        boxShadow: color == AppColors.ink
            ? const [
                BoxShadow(
                  color: Color(0x1F18344A),
                  blurRadius: 22,
                  offset: Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: action == null
                ? EdgeInsets.zero
                : const EdgeInsets.symmetric(horizontal: 28),
            child: Center(child: child),
          ),
          if (action != null)
            Positioned(top: -18, right: -18, child: action!),
        ],
      ),
    );
  }
}

class _InformationDialog extends StatelessWidget {
  const _InformationDialog({
    required this.title,
    required this.content,
    required this.icon,
    required this.color,
  });

  final String title;
  final Widget content;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      clipBehavior: Clip.antiAlias,
      backgroundColor: AppColors.paper,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: color,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(icon, color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            Padding(padding: const EdgeInsets.all(24), child: content),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.orange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Serriñ'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

