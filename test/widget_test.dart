// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('login opens the fitness dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(
      find.byKey(const ValueKey('login-background-image')),
      findsOneWidget,
    );
    expect(find.text('FITORA'), findsOneWidget);
    expect(find.text('LOGIN'), findsOneWidget);

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'athlete@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.ensureVisible(find.text('LOGIN'));
    await tester.tap(find.text('LOGIN'));
    await tester.pumpAndSettle();

    expect(find.text('fitora dashboard'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byKey(const ValueKey('home-background-image')), findsOneWidget);

    await tester.tap(find.text('Start workout'));
    await tester.pumpAndSettle();
    expect(find.text('Quick Full-Body Workout'), findsOneWidget);
    expect(find.text('Bodyweight squats'), findsOneWidget);
    expect(
      find.text('Choose 3 exercises to start (0/3 selected)'),
      findsOneWidget,
    );
    expect(find.text('Start workout'), findsNothing);
    for (var index = 0; index < 3; index++) {
      final exercise = find.byType(Checkbox).at(index);
      await tester.ensureVisible(exercise);
      await tester.tap(exercise);
      await tester.pumpAndSettle();
    }
    expect(find.text('Start workout'), findsOneWidget);
    await tester.tap(find.text('Start workout'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Bodyweight squats'));
    expect(find.text('3 sets · 10 reps'), findsOneWidget);
    await tester.tap(find.byType(CheckboxListTile).first);
    await tester.pumpAndSettle();
    expect(find.text('1 of 3 exercises complete'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    final drawer = find.byType(Drawer);
    expect(
      find.descendant(of: drawer, matching: find.text('Workouts')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: drawer, matching: find.text('Services')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: drawer, matching: find.text('Progress')),
      findsOneWidget,
    );

    await tester.tap(
      find.descendant(of: drawer, matching: find.text('Workouts')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Workout programs'), findsOneWidget);
    expect(find.text('Fitora services'), findsNothing);
    expect(find.text('Products from the API'), findsNothing);
    await tester.tap(find.text('Services'));
    await tester.pumpAndSettle();

    expect(find.text('Fitora services'), findsOneWidget);
    expect(find.text('Workout programs'), findsNothing);
    expect(find.text('Products from the API'), findsNothing);
    expect(find.byType(TextField), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Mobility');
    await tester.scrollUntilVisible(
      find.text('Mobility Reset'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Mobility Reset'), findsOneWidget);
    expect(find.text('Strength Coaching'), findsNothing);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('API Product Catalog'));
    await tester.pumpAndSettle();

    expect(find.text('Product Catalog'), findsOneWidget);
    expect(find.textContaining('Could not load products.'), findsOneWidget);
  });
}
