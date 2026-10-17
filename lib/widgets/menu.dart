import 'package:flutter/material.dart';
import '../pages/exercises_page.dart';
import '../pages/home_page.dart';

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

          // Menu Niveroù ha Jedadennoù
          ExpansionTile(
            leading: const Icon(Icons.calculate),
            title: const Text('Niveroù ha Jedadennoù',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            children: [
              ListTile(
                leading: const Icon(Icons.arrow_forward_ios),
                title: const Text(
                    'Jedadennoù',
                    style: TextStyle(
                      fontSize: 16,
                    )
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ExercisesPage()),
                  );
                },
              ),
              const ListTile(
                leading: Icon(Icons.arrow_forward_ios),
                title: Text(
                    'Kevrennoù',
                    style: TextStyle(
                      fontSize: 16,
                    )
                ),
              ),
            ],
          ),

          // Menu Spas ha mentoniezh
          const ExpansionTile(
            leading: Icon(Icons.category),
            title: Text('Spas ha Mentoniezh',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            children: [
              ListTile(
                leading: Icon(Icons.arrow_forward_ios),
                title: Text(
                    'Liammadur Pitagoras',
                    style: TextStyle(
                      fontSize: 16,
                    )
                ),
              ),
              ListTile(
                leading: Icon(Icons.arrow_forward_ios),
                title: Text(
                    'Perzh Thales',
                    style: TextStyle(
                      fontSize: 16,
                    )
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}