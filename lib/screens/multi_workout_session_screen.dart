import 'package:flutter/material.dart';

import '../models/workout.dart';

class MultiWorkoutSessionScreen extends StatefulWidget {
  const MultiWorkoutSessionScreen({super.key, required this.workouts});

  final List<Workout> workouts;

  @override
  State<MultiWorkoutSessionScreen> createState() =>
      _MultiWorkoutSessionScreenState();
}

class _MultiWorkoutSessionScreenState extends State<MultiWorkoutSessionScreen> {
  final Set<String> _completedWorkoutIds = {};

  @override
  Widget build(BuildContext context) {
    final completedCount = _completedWorkoutIds.length;
    final allComplete = completedCount == widget.workouts.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Your workout plan')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  'Your 3 workouts',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Complete each workout at your own pace, then check it off here.',
                ),
                const SizedBox(height: 16),
                Text(
                  '$completedCount of ${widget.workouts.length} workouts complete',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: widget.workouts.isEmpty
                      ? 0
                      : completedCount / widget.workouts.length,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(8),
                ),
                const SizedBox(height: 16),
                for (final workout in widget.workouts)
                  Card(
                    key: ValueKey('manual-workout-${workout.id}'),
                    clipBehavior: Clip.antiAlias,
                    child: CheckboxListTile(
                      key: ValueKey('complete-workout-${workout.id}'),
                      value: _completedWorkoutIds.contains(workout.id),
                      onChanged: (checked) {
                        setState(() {
                          if (checked == true) {
                            _completedWorkoutIds.add(workout.id);
                          } else {
                            _completedWorkoutIds.remove(workout.id);
                          }
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(
                        workout.title,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          '${workout.durationMinutes} min · '
                          '${workout.difficulty} · '
                          '${workout.exercises.length} exercises',
                        ),
                      ),
                      secondary: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          workout.image,
                          width: 52,
                          height: 52,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const SizedBox(
                            width: 52,
                            height: 52,
                            child: Icon(Icons.fitness_center_rounded),
                          ),
                        ),
                      ),
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
                key: const ValueKey('finish-workout-plan'),
                onPressed: allComplete
                    ? () => Navigator.of(context).pop(true)
                    : null,
                child: Text(
                  allComplete
                      ? 'Finish and save to history'
                      : 'Manually complete all ${widget.workouts.length} workouts',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
