class Exercise {
  final String question;
  final String answer;
  final String? help;
  final String? details;

  const Exercise ({
    required this.question,
    required this.answer,
    this.help,
    this.details,
});
}

class ExerciseOptions {
  final String id;
  final String label;

  const ExerciseOptions ({
    required this.id,
    required this.label,
  });
}

typedef ExerciseGenerator = Exercise? Function(Set<String> selectedOptions);

class ExerciseCategory {
  final String id;
  final String title;

  const ExerciseCategory ({
    required this.id,
    required this.title,
  });
}

class ExerciseModule {
  final String id;
  final String categoryId;
  final String title;
  final List<ExerciseOptions> options;
  final ExerciseGenerator generateExercise;

  const ExerciseModule ({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.options,
    required this.generateExercise,
  });
}
