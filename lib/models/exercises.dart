class Exercises {
  final String question;
  final String answer;
  final String? help;

  const Exercises ({
    required this.question,
    required this.answer,
    required this.help,
});
}

class ExercisesOptions {
  final String id;
  final String label;

  const ExercisesOptions ({
    required this.id,
    required this.label,
  });
}
