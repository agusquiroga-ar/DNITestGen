import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:dni_test_gen/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('E2E App Tests', () {
    testWidgets('Generate random identity flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify the generate button exists
      expect(find.text('Generar'), findsOneWidget);

      // Verify placeholder text is shown initially
      expect(find.text('Aquí se mostrará el código generado'), findsOneWidget);

      // Tap the generate button
      await tester.tap(find.text('Generar'));
      await tester.pumpAndSettle();

      // Check if DNI information appeared instead of placeholder
      expect(find.textContaining('DNI:'), findsWidgets);
      expect(find.text('Aquí se mostrará el código generado'), findsNothing);
      
      // Since it's random, we check if one of the formats is printed
      expect(find.byWidgetPredicate((widget) {
        if (widget is Text && widget.data != null) {
          return widget.data!.startsWith('Formato:');
        }
        return false;
      }), findsOneWidget);
    });
  });
}
