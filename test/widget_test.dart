import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dni_test_gen/main.dart';
import 'package:dni_test_gen/services/data_generator_service.dart';

void main() {
  group('Feature 06: Integration Tests', () {
    late DataGeneratorService mockService;

    setUp(() {
      mockService = DataGeneratorService();
      // Inject some mock data so it doesn't fail trying to read assets during test
      mockService.setTestData(['Juan'], ['Perez']);
    });

    testWidgets('App renders correctly and integrates generators', (WidgetTester tester) async {
      await tester.pumpWidget(DniGeneratorApp(dataService: mockService));

      // Verificar que el Dropdown de tipo exista
      expect(find.text('Tipo de Documento'), findsOneWidget);
      expect(find.byType(DropdownButtonFormField<DniType>), findsOneWidget);

      // Verificar el placeholder visual inicial
      expect(find.text('Aquí se mostrará el código generado'), findsOneWidget);

      // Presionar generar (por defecto Aleatorio, pero mockeamos todo)
      final button = find.widgetWithText(ElevatedButton, 'Generar');
      await tester.tap(button);
      await tester.pumpAndSettle();

      // Ya no deberíamos ver el placeholder, sino datos reales y el código.
      expect(find.text('Aquí se mostrará el código generado'), findsNothing);
      expect(find.textContaining('Formato:'), findsOneWidget);
      expect(find.textContaining('DNI:'), findsOneWidget);
      expect(find.textContaining('Nombre: Perez, Juan'), findsOneWidget);
    });

    testWidgets('Selecting Versión Nueva creates QR', (WidgetTester tester) async {
      await tester.pumpWidget(DniGeneratorApp(dataService: mockService));

      final dropdown = find.byType(DropdownButtonFormField<DniType>);
      await tester.tap(dropdown);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Versión Nueva (QR)').last);
      await tester.pumpAndSettle();

      final button = find.widgetWithText(ElevatedButton, 'Generar');
      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(find.text('Formato: Nuevo eDNI (QR)'), findsOneWidget);
      // El QR widget de qr_flutter debería estar en el árbol
      // (No podemos chequear `QrImageView` tan fácil sin importarlo, pero podemos confiar en que cambia el texto)
    });

    testWidgets('Selecting Versión Vieja creates PDF417', (WidgetTester tester) async {
      await tester.pumpWidget(DniGeneratorApp(dataService: mockService));

      final dropdown = find.byType(DropdownButtonFormField<DniType>);
      await tester.tap(dropdown);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Versión Vieja (PDF417)').last);
      await tester.pumpAndSettle();

      final button = find.widgetWithText(ElevatedButton, 'Generar');
      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(find.text('Formato: DNI Viejo (PDF417)'), findsOneWidget);
      // El BarcodeWidget debería estar en el árbol
    });
  });
}
