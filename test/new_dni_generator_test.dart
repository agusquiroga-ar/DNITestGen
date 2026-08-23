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
      tramiteId: '00123456789', // 11 dígitos
      fechaNacimiento: DateTime(1990, 1, 1),
      fechaEmision: DateTime(2023, 2, 28),
    );

    test('generateString builds correct formatted string', () {
      final data = NewDniGenerator.generateString(validIdentity);
      
      // Debe contener el inicio de los campos concatenados con @
      expect(data, startsWith('00123456789@PEREZ@JUAN@12345678@B@01/01/90@28/02/23@'));
      
      // Y debe terminar en una firma base64 o partes de JWT
      expect(data.split('@').length, equals(8)); 
    });

    test('generateString throws if tramiteId does not have 11 digits', () {
      final invalidIdentity = Identity(
        nombre: 'Juan',
        apellido: 'Perez',
        sexo: 'M',
        dni: 12345678,
        ejemplar: 'A',
        tramiteId: '123456789', // 9 dígitos, Inválido ahora
        fechaNacimiento: DateTime(1990, 1, 1),
        fechaEmision: DateTime.now(),
      );

      expect(() => NewDniGenerator.generateString(invalidIdentity), throwsArgumentError);
    });

    testWidgets('buildQrWidget renders a QrImageView', (WidgetTester tester) async {
      final data = NewDniGenerator.generateString(validIdentity);
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: NewDniGenerator.buildQrWidget(data),
        ),
      );

      final qrFinder = find.byType(QrImageView);
      expect(qrFinder, findsOneWidget);
    });
  });
}
