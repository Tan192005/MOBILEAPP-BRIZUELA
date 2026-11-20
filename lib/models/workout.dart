class Exercise {
  const Exercise({
    required this.name,
    required this.sets,
    required this.reps,
    required this.targetMuscle,
    required this.rest,
  });

  final String name;
  final int sets;
  final String reps;
  final String targetMuscle;
  final String rest;

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: _requiredString(json, 'name'),
      sets: _requiredInt(json, 'sets'),
      reps: _requiredString(json, 'reps'),
      targetMuscle: _requiredString(json, 'targetMuscle'),
      rest: _requiredString(json, 'rest'),
    );
  }
}

class Workout {
  const Workout({
    required this.id,
    required this.title,
    required this.category,
    required this.durationMinutes,
    required this.difficulty,
    required this.image,
    required this.exercises,
  });

  final String id;
  final String title;
  final String category;
  final int durationMinutes;
  final String difficulty;
  final String image;
  final List<Exercise> exercises;

  factory Workout.fromJson(Map<String, dynamic> json) {
    final exerciseData = json['exercises'];
    if (exerciseData is! List) {
      throw const FormatException('Workout exercises must be a list.');
    }

    return Workout(
      id: _requiredString(json, 'id'),
      title: _requiredString(json, 'title'),
      category: _requiredString(json, 'category'),
      durationMinutes: _requiredInt(json, 'durationMinutes'),
      difficulty: _requiredString(json, 'difficulty'),
      image: _requiredString(json, 'image'),
      exercises: exerciseData.map((item) {
        if (item is! Map<String, dynamic>) {
          throw const FormatException('Workout exercises must be objects.');
        }
        return Exercise.fromJson(item);
      }).toList(),
    );
  }
}

String _requiredString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! String || value.trim().isEmpty) {
    throw FormatException('Expected a non-empty string for "$key".');
  }
  return value;
}

int _requiredInt(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! int || value <= 0) {
    throw FormatException('Expected a positive integer for "$key".');
  }
  return value;
}
