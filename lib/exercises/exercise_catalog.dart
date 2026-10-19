import '../models/exercises.dart';
import 'exercises_types/calculations.dart';

final exerciseCatalog = <ExerciseModule>[
  ExerciseModule(
    id: 'calculations',
    categoryId: 'Niveroù ha jedadennoù',
    title: 'Jedadennoù gant niveroù anterin',
    options: calculationOptions,
    generateExercise: randomCalculation,
  ),
];