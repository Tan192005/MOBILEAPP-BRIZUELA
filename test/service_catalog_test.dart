import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('exercise catalog contains the new workout sessions', () async {
    final catalog =
        jsonDecode(
              await rootBundle.loadString('assets/data/fitora_services.json'),
            )
            as Map<String, dynamic>;
    final services = catalog['services'] as List<dynamic>;
    final names = services
        .map((service) => (service as Map<String, dynamic>)['name'])
        .toSet();

    expect(
      names,
      containsAll([
        'Upper Body Strength',
        'Lower Body Power',
        'Core Builder',
        'Cardio Endurance',
        'Full Body Circuit',
        'Post-Workout Stretch',
      ]),
    );

    for (final service in services.cast<Map<String, dynamic>>()) {
      expect(service['durationMinutes'], greaterThan(0));
      expect(service['icon'], isA<String>());
    }
  });
}
