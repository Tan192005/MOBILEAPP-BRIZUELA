import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/models/workout.dart';
import 'package:flutter_application_1/services/workout_api.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'loads all five workouts, their exercises, and their cover images',
    () async {
      final workouts = await WorkoutApi.loadWorkouts();

      expect(workouts, hasLength(5));
      expect(
        workouts.map((workout) => workout.title),
        containsAll([
          'Full Body Foundations',
          'Upper Body Power',
          'Lower Body & Core',
          'Push Focus (Chest, Shoulders, Triceps)',
          'Pull Focus (Back & Biceps)',
        ]),
      );

      for (final workout in workouts) {
        expect(workout.durationMinutes, greaterThan(0));
        expect(workout.exercises, isNotEmpty);
        expect(
          (await rootBundle.load(workout.image)).lengthInBytes,
          greaterThan(0),
        );
        for (final exercise in workout.exercises) {
          expect(exercise.sets, greaterThan(0));
          expect(exercise.reps, isNotEmpty);
          expect(exercise.targetMuscle, isNotEmpty);
          expect(exercise.rest, isNotEmpty);
        }
      }
    },
  );

  test('rejects invalid workout JSON types', () {
    expect(
      () => Workout.fromJson({
        'id': 'w1',
        'title': 'Invalid Workout',
        'category': 'Full Body',
        'durationMinutes': '45',
        'difficulty': 'Beginner',
        'image': 'assets/images/workouts/full_body_foundations.png',
        'exercises': [],
      }),
      throwsFormatException,
    );
  });

  test(
    'workout JSON remains a list of typed, image-backed workout models',
    () async {
      final decoded = jsonDecode(
        await rootBundle.loadString('assets/workouts.json'),
      );
      expect(decoded, isA<List<dynamic>>());
      expect((decoded as List<dynamic>).every((item) => item is Map), isTrue);
    },
  );
}
