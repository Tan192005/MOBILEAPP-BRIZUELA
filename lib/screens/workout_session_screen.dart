import 'package:flutter/material.dart';

import '../models/workout.dart';

class WorkoutSessionScreen extends StatefulWidget {
  const WorkoutSessionScreen({
    super.key,
    required this.workoutId,
    required this.title,
    required this.durationMinutes,
    required this.level,
    this.workout,
  });

  final String workoutId;
  final String title;
  final int durationMinutes;
  final String level;
  final Workout? workout;

  @override
  State<WorkoutSessionScreen> createState() => _WorkoutSessionScreenState();
}

class _WorkoutExercise {
  const _WorkoutExercise({
    required this.name,
    required this.target,
    required this.instruction,
  });

  final String name;
  final String target;
  final String instruction;
}

class _WorkoutSessionScreenState extends State<WorkoutSessionScreen> {
  int get _selectionLimit => _exercises.length < 3 ? _exercises.length : 3;

  static const _routines = <String, List<_WorkoutExercise>>{
    'quick': [
      _WorkoutExercise(
        name: 'Bodyweight squats',
        target: '3 sets · 10 reps',
        instruction:
            'Sit your hips back and keep your knees in line with your toes.',
      ),
      _WorkoutExercise(
        name: 'Incline push-ups',
        target: '3 sets · 8 reps',
        instruction:
            'Use a sturdy counter or wall and keep your body in a straight line.',
      ),
      _WorkoutExercise(
        name: 'Glute bridges',
        target: '3 sets · 12 reps',
        instruction:
            'Press through your feet and gently squeeze your glutes at the top.',
      ),
      _WorkoutExercise(
        name: 'Bird dogs',
        target: '2 sets · 8 each side',
        instruction:
            'Reach opposite arm and leg while keeping your back steady.',
      ),
      _WorkoutExercise(
        name: 'March in place',
        target: '2 sets · 30 seconds',
        instruction:
            'March at a comfortable pace and use a wall for balance if needed.',
      ),
    ],
    'fitora-strength-20': [
      _WorkoutExercise(
        name: 'Bodyweight squats',
        target: '3 sets · 10 reps',
        instruction:
            'Sit your hips back and keep your knees in line with your toes.',
      ),
      _WorkoutExercise(
        name: 'Incline push-ups',
        target: '3 sets · 8 reps',
        instruction:
            'Use a sturdy counter or wall and keep your body in a straight line.',
      ),
      _WorkoutExercise(
        name: 'Glute bridges',
        target: '3 sets · 12 reps',
        instruction:
            'Press through your feet and gently squeeze your glutes at the top.',
      ),
      _WorkoutExercise(
        name: 'Backpack rows',
        target: '3 sets · 10 reps',
        instruction:
            'Use a lightly loaded backpack; pull it toward your ribs with a flat back.',
      ),
    ],
    'fitora-mobility-10': [
      _WorkoutExercise(
        name: 'Cat-cow',
        target: '2 sets · 8 slow reps',
        instruction:
            'On hands and knees, gently round and extend your back with your breath.',
      ),
      _WorkoutExercise(
        name: 'Half-kneeling hip stretch',
        target: '2 sets · 20 seconds each side',
        instruction:
            'Kneel on a cushion and shift forward slightly without arching your back.',
      ),
      _WorkoutExercise(
        name: 'Open-book rotations',
        target: '2 sets · 6 each side',
        instruction:
            'Lie on your side and slowly rotate your upper arm open as you exhale.',
      ),
      _WorkoutExercise(
        name: 'Child’s pose',
        target: '2 sets · 20 seconds',
        instruction:
            'Sit back toward your heels and reach forward only as far as comfortable.',
      ),
    ],
    'fitora-hiit-25': [
      _WorkoutExercise(
        name: 'Brisk march',
        target: '3 rounds · 30 seconds',
        instruction:
            'March in place at a pace where you can still stay in control.',
      ),
      _WorkoutExercise(
        name: 'Chair squats',
        target: '3 rounds · 30 seconds',
        instruction:
            'Tap a sturdy chair and stand back up; move at a comfortable pace.',
      ),
      _WorkoutExercise(
        name: 'Alternating step-backs',
        target: '3 rounds · 30 seconds',
        instruction: 'Step one foot back at a time instead of jumping.',
      ),
      _WorkoutExercise(
        name: 'Easy recovery march',
        target: '3 rounds · 30 seconds',
        instruction:
            'Slow down, breathe steadily, and rest whenever you need to.',
      ),
    ],
    'fitora-upper-body-20': [
      _WorkoutExercise(
        name: 'Incline push-ups',
        target: '3 sets · 8 reps',
        instruction:
            'Use a sturdy counter or wall and keep your body in a straight line.',
      ),
      _WorkoutExercise(
        name: 'Backpack rows',
        target: '3 sets · 10 reps',
        instruction:
            'Use a lightly loaded backpack; pull it toward your ribs with a flat back.',
      ),
      _WorkoutExercise(
        name: 'Wall shoulder slides',
        target: '2 sets · 10 reps',
        instruction:
            'Slide your arms up a wall only through a comfortable range.',
      ),
      _WorkoutExercise(
        name: 'Wall push-ups',
        target: '2 sets · 10 reps',
        instruction: 'Stand close to a wall and bend your elbows slowly.',
      ),
    ],
    'fitora-lower-body-20': [
      _WorkoutExercise(
        name: 'Chair squats',
        target: '3 sets · 10 reps',
        instruction: 'Tap a sturdy chair and stand back up with control.',
      ),
      _WorkoutExercise(
        name: 'Reverse step-backs',
        target: '3 sets · 8 each side',
        instruction:
            'Step back a short distance and hold a wall for balance if needed.',
      ),
      _WorkoutExercise(
        name: 'Glute bridges',
        target: '3 sets · 12 reps',
        instruction:
            'Press through your feet and gently squeeze your glutes at the top.',
      ),
      _WorkoutExercise(
        name: 'Calf raises',
        target: '2 sets · 12 reps',
        instruction: 'Hold a stable surface and rise onto your toes slowly.',
      ),
    ],
    'fitora-core-15': [
      _WorkoutExercise(
        name: 'Dead bugs',
        target: '3 sets · 8 each side',
        instruction:
            'On your back, lower opposite arm and leg while keeping your back comfortable.',
      ),
      _WorkoutExercise(
        name: 'Bird dogs',
        target: '3 sets · 8 each side',
        instruction:
            'Reach opposite arm and leg while keeping your back steady.',
      ),
      _WorkoutExercise(
        name: 'Knee plank',
        target: '3 sets · 20 seconds',
        instruction:
            'Keep a straight line from shoulders to knees; stop if your back feels strained.',
      ),
      _WorkoutExercise(
        name: 'Standing knee drives',
        target: '2 sets · 10 each side',
        instruction:
            'Stand tall and bring one knee up at a time at a controlled pace.',
      ),
    ],
    'fitora-cardio-20': [
      _WorkoutExercise(
        name: 'Brisk march',
        target: '3 sets · 45 seconds',
        instruction: 'March in place and let your arms swing naturally.',
      ),
      _WorkoutExercise(
        name: 'Step jacks',
        target: '3 sets · 30 seconds',
        instruction:
            'Step one foot out at a time while raising your arms comfortably.',
      ),
      _WorkoutExercise(
        name: 'Alternating step-backs',
        target: '3 sets · 30 seconds',
        instruction: 'Step one foot back at a time instead of jumping.',
      ),
      _WorkoutExercise(
        name: 'Easy recovery march',
        target: '3 sets · 30 seconds',
        instruction:
            'Slow down, breathe steadily, and rest whenever you need to.',
      ),
    ],
    'fitora-full-body-30': [
      _WorkoutExercise(
        name: 'Bodyweight squats',
        target: '3 sets · 10 reps',
        instruction:
            'Sit your hips back and keep your knees in line with your toes.',
      ),
      _WorkoutExercise(
        name: 'Incline push-ups',
        target: '3 sets · 8 reps',
        instruction:
            'Use a sturdy counter or wall and keep your body in a straight line.',
      ),
      _WorkoutExercise(
        name: 'Glute bridges',
        target: '3 sets · 12 reps',
        instruction:
            'Press through your feet and gently squeeze your glutes at the top.',
      ),
      _WorkoutExercise(
        name: 'Backpack rows',
        target: '3 sets · 10 reps',
        instruction:
            'Use a lightly loaded backpack; pull it toward your ribs with a flat back.',
      ),
      _WorkoutExercise(
        name: 'Standing march',
        target: '2 sets · 30 seconds',
        instruction:
            'Finish at a steady, comfortable pace and cool down if needed.',
      ),
    ],
    'fitora-stretch-12': [
      _WorkoutExercise(
        name: 'Hamstring stretch',
        target: '2 sets · 20 seconds each side',
        instruction: 'Sit tall and lean forward gently with one leg extended.',
      ),
      _WorkoutExercise(
        name: 'Standing quad stretch',
        target: '2 sets · 20 seconds each side',
        instruction:
            'Hold a stable surface and bring your heel toward your seat gently.',
      ),
      _WorkoutExercise(
        name: 'Chest doorway stretch',
        target: '2 sets · 20 seconds',
        instruction:
            'Rest your forearm on a doorway and turn away slightly without forcing it.',
      ),
      _WorkoutExercise(
        name: 'Shoulder stretch',
        target: '2 sets · 20 seconds each side',
        instruction: 'Bring one arm across your chest and hold it gently.',
      ),
    ],
  };

  final Set<int> _selectedExercises = {};
  final Set<int> _completedExercises = {};
  bool _isStarted = false;

  List<_WorkoutExercise> get _exercises {
    final workout = widget.workout;
    if (workout != null) {
      return workout.exercises
          .map(
            (exercise) => _WorkoutExercise(
              name: exercise.name,
              target:
                  '${exercise.sets} ${exercise.sets == 1 ? 'set' : 'sets'} · ${exercise.reps}',
              instruction:
                  'Target: ${exercise.targetMuscle} · Rest: ${exercise.rest}',
            ),
          )
          .toList();
    }
    return _routines[widget.workoutId] ?? _routines['quick']!;
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = _completedExercises.length;
    final visibleExerciseIndices = _isStarted
        ? (_selectedExercises.toList()..sort())
        : List<int>.generate(_exercises.length, (index) => index);
    final allComplete =
        _isStarted &&
        _selectedExercises.isNotEmpty &&
        completedCount == _selectedExercises.length;
    final noExercises = _exercises.isEmpty;
    final selectionLimit = _selectionLimit;
    final couldStartWorkout =
        !noExercises && _selectedExercises.length == selectionLimit;

    return Scaffold(
      appBar: AppBar(title: const Text('Workout session')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                if (widget.workout case final workout?) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      workout.image,
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${widget.durationMinutes} min  ·  ${widget.level}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                if (noExercises)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text('No exercises are available for this workout.'),
                  )
                else
                  Text(
                    _isStarted
                        ? '$completedCount of ${_selectedExercises.length} exercises complete'
                        : 'Choose ${_selectionLimit == 1 ? '1 exercise' : '$_selectionLimit exercises'} to start (${_selectedExercises.length}/$_selectionLimit selected)',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                if (_isStarted && _selectedExercises.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: _selectedExercises.isEmpty
                        ? 0
                        : completedCount / _selectedExercises.length,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ],
                if (!noExercises) const SizedBox(height: 20),
                if (!noExercises)
                  for (final index in visibleExerciseIndices)
                    Card(
                      child: CheckboxListTile(
                        value: _isStarted
                            ? _completedExercises.contains(index)
                            : _selectedExercises.contains(index),
                        onChanged:
                            !_isStarted &&
                                !_selectedExercises.contains(index) &&
                                _selectedExercises.length == selectionLimit
                            ? null
                            : (checked) {
                                setState(() {
                                  if (checked == true) {
                                    if (_isStarted) {
                                      _completedExercises.add(index);
                                    } else if (_selectedExercises.length <
                                        selectionLimit) {
                                      _selectedExercises.add(index);
                                    }
                                  } else {
                                    if (_isStarted) {
                                      _completedExercises.remove(index);
                                    } else {
                                      _selectedExercises.remove(index);
                                    }
                                  }
                                });
                              },
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(
                          _exercises[index].name,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _exercises[index].target,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(_exercises[index].instruction),
                            ],
                          ),
                        ),
                        isThreeLine: true,
                      ),
                    ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            minimum: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isStarted
                    ? (allComplete
                          ? () => Navigator.of(context).pop(true)
                          : null)
                    : (couldStartWorkout
                          ? () => setState(() => _isStarted = true)
                          : null),
                child: Text(
                  _isStarted
                      ? (allComplete
                            ? 'Finish workout'
                            : 'Complete all exercises to finish')
                      : (couldStartWorkout
                            ? 'Start workout'
                            : 'Select ${selectionLimit == 1 ? '1 exercise' : '$selectionLimit exercises'} to start'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
