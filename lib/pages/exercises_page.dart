import 'package:flutter/material.dart';
import '../widgets/menu.dart';
import '../models/exercises.dart';

typedef ExerciseGenerator = Exercise? Function(Set<String> selectedOptions);

class ExercisesPage extends StatefulWidget {
  final String title;
  final List<ExerciseOptions> options;
  final ExerciseGenerator generateExercise;

  const ExercisesPage({
    super.key,
    required this.title,
    required this.options,
    required this.generateExercise,
  });

  @override
  State<ExercisesPage> createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {

  bool displayAnswer = false; // Permet de savoir si la deuxième zone de texte doit être affichée.

  late final Set<String> selectedOptions;
  Exercise? exercise;

  @override
  void initState() {
    super.initState();

    selectedOptions = widget.options.map((option) => option.id).toSet();
    exercise = widget.generateExercise(selectedOptions);
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
              ...widget.options.map((option) {
                return SwitchListTile(
                  title: Text(option.label),
                  value: selectedOptions.contains(option.id),
                  onChanged: (isSelected) {
                    setState(() {
                      if (isSelected) {
                        selectedOptions.add(option.id);
                      } else {
                        selectedOptions.remove(option.id);
                      }
                      exercise = widget.generateExercise(selectedOptions);
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
                // exercise?.question : question générée si numbers != null
                // ?? Si numbers est null, alors question générée
                exercise?.question ?? 'Dibab un oberiadenn d\'an nebeutañ',
                style: exercise == null
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
                        exercise = widget.generateExercise(selectedOptions);
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
            if (displayAnswer && exercise != null)
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
                  '${exercise!.answer}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
          ], // Ending children in Column
        ),
      ),
    );
  }
}
