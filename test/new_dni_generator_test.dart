import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dni_test_gen/models/identity.dart';
import 'package:dni_test_gen/generators/new_dni_generator.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  group('Feature 05: NewDniGenerator Tests', () {
    final validIdentity = Identity(
      nombre: 'Juan',
      apellido: 'Perez',
      sexo: 'X',
      dni: 12345678,
      ejemplar: 'B',
      tramiteId: '123456789',
      fechaNacimiento: DateTime(1990, 1, 1),
      fechaEmision: DateTime.now(),
    );

    test('generateUrl builds correct valid URL', () {
      final url = NewDniGenerator.generateUrl(validIdentity);
      expect(url, 'https://mitramite.renaper.gob.ar/validar?id=123456789&dni=12345678&sexo=X&ejemplar=B');
    });

    test('generateUrl throws if tramiteId does not have 9 digits', () {
      final invalidIdentity = Identity(
        nombre: 'Juan',
        apellido: 'Perez',
        sexo: 'M',
        dni: 12345678,
        ejemplar: 'A',
        tramiteId: '12345', // Inválido
        fechaNacimiento: DateTime(1990, 1, 1),
        fechaEmision: DateTime.now(),
      );

      expect(() => NewDniGenerator.generateUrl(invalidIdentity), throwsArgumentError);
    });

    testWidgets('buildQrWidget renders a QrImageView', (WidgetTester tester) async {
      final url = NewDniGenerator.generateUrl(validIdentity);
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: NewDniGenerator.buildQrWidget(url),
        ),
      );

      final qrFinder = find.byType(QrImageView);
      expect(qrFinder, findsOneWidget);
    });
  });
}
