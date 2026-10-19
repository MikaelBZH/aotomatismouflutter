import 'pages/home_page.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Class constructor

  @override
  Widget build(BuildContext context) {
    return MaterialApp( // Structure générale de l'application
      debugShowCheckedModeBanner: false,
      title: 'Aotomatismoù',

      theme: ThemeData(
        fontFamily: 'Andika',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 48),
          bodyMedium: TextStyle(fontSize: 24),
          titleLarge: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,),
        ),
      ),

      home: const HomePage(), // Première page vue en lançant l'application
    );
  }
}


