import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_core/game_core.dart';

import 'support/test_app.dart';

void main() {
  testWidgets('app boots', (tester) async {
    await pumpGame(tester);

    expect(find.byType(MaterialApp), findsOneWidget);
  });

  test('game_core is linked into the client', () {
    // Guards the workspace wiring itself: if game_core ever stops resolving
    // from the client, this fails to compile rather than at runtime.
    expect(stateSchemaVersion, isPositive);
  });
}
