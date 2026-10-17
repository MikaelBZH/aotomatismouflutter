class Exercise {
  final String question;
  final String answer;
  final String? help;

  const Exercise ({
    required this.question,
    required this.answer,
    this.help,
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
