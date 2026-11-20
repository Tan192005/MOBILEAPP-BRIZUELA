import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/workout.dart';

class WorkoutApi {
  const WorkoutApi._();

  static Future<List<Workout>> loadWorkouts() async {
    final response = await rootBundle.loadString('assets/workouts.json');
    final decoded = jsonDecode(response);
    if (decoded is! List) {
      throw const FormatException('Workout catalog must be a JSON list.');
    }
    return decoded.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('Workout catalog entries must be objects.');
      }
      return Workout.fromJson(item);
    }).toList();
  }
}
