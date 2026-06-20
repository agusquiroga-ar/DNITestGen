import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dni_test_gen/models/identity.dart';
import 'package:dni_test_gen/generators/old_dni_generator.dart';
import 'package:barcode_widget/barcode_widget.dart';

void main() {
  group('Feature 04: OldDniGenerator Tests', () {
    final identity = Identity(
      nombre: 'Juan carlos',
      apellido: 'Perez',
      sexo: 'M',
      dni: 12345678,
      ejemplar: 'A',
      tramiteId: '123456789',
      fechaNacimiento: DateTime(1990, 1, 15),
      fechaEmision: DateTime(2022, 10, 5),
    );

    test('generateString returns 9 fields separated by @', () {
      final result = OldDniGenerator.generateString(identity);
      final parts = result.split('@');
      
      expect(parts.length, 9);
    });

    test('generateString formats dates correctly', () {
      final result = OldDniGenerator.generateString(identity);
      final parts = result.split('@');
      
      // Fecha de nacimiento está en el índice 6
      expect(parts[6], '15/01/1990');
      // Fecha de emisión está en el índice 7
      expect(parts[7], '05/10/2022');
    });

    test('generateString converts names to uppercase', () {
      final result = OldDniGenerator.generateString(identity);
      final parts = result.split('@');
      
      // Apellido índice 1, Nombre índice 2
      expect(parts[1], 'PEREZ');
      expect(parts[2], 'JUAN CARLOS');
    });

    testWidgets('buildBarcodeWidget renders a BarcodeWidget', (WidgetTester tester) async {
      final data = OldDniGenerator.generateString(identity);
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: OldDniGenerator.buildBarcodeWidget(data),
        ),
      );

      expect(find.byType(BarcodeWidget), findsOneWidget);
    });
  });
}
