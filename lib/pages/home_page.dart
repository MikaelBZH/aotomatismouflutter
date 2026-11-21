import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/menu.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aotomatismoù')),
      drawer: const Menu(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 600;
          return SingleChildScrollView(
            padding: EdgeInsets.all(compact ? 18 : 34),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - (compact ? 36 : 68),
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(compact ? 24 : 52),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AOTOMATISMOUÙ',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: AppColors.teal,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2,
                                ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Degemer mat',
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  fontSize: compact ? 42 : 58,
                                ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'Peadra da labourat war an aotomatismoù.',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppColors.muted,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 28),
                          Builder(
                            builder: (context) => FilledButton.icon(
                              onPressed: Scaffold.of(context).openDrawer,
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.orange,
                                foregroundColor: Colors.white,
                              ),
                              icon: const Icon(Icons.menu_book_outlined),
                              label: const Text('Dibab un oberiadenn'),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            '© 2025/2026 — Raktres pedagogel — Implij nann genwerzhel',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.muted,
                                ),
                          ),
                        ],
                      ),
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

