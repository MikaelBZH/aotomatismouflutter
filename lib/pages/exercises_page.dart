import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import '../widgets/menu.dart';
import '../models/exercises.dart';

class ExercisesPage extends StatefulWidget {
  final ExerciseModule module;

  const ExercisesPage({
    super.key,
    required this.module,
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

    selectedOptions = widget.module.options.map((option) => option.id).toSet();
    exercise = widget.module.generateExercise(selectedOptions);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --------------------------------------------------
      // APP BAR
      // --------------------------------------------------
      appBar: AppBar(
        title: Column (
          mainAxisSize: MainAxisSize.min,
          children:[
            Text(
              'Aotomatismoù',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              widget.module.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        backgroundColor: Colors.orange[500],
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
            // SWITCHLIST
            // --------------------------------------------------
            ExpansionTile(
              shape: const Border(),
              collapsedShape: const Border(),
              title: Text(
                'Dibaboù posupl :',
                style: TextStyle(fontSize: 16),
              ),
              children: [
                ...widget.module.options.map((option) {
                    return ListTile(
                      dense: true,
                     title: Text(
                        option.label,
                        style: TextStyle(fontSize: 14),
                     ),
                      trailing: Transform.scale(
                        scale: 0.7,
                        child: Switch(
                          value: selectedOptions.contains(option.id),
                          onChanged: (isSelected) {
                            setState(() {
                              if (isSelected) {
                                selectedOptions.add(option.id);
                              } else {
                                selectedOptions.remove(option.id);
                              }
                              exercise = widget.module.generateExercise(selectedOptions);
                              displayAnswer = false;
                            }); // setState
                          }, // onChanged
                        ),
                    ),
                  );
                }),
              ],
            ),

            // --------------------------------------------------
            // QUESTION ZONE
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

              child: exercise == null
                ? Text("Dibab un oberiadenn d'an nebeutañ")
                : Math2SVG(math: exercise!.question),
            ),

            const SizedBox(height: 16), // Espace vertical

            // --------------------------------------------------
            // THE BUTTONS
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
                        exercise = widget.module.generateExercise(selectedOptions);
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
            // ANSWER ZONE
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
                child: Math2SVG(math: exercise!.answer),
              ),
          ], // Ending children in Column
        ),
      ),
    );
  }
}
