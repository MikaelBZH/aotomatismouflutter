import 'package:flutter/material.dart';
import '../widgets/menu.dart';
import '../exercises/calculations.dart';

class ExercisesPage extends StatefulWidget {
  const ExercisesPage({super.key});

  @override
  State<ExercisesPage> createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {

  bool displayAnswer = false; // Permet de savoir si la deuxième zone de texte doit être affichée.

  final Set<CalculationType> selectedTypes = {
    CalculationType.sum,
    CalculationType.subtract,
    CalculationType.multiply,
    CalculationType.divide,
  };

  CalculationExercise? numbers;

  @override
  void initState() {
    super.initState();
    numbers = randomCalculation(selectedTypes)! ; // ! garantira que numbers ne sera jamais null
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --------------------------------------------------
      // APP BAR
      // --------------------------------------------------
      appBar: AppBar(
        title: Text(
          'Aotomatismoù',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        backgroundColor: Colors.orange[700],
        centerTitle: true,
      ),

      drawer: const Menu(),

      // --------------------------------------------------
      // BODY
      // --------------------------------------------------
      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          children: [

            // --------------------------------------------------
            // CASES A COCHER
            // --------------------------------------------------
            if (choice)
              ...CalculationType.values.map((type) {
                return CheckboxListTile(
                  title: Text(switch (type) {
                    CalculationType.sum => 'Sammañ',
                    CalculationType.subtract => 'Lemel',
                    CalculationType.multiply => 'Liesaat',
                    CalculationType.divide => 'Rannañ',
                  }),
                  value: selectedTypes.contains(type),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (isChecked) {
                    setState(() {
                      if (isChecked == true) {
                        selectedTypes.add(type);
                      } else {
                        selectedTypes.remove(type);
                      }
                      numbers = randomCalculation(selectedTypes);
                      displayAnswer = false;
                    });
                  },
                );
              }),

            // --------------------------------------------------
            // PREMIÈRE ZONE DE TEXTE
            // --------------------------------------------------
            Container(
              width: double.infinity, // toute la largeur disponible
              height: 200,
              padding: const EdgeInsets.all(12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  left: const BorderSide(
                    width: 12,
                    color: Colors.blueAccent,
                  ),
                  top: BorderSide(
                    width: 4,
                    color: Colors.blueAccent,
                  ),
                  right: BorderSide(
                    width: 4,
                    color: Colors.blueAccent,
                  ),
                  bottom: BorderSide(
                    width: 4,
                    color: Colors.blueAccent,
                  ),
                ),
                borderRadius: BorderRadius.circular(16),
              ),

              child: Text(
                // numbers?.question : question générée si numbers != null
                // ?? Si numbers est null, alors question générée
                numbers?.question ?? 'Dibab un oberiadenn d\'an nebeutañ',
                style: numbers == null
                  ? Theme.of(context).textTheme.bodyMedium
                  : Theme.of(context).textTheme.titleLarge,
              ),
            ),

            const SizedBox(height: 16), // Espace vertical

            // --------------------------------------------------
            // LES DEUX BOUTONS
            // --------------------------------------------------
            Row(
              children: [

                // Premier bouton
                Expanded( // Prendre la place disponible
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() { // Changement de l'état de la page et reconstruction de l'interface
                        displayAnswer = !displayAnswer;
                      });
                    },
                    child: Text(
                      displayAnswer ? 'Kuzhaat ar respont' : 'Diskouez ar respont',
                    ),
                  ),
                ),

                const SizedBox(width: 12), // Espace horizontal entre les deux boutons

                // Deuxième bouton
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        numbers = randomCalculation(selectedTypes);
                        displayAnswer = false;
                      });
                    },
                    child: const Text('Nevez'),
                  ),
                ),
              ], // Ending children in Row
            ),

            const SizedBox(height: 16),

            // --------------------------------------------------
            // DEUXIÈME ZONE DE TEXTE
            // --------------------------------------------------
            if (displayAnswer && numbers != null)
              Container(
                width: double.infinity,
                height: 200,
                padding: const EdgeInsets.all(12),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    left: const BorderSide(
                      width: 12,
                      color: Colors.green,
                    ),
                    top: BorderSide(
                      width: 4,
                      color: Colors.green,
                    ),
                    right: BorderSide(
                      width: 4,
                      color: Colors.green,
                    ),
                    bottom: BorderSide(
                      width: 4,
                      color: Colors.green,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${numbers!.answer}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
          ], // Ending children in Column
        ),
      ),
    );
  }
}
