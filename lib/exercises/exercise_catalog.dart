import '../models/exercises.dart';
import 'exercises_types/algebra.dart';
import 'exercises_types/calculations.dart';
import 'exercises_types/data_and_measurements.dart';
import 'exercises_types/fractions.dart';
import 'exercises_types/geometry.dart';

const exerciseCategories = <ExerciseCategory>[
  ExerciseCategory(id: 'Niv', title: 'Niveroù ha jedadennoù'),
  ExerciseCategory(id: 'Road', title: 'Merañ roadennoù'),
  ExerciseCategory(id: 'Ment', title: 'Mentadoù ha muzulioù'),
  ExerciseCategory(id: 'Spas', title: 'Spas ha mentoniezh'),
];

final exerciseCatalog = <ExerciseModule>[
  ExerciseModule(
    id: 'numberLine',
    categoryId: 'Niv',
    title: 'Daveañ war un eeunenn dereziet',
    options: numberLineOptions,
    generateExercise: randomNumberLine,
  ),
  ExerciseModule(
    id: 'expansion',
    categoryId: 'Niv',
    title: 'Dispakañ ha reduiñ',
    options: expansionOptions,
    generateExercise: randomExpansion,
  ),
  ExerciseModule(
    id: 'powers',
    categoryId: 'Niv',
    title: 'Galloudoù',
    options: powerOptions,
    generateExercise: randomPower,
  ),
  ExerciseModule(
    id: 'calculations',
    categoryId: 'Niv',
    title: 'Jedadennoù',
    options: calculationOptions,
    generateExercise: randomCalculation,
  ),
  ExerciseModule(
    id: 'squares',
    categoryId: 'Niv',
    title: 'Karrezioù ha gwrizhiennoù karrez peurvad',
    options: squareOptions,
    generateExercise: randomSquare,
  ),
  ExerciseModule(
    id: 'equations',
    categoryId: 'Niv',
    title: 'Kevatalennoù',
    options: equationOptions,
    generateExercise: randomEquation,
  ),
  ExerciseModule(
    id: 'fractions',
    categoryId: 'Niv',
    title: 'Kevrennoù',
    options: fractionOptions,
    generateExercise: randomFraction,
  ),
  ExerciseModule(
    id: 'divisibility',
    categoryId: 'Niv',
    title: 'Kriterioù rannuster',
    options: divisibilityOptions,
    generateExercise: randomDivisibility,
  ),
  ExerciseModule(
    id: 'scientificNotation',
    categoryId: 'Niv',
    title: 'Skrivad skiantel',
    options: scientificOptions,
    generateExercise: randomScientificNotation,
  ),
  ExerciseModule(
    id: 'expressions',
    categoryId: 'Niv',
    title: 'Talvoud un eztaol',
    options: expressionOptions,
    generateExercise: randomExpression,
  ),
  ExerciseModule(
    id: 'percentages',
    categoryId: 'Road',
    title: 'Dregantadoù',
    options: percentageOptions,
    generateExercise: randomPercentage,
  ),
  ExerciseModule(
    id: 'areas',
    categoryId: 'Ment',
    title: 'Gorreadoù',
    options: areaOptions,
    generateExercise: randomArea,
  ),
  ExerciseModule(
    id: 'conversions',
    categoryId: 'Ment',
    title: 'Troidigezhioù',
    options: conversionOptions,
    generateExercise: randomConversion,
  ),
  ExerciseModule(
    id: 'coordinates',
    categoryId: 'Spas',
    title: 'Daveañ war ar plaen',
    options: coordinateOptions,
    generateExercise: randomCoordinates,
  ),
  ExerciseModule(
    id: 'pythagoras',
    categoryId: 'Spas',
    title: 'Liammadur Pitagoras',
    options: pythagorasOptions,
    generateExercise: randomPythagoras,
  ),
  ExerciseModule(
    id: 'thales',
    categoryId: 'Spas',
    title: 'Perzh Thales',
    options: thalesOptions,
    generateExercise: randomThales,
  ),
  ExerciseModule(
    id: 'trigonometry',
    categoryId: 'Spas',
    title: 'Trigonometriezh',
    options: trigonometryOptions,
    generateExercise: randomTrigonometry,
  ),
];

