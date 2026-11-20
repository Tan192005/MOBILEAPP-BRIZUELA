import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/services/progress_service.dart';
import 'package:flutter_application_1/screens/dashboard_page.dart';

class _FakeProgressService implements ProgressService {
  final List<WorkoutProgress> records = [];

  @override
  Stream<List<WorkoutProgress>> watchRecords() =>
      Stream.value(List.unmodifiable(records));

  @override
  Future<void> createRecord({
    required String title,
    required int durationMinutes,
  }) async {
    records.add(
      WorkoutProgress(
        id: '${records.length}',
        title: title,
        durationMinutes: durationMinutes,
        completedAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> updateRecord(String id, {required int durationMinutes}) async {}

  @override
  Future<void> deleteRecord(String id) async {}
}

void main() {
  testWidgets('selects three workouts and completes them manually', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final progressService = _FakeProgressService();
    await tester.pumpWidget(
      MaterialApp(home: DashboardPage(progressService: progressService)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Workouts'));
    await tester.pumpAndSettle();

    expect(
      find.text('Choose 3 workouts, then mark each one complete yourself.'),
      findsOneWidget,
    );

    for (final id in ['fitora-strength-20', 'fitora-mobility-10', 'quick']) {
      final card = find.byKey(ValueKey('workout-card-$id'));
      final selectButton = find.descendant(
        of: card,
        matching: find.text('Select workout'),
      );
      await tester.ensureVisible(selectButton);
      await tester.tap(selectButton);
      await tester.pumpAndSettle();
    }

    final startButton = find.byKey(const ValueKey('start-selected-workouts'));
    expect(find.text('Start selected workouts'), findsOneWidget);
    await tester.tap(startButton);
    await tester.pumpAndSettle();

    expect(find.text('Your 3 workouts'), findsOneWidget);
    expect(find.text('0 of 3 workouts complete'), findsOneWidget);

    for (final id in ['fitora-strength-20', 'fitora-mobility-10']) {
      final checkbox = find.byKey(ValueKey('complete-workout-$id'));
      await tester.ensureVisible(checkbox);
      await tester.tap(checkbox);
      await tester.pumpAndSettle();
    }

    final finishButton = tester.widget<FilledButton>(
      find.byKey(const ValueKey('finish-workout-plan')),
    );
    expect(finishButton.onPressed, isNull);
    expect(find.text('2 of 3 workouts complete'), findsOneWidget);

    final lastWorkout = find.byKey(const ValueKey('complete-workout-quick'));
    await tester.ensureVisible(lastWorkout);
    await tester.tap(lastWorkout);
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<FilledButton>(
            find.byKey(const ValueKey('finish-workout-plan')),
          )
          .onPressed,
      isNotNull,
    );
    expect(find.text('3 of 3 workouts complete'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('finish-workout-plan')));
    await tester.pumpAndSettle();
    expect(progressService.records, hasLength(3));

    await tester.tap(find.text('Progress'));
    await tester.pumpAndSettle();
    expect(find.text('20-Minute Strength'), findsOneWidget);
    expect(find.text('10-Minute Mobility'), findsOneWidget);
    expect(find.text('Quick Full-Body Workout'), findsOneWidget);
  });
}
