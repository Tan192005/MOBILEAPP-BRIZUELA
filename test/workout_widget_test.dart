import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/screens/dashboard_page.dart';

void main() {
  testWidgets('a workout card opens its illustrated, guided session', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: DashboardPage()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Workouts'));
    await tester.pumpAndSettle();

    final workoutCard = find.byKey(const ValueKey('workout-card-w1'));
    expect(find.text('Workout programs'), findsOneWidget);
    expect(find.text('Full Body Foundations'), findsOneWidget);
    expect(find.text('Fitora services'), findsNothing);
    expect(find.text('Products from the API'), findsNothing);
    expect(
      find.descendant(of: workoutCard, matching: find.byType(Image)),
      findsOneWidget,
    );

    final startWorkoutButton = find.descendant(
      of: workoutCard,
      matching: find.text('Start workout'),
    );
    final workoutScrollView = find
        .ancestor(of: workoutCard, matching: find.byType(Scrollable))
        .first;
    await tester.drag(workoutScrollView, const Offset(0, -360));
    await tester.pumpAndSettle();
    await tester.tap(startWorkoutButton);
    await tester.pumpAndSettle();

    expect(
      find.text('Choose 3 exercises to start (0/3 selected)'),
      findsOneWidget,
    );
    expect(find.text('Select 3 exercises to start'), findsOneWidget);
    for (var index = 0; index < 3; index++) {
      final exercise = find.byType(Checkbox).at(index);
      await tester.ensureVisible(exercise);
      await tester.tap(exercise);
      await tester.pumpAndSettle();
    }
    expect(find.text('Start workout'), findsOneWidget);
    await tester.tap(find.text('Start workout'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Goblet Squats'));
    expect(find.text('Goblet Squats'), findsOneWidget);
    expect(find.text('3 sets · 10-12'), findsWidgets);
    expect(find.textContaining('Quads, Glutes'), findsOneWidget);
    expect(find.textContaining('Rest: 60 seconds'), findsWidgets);
  });
}
