import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dni_test_gen/main.dart';
import 'package:dni_test_gen/models/dni_type.dart';
import 'package:dni_test_gen/models/identity.dart';
import 'package:dni_test_gen/models/generated_code_record.dart';
import 'package:dni_test_gen/services/data_generator_service.dart';

void main() {
  group('Feature: History Search - Unit Tests', () {
    final identity1 = Identity(
      nombre: 'María José',
      apellido: 'González',
      sexo: 'F',
      dni: 35123456,
      ejemplar: 'B',
      tramiteId: '00123456789',
      fechaNacimiento: DateTime(1990, 5, 20),
      fechaEmision: DateTime(2020, 10, 15),
    );

    final record1 = GeneratedCodeRecord(
      identity: identity1,
      type: DniType.newVersion,
      generatedAt: DateTime(2023, 1, 1),
    );

    final identity2 = Identity(
      nombre: 'Carlos',
      apellido: 'Pérez',
      sexo: 'M',
      dni: 20987654,
      ejemplar: 'A',
      tramiteId: '00987654321',
      fechaNacimiento: DateTime(1975, 12, 1),
      fechaEmision: DateTime(2015, 3, 10),
    );

    final record2 = GeneratedCodeRecord(
      identity: identity2,
      type: DniType.oldVersion,
      generatedAt: DateTime(2023, 1, 2),
    );

    test('matches empty search query', () {
      expect(record1.matchesSearch(''), isTrue);
      expect(record1.matchesSearch('   '), isTrue);
    });

    test('matches by DNI with and without dots', () {
      expect(record1.matchesSearch('35123456'), isTrue);
      expect(record1.matchesSearch('35.123.456'), isTrue);
      expect(record1.matchesSearch('35.123'), isTrue);
      expect(record1.matchesSearch('99999999'), isFalse);
    });

    test('matches by name and surname ignoring case and accents', () {
      expect(record1.matchesSearch('maria'), isTrue);
      expect(record1.matchesSearch('MARÍA'), isTrue);
      expect(record1.matchesSearch('gonzalez'), isTrue);
      expect(record1.matchesSearch('González'), isTrue);
      expect(record2.matchesSearch('perez'), isTrue);
      expect(record2.matchesSearch('carlos'), isTrue);
    });

    test('matches by sexo', () {
      expect(record1.matchesSearch('F'), isTrue);
      expect(record1.matchesSearch('femenino'), isTrue);
      expect(record2.matchesSearch('M'), isTrue);
      expect(record2.matchesSearch('masculino'), isTrue);
    });

    test('matches by ejemplar', () {
      expect(record1.matchesSearch('ejemplar B'), isTrue);
      expect(record2.matchesSearch('ejemplar A'), isTrue);
    });

    test('matches by tramiteId', () {
      expect(record1.matchesSearch('00123456789'), isTrue);
      expect(record1.matchesSearch('123456789'), isTrue);
      expect(record2.matchesSearch('00987654321'), isTrue);
    });

    test('matches by fecha de nacimiento and emision', () {
      expect(record1.matchesSearch('20/05/1990'), isTrue);
      expect(record1.matchesSearch('1990'), isTrue);
      expect(record1.matchesSearch('15/10/2020'), isTrue);
      expect(record2.matchesSearch('01/12/1975'), isTrue);
    });

    test('matches by document type format', () {
      expect(record1.matchesSearch('QR'), isTrue);
      expect(record1.matchesSearch('nuevo'), isTrue);
      expect(record1.matchesSearch('version nueva'), isTrue);

      expect(record2.matchesSearch('PDF417'), isTrue);
      expect(record2.matchesSearch('viejo'), isTrue);
      expect(record2.matchesSearch('version vieja'), isTrue);
    });

    test('matches multi-token queries', () {
      expect(record1.matchesSearch('Maria QR'), isTrue);
      expect(record1.matchesSearch('Gonzalez 35.123'), isTrue);
      expect(record1.matchesSearch('Maria PDF417'), isFalse);
    });
  });

  group('Feature: History Search - Widget UI Tests', () {
    late DataGeneratorService mockService;

    setUp(() {
      mockService = DataGeneratorService();
      mockService.setTestData(['Juan', 'Maria'], ['Perez', 'Gomez']);
    });

    testWidgets('Search input filters history items in UI and can be cleared', (tester) async {
      await tester.pumpWidget(DniGeneratorApp(dataService: mockService));

      // Initially empty history
      expect(find.text('No hay registros en el historial'), findsOneWidget);
      expect(find.byType(TextField), findsWidgets); // Search field + other inputs

      // Find search field
      final searchField = find.widgetWithText(TextField, 'Buscar en historial...');
      expect(searchField, findsOneWidget);

      // Generate first record
      final generateBtn = find.widgetWithText(ElevatedButton, 'Generar');
      await tester.tap(generateBtn);
      await tester.pumpAndSettle();

      // Generate second record
      await tester.tap(generateBtn);
      await tester.pumpAndSettle();

      // Now we have 2 records in history
      final tiles = find.byType(ListTile);
      expect(tiles, findsNWidgets(2));

      // Type in search bar to filter for something non-existent
      await tester.enterText(searchField, 'NonExistentPerson12345');
      await tester.pumpAndSettle();

      expect(find.textContaining('Sin resultados para'), findsOneWidget);
      expect(find.byType(ListTile), findsNothing);

      // Clear search using clear button
      final clearBtn = find.byTooltip('Limpiar búsqueda');
      expect(clearBtn, findsOneWidget);
      await tester.tap(clearBtn);
      await tester.pumpAndSettle();

      // Both items restored
      expect(find.byType(ListTile), findsNWidgets(2));
    });
  });

  group('Feature: Session Load Replace / Append Tests', () {
    late DataGeneratorService mockService;
    late AppState appState;

    final recordA = GeneratedCodeRecord(
      identity: Identity(
        nombre: 'A',
        apellido: 'A',
        sexo: 'M',
        dni: 11111111,
        ejemplar: 'A',
        tramiteId: '00000000001',
        fechaNacimiento: DateTime(1990, 1, 1),
        fechaEmision: DateTime(2020, 1, 1),
      ),
      type: DniType.newVersion,
      generatedAt: DateTime.now(),
    );

    final recordB = GeneratedCodeRecord(
      identity: Identity(
        nombre: 'B',
        apellido: 'B',
        sexo: 'F',
        dni: 22222222,
        ejemplar: 'B',
        tramiteId: '00000000002',
        fechaNacimiento: DateTime(1995, 2, 2),
        fechaEmision: DateTime(2021, 2, 2),
      ),
      type: DniType.oldVersion,
      generatedAt: DateTime.now(),
    );

    setUp(() {
      mockService = DataGeneratorService();
      appState = AppState(mockService);
    });

    test('importRecords with replace = false appends to existing records', () {
      appState.importRecords([recordA], replace: false);
      expect(appState.history.length, 1);
      expect(appState.history.first.identity.dni, 11111111);

      appState.importRecords([recordB], replace: false);
      expect(appState.history.length, 2);
      expect(appState.history[0].identity.dni, 11111111);
      expect(appState.history[1].identity.dni, 22222222);
    });

    test('importRecords with replace = true replaces existing records', () {
      appState.importRecords([recordA], replace: false);
      expect(appState.history.length, 1);
      expect(appState.history.first.identity.dni, 11111111);

      appState.importRecords([recordB], replace: true);
      expect(appState.history.length, 1);
      expect(appState.history.first.identity.dni, 22222222);
    });
  });
}
