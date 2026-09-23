import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dni_test_gen/models/identity.dart';
import 'package:dni_test_gen/generators/pdf417_classic_generator.dart';
import 'package:zxing_widget/zxing_widget.dart';

void main() {
  group('Pdf417ClassicGenerator Tests', () {
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
      final result = Pdf417ClassicGenerator.generateString(identity);
      final parts = result.split('@');

      expect(parts.length, 9);
    });

    test('generateString places fields per DNI PDF417 classic layout', () {
      final result = Pdf417ClassicGenerator.generateString(identity);
      final parts = result.split('@');

      // TRAMITE@APELLIDO@NOMBRE@SEXO@DNI@EJEMPLAR@FEC_NAC@FEC_EMISION@CONTROL
      expect(parts[0], '123456789');
      expect(parts[1], 'PEREZ');
      expect(parts[2], 'JUAN CARLOS');
      expect(parts[3], 'M');
      expect(parts[4], '12345678');
      expect(parts[5], 'A');
      expect(parts[6], '15/01/1990');
      expect(parts[7], '05/10/2022');
    });

    test('generateString DNI field is numeric', () {
      final result = Pdf417ClassicGenerator.generateString(identity);
      final parts = result.split('@');

      expect(int.tryParse(parts[4]), isNotNull);
    });

    testWidgets('buildBarcodeWidget renders a BarcodeWidget', (WidgetTester tester) async {
      final data = Pdf417ClassicGenerator.generateString(identity);
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Pdf417ClassicGenerator.buildBarcodeWidget(data),
        ),
      );

      expect(find.byType(BarcodeWidget), findsOneWidget);
    });
  });
}
