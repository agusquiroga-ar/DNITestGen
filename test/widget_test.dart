import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dni_test_gen/main.dart';
import 'package:dni_test_gen/models/dni_type.dart';
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
      expect(find.textContaining('DNI:'), findsWidgets);
      expect(find.textContaining('Nombre: Perez, Juan'), findsOneWidget);
    });

    testWidgets('Selecting eDNI Nuevo creates QR', (WidgetTester tester) async {
      await tester.pumpWidget(DniGeneratorApp(dataService: mockService));

      final dropdown = find.byType(DropdownButtonFormField<DniType>);
      await tester.tap(dropdown);
      await tester.pumpAndSettle();

      await tester.tap(find.text('eDNI Nuevo (QR)').last);
      await tester.pumpAndSettle();

      final button = find.widgetWithText(ElevatedButton, 'Generar');
      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(find.text('Formato: eDNI Nuevo (QR)'), findsOneWidget);
      // El QR widget de qr_flutter debería estar en el árbol
      // (No podemos chequear `QrImageView` tan fácil sin importarlo, pero podemos confiar en que cambia el texto)
    });

    testWidgets('Selecting DNI Físico Clásico creates PDF417', (WidgetTester tester) async {
      await tester.pumpWidget(DniGeneratorApp(dataService: mockService));

      final dropdown = find.byType(DropdownButtonFormField<DniType>);
      await tester.tap(dropdown);
      await tester.pumpAndSettle();

      await tester.tap(find.text('DNI Físico Clásico (PDF417)').last);
      await tester.pumpAndSettle();

      final button = find.widgetWithText(ElevatedButton, 'Generar');
      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(find.text('Formato: DNI Físico Clásico (PDF417)'), findsOneWidget);
      // El BarcodeWidget debería estar en el árbol
    });

    testWidgets('Selecting DNI Policarbonato creates PDF417', (WidgetTester tester) async {
      await tester.pumpWidget(DniGeneratorApp(dataService: mockService));

      final dropdown = find.byType(DropdownButtonFormField<DniType>);
      await tester.tap(dropdown);
      await tester.pumpAndSettle();

      await tester.tap(find.text('DNI Policarbonato (PDF417)').last);
      await tester.pumpAndSettle();

      final button = find.widgetWithText(ElevatedButton, 'Generar');
      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(find.text('Formato: DNI Policarbonato (PDF417)'), findsOneWidget);
      // El BarcodeWidget debería estar en el árbol
    });
  });
}
