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

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    expect(find.text('Workouts'), findsOneWidget);
    expect(find.text('Progress'), findsOneWidget);

    await tester.tap(find.text('Workouts'));
    await tester.pumpAndSettle();

    expect(find.text('Fitora services'), findsOneWidget);
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

    expect(find.text('FITORA'), findsOneWidget);
    expect(find.text('Couldn’t load the catalog'), findsOneWidget);
  });
}
