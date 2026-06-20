import 'package:flutter_test/flutter_test.dart';
import 'package:dni_test_gen/models/identity.dart';
import 'package:dni_test_gen/services/data_generator_service.dart';

void main() {
  group('Feature 02: DataGeneratorService Tests', () {
    late DataGeneratorService service;

    setUp(() {
      service = DataGeneratorService();
      // Inyectar datos mock para testing sin depender de assets JSON reales
      service.setTestData(['Juan', 'Ana'], ['Perez', 'Gomez']);
    });

    test('generateIdentity throws if not loaded', () {
      final unloadedService = DataGeneratorService();
      expect(() => unloadedService.generateIdentity(), throwsException);
    });

    test('generateIdentity returns names from dictionary', () {
      final identity = service.generateIdentity();
      expect(['Juan', 'Ana'], contains(identity.nombre));
      expect(['Perez', 'Gomez'], contains(identity.apellido));
    });

    test('generateIdentity respects min and max DNI', () {
      final identity = service.generateIdentity(minDni: 100, maxDni: 150);
      expect(identity.dni, greaterThanOrEqualTo(100));
      expect(identity.dni, lessThanOrEqualTo(150));
    });

    test('generateIdentity throws if minDni > maxDni', () {
      expect(() => service.generateIdentity(minDni: 200, maxDni: 100), throwsArgumentError);
    });

    test('generateIdentity creates valid sexo and ejemplar', () {
      final identity = service.generateIdentity();
      expect(['M', 'F', 'X'], contains(identity.sexo));
      expect(['A', 'B', 'C', 'D'], contains(identity.ejemplar));
    });

    test('generateIdentity creates tramiteId of exactly 9 digits', () {
      final identity = service.generateIdentity();
      expect(identity.tramiteId.length, 9);
      expect(int.tryParse(identity.tramiteId), isNotNull); // Verifica que sea numerico
    });
  });
}
