import 'package:flutter/material.dart';
import '../widgets/menu.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Aotomatismoù',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        backgroundColor: Colors.orange[500],
        centerTitle: true,
        ),

      drawer: const Menu(),

      body: const Center(
        child: Text('Degemer mat!'),
      ),
    );

  }
}