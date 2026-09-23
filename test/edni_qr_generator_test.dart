import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dni_test_gen/models/identity.dart';
import 'package:dni_test_gen/generators/edni_qr_generator.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  group('EdniQrGenerator Tests', () {
    final validIdentity = Identity(
      nombre: 'Juan',
      apellido: 'Perez',
      sexo: 'X',
      dni: 12345678,
      ejemplar: 'B',
      tramiteId: '00123456789', // 11 dígitos
      fechaNacimiento: DateTime(1990, 1, 1),
      fechaEmision: DateTime(2023, 2, 28),
    );

    test('generateString builds correct formatted string with 8 fields', () {
      final data = EdniQrGenerator.generateString(validIdentity);

      expect(data, startsWith('00123456789@PEREZ@JUAN@12345678@B@01/01/1990@28/02/2023@'));
      expect(data.split('@').length, equals(8));
    });

    test('generateString last field looks like a JWT', () {
      final data = EdniQrGenerator.generateString(validIdentity);
      final jwt = data.split('@').last;

      expect(jwt.split('.').length, equals(3));
    });

    test('generateString throws if tramiteId does not have 11 digits', () {
      final invalidIdentity = Identity(
        nombre: 'Juan',
        apellido: 'Perez',
        sexo: 'M',
        dni: 12345678,
        ejemplar: 'A',
        tramiteId: '123456789', // 9 dígitos, inválido
        fechaNacimiento: DateTime(1990, 1, 1),
        fechaEmision: DateTime.now(),
      );

      expect(() => EdniQrGenerator.generateString(invalidIdentity), throwsArgumentError);
    });

    testWidgets('buildQrWidget renders a QrImageView', (WidgetTester tester) async {
      final data = EdniQrGenerator.generateString(validIdentity);
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: EdniQrGenerator.buildQrWidget(data),
        ),
      );

      final qrFinder = find.byType(QrImageView);
      expect(qrFinder, findsOneWidget);
    });
  });
}
