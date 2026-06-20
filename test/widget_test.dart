import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:dni_test_gen/main.dart';

void main() {
  group('Feature 01: Base Application Tests', () {
    testWidgets('App renders correctly with title and button', (WidgetTester tester) async {
      await tester.pumpWidget(const DniGeneratorApp());

      // Verificar la existencia del texto "Generador de DNI".
      expect(find.text('Generador de DNI'), findsOneWidget); // AppBar title

      // Verificar la existencia del botón "Generar".
      expect(find.widgetWithText(ElevatedButton, 'Generar'), findsOneWidget);

      // Verificar el placeholder visual
      expect(find.text('Aquí se mostrará el código generado'), findsOneWidget);
    });

    testWidgets('Tapping the generate button does not throw errors', (WidgetTester tester) async {
      await tester.pumpWidget(const DniGeneratorApp());

      final button = find.widgetWithText(ElevatedButton, 'Generar');
      expect(button, findsOneWidget);

      // Simular el tap en el botón "Generar" y asegurar que no produzca errores.
      await tester.tap(button);
      await tester.pump();
      
      // Si llegamos aquí sin excepciones, la prueba pasa.
      expect(true, isTrue);
    });

    test('AppState initializes correctly', () {
      final state = AppState();
      
      // Prueba unitaria simple de estado base
      expect(state, isNotNull);
      
      // generate() no debería lanzar errores
      state.generate();
    });
  });
}
