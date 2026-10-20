import '../models/exercises.dart';
import 'exercises_types/calculations.dart';
import 'exercises_types/fractions.dart';

const exerciseCategories = <ExerciseCategory>[
  ExerciseCategory(
    id: 'Niv',
    title: 'Niveroù ha jedadennoù',
  ),
  ExerciseCategory(
    id: 'Spas',
    title: 'Spas ha mentoniezh',
  ),
  ExerciseCategory(
    id: 'Road',
    title: 'Merañ roadennoù',
  ),
  ExerciseCategory(
    id: 'Ment',
    title: 'Mentadoù ha muzulioù',
  ),
];


final exerciseCatalog = <ExerciseModule>[
  ExerciseModule(
    id: 'calculations',
    categoryId: 'Niv',
    title: 'Jedadennoù gant niveroù anterin',
    options: calculationOptions,
    generateExercise: randomCalculation,
  ),
  ExerciseModule(
    id: 'fractions',
    categoryId: 'Niv',
    title: 'Jedadennoù gant kevrennoù',
    options: fractionOptions,
    generateExercise: randomCalculation,
  ),
];