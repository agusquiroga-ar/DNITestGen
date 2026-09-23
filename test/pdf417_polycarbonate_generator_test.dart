import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dni_test_gen/models/identity.dart';
import 'package:dni_test_gen/generators/pdf417_polycarbonate_generator.dart';
import 'package:barcode_widget/barcode_widget.dart';

void main() {
  group('Pdf417PolycarbonateGenerator Tests', () {
    final identity = Identity(
      nombre: 'Juan',
      apellido: 'Perez',
      sexo: 'M',
      dni: 12345678,
      ejemplar: 'A',
      tramiteId: 'T123',
      fechaNacimiento: DateTime(1990, 5, 10),
      fechaEmision: DateTime(2024, 3, 20),
    );

    test('generateString starts with an empty field', () {
      final result = Pdf417PolycarbonateGenerator.generateString(identity);
      final parts = result.split('@');

      expect(parts[0], isEmpty);
    });

    test('generateString places fields per DNI PDF417 policarbonato layout', () {
      final result = Pdf417PolycarbonateGenerator.generateString(identity);
      final parts = result.split('@');

      // @DNI@?@?@APELLIDO@NOMBRE@NACIONALIDAD@FEC_NAC@SEXO@FEC_EMISION@NRO_TRAMITE@OF_IDENT@FEC_VENC@L1@L2@L3@L4@L5
      expect(parts[1], '12345678'); // DNI
      expect(parts[4], 'PEREZ'); // APELLIDO
      expect(parts[5], 'JUAN'); // NOMBRE
      expect(parts[6], 'ARG'); // NACIONALIDAD
      expect(parts[7], '10/05/1990'); // FEC_NAC
      expect(parts[8], 'M'); // SEXO
      expect(parts[9], '20/03/2024'); // FEC_EMISION
      expect(parts[10], 'T123'); // NRO_TRAMITE
      expect(parts[12], '20/03/2039'); // FEC_VENC (emisión + 15 años)
    });

    test('generateString DNI field is numeric', () {
      final result = Pdf417PolycarbonateGenerator.generateString(identity);
      final parts = result.split('@');

      expect(int.tryParse(parts[1]), isNotNull);
    });

    testWidgets('buildBarcodeWidget renders a BarcodeWidget', (WidgetTester tester) async {
      final data = Pdf417PolycarbonateGenerator.generateString(identity);
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Pdf417PolycarbonateGenerator.buildBarcodeWidget(data),
        ),
      );

      expect(find.byType(BarcodeWidget), findsOneWidget);
    });
  });
}
