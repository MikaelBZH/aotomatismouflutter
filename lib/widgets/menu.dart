import 'package:flutter/material.dart';

import '../exercises/exercise_catalog.dart';
import '../models/exercises.dart';
import '../pages/exercises_page.dart';
import '../theme/app_theme.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    final itemStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        );

    return Drawer(
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
          children: [
            Container(
              height: 112,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: BoxDecoration(
                color: const Color(0x1AFFFFFF),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0x1AFFFFFF)),
              ),
              alignment: Alignment.bottomLeft,
              child: const Text(
                'Aotomatismoù',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined, color: Colors.white),
              title: Text('Degemer', style: itemStyle),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onTap: () {
                final navigator = Navigator.of(context);
                navigator.pop();
                navigator.popUntil((route) => route.isFirst);
              },
            ),
            const Divider(height: 18, color: Color(0x22FFFFFF)),
            for (final category in exerciseCategories)
              Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.transparent,
                  colorScheme: Theme.of(context).colorScheme.copyWith(
                        onSurface: Colors.white,
                      ),
                ),
                child: ExpansionTile(
                  leading: const Icon(Icons.category_outlined, color: Colors.white),
                  iconColor: Colors.white,
                  collapsedIconColor: Colors.white70,
                  tilePadding: const EdgeInsets.symmetric(horizontal: 12),
                  childrenPadding: const EdgeInsets.only(left: 14, bottom: 6),
                  collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Color(0x1AFFFFFF)),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Color(0x1AFFFFFF)),
                  ),
                  collapsedBackgroundColor: const Color(0x14FFFFFF),
                  title: Text(
                    category.title,
                    style: itemStyle?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  children: [
                    for (final module in exerciseCatalog.where(
                      (item) => item.categoryId == category.id,
                    ))
                      ListTile(
                        dense: true,
                        visualDensity: VisualDensity.compact,
                        leading: const Icon(
                          Icons.book_outlined,
                          size: 19,
                          color: Colors.white70,
                        ),
                        title: Text(
                          module.title,
                          style: itemStyle?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        shape: const Border(
                          left: BorderSide(color: AppColors.orange, width: 2),
                        ),
                        onTap: () => _openExercise(context, module),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _openExercise(BuildContext context, ExerciseModule module) {
    final navigator = Navigator.of(context);
    navigator.pop();
    navigator.push(
      MaterialPageRoute<void>(
        builder: (_) => ExercisesPage(module: module),
      ),
    );
  }
}

