import 'package:flutter_test/flutter_test.dart';
import 'package:dni_test_gen/models/dni_type.dart';
import 'package:dni_test_gen/models/generated_code_record.dart';
import 'package:dni_test_gen/models/identity.dart';

void main() {
  group('GeneratedCodeRecord.fromJson legacy type mapping', () {
    Map<String, dynamic> jsonWithType(String type) {
      return {
        'identity': Identity(
          nombre: 'Juan',
          apellido: 'Perez',
          sexo: 'M',
          dni: 12345678,
          ejemplar: 'A',
          tramiteId: '00123456789',
          fechaNacimiento: DateTime(1990, 1, 1),
          fechaEmision: DateTime(2020, 1, 1),
        ).toJson(),
        'type': type,
        'generatedAt': DateTime(2023, 1, 1).toIso8601String(),
      };
    }

    test('maps legacy "oldVersion" sessions to pdf417Classic', () {
      final record = GeneratedCodeRecord.fromJson(jsonWithType('oldVersion'));
      expect(record.type, DniType.pdf417Classic);
    });

    test('maps legacy "newVersion" sessions to edniQr', () {
      final record = GeneratedCodeRecord.fromJson(jsonWithType('newVersion'));
      expect(record.type, DniType.edniQr);
    });

    test('reads current type names as-is', () {
      expect(
        GeneratedCodeRecord.fromJson(jsonWithType('edniQr')).type,
        DniType.edniQr,
      );
      expect(
        GeneratedCodeRecord.fromJson(jsonWithType('pdf417Classic')).type,
        DniType.pdf417Classic,
      );
      expect(
        GeneratedCodeRecord.fromJson(jsonWithType('pdf417Polycarbonate')).type,
        DniType.pdf417Polycarbonate,
      );
    });
  });
}
