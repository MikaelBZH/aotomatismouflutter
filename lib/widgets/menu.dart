import 'package:flutter/material.dart';
import '../pages/exercises_page.dart';
import '../pages/home_page.dart';
import '../exercises/exercise_catalog.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.orange[400],
              ),
              child: const Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Aotomatismoù',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              )
          ),

          // Menu Home
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text(
              'Degemer',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),

          const Divider(),

          // Exercises Menu
          ...exerciseCategories.map((category) {
            final modules = exerciseCatalog
              .where((module) => module.categoryId == category.id)
              .toList();
            return ExpansionTile(
              leading: const Icon(Icons.category),
              title: Text(category.title),
              children: modules.map((module) {
                return ListTile(
                  leading: const Icon(Icons.book),
                  title: Text(module.title),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExercisesPage(module: module),
                      ),
                    ); // push
                  }, //onTap
                );
              }).toList(),
            );
          }), // ...exerciseCategories.map
        ], // children ListView
      ),
    );
  }
}