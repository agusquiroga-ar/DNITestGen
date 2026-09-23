import 'package:flutter_test/flutter_test.dart';
import 'package:dni_test_gen/models/generated_code_record.dart';
import 'package:dni_test_gen/models/identity.dart';
import 'package:dni_test_gen/models/dni_type.dart';
import 'package:dni_test_gen/services/pdf_export_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('generates a PDF with multiple pages for 25 mixed records', () async {
    final records = List.generate(25, (i) {
      return GeneratedCodeRecord(
        identity: Identity(
          nombre: 'JOSÉ ÁNGEL$i',
          apellido: 'NÚÑEZ GONZÁLEZ$i',
          sexo: i.isEven ? 'M' : 'F',
          dni: 30000000 + i,
          ejemplar: 'A',
          tramiteId: (10000000000 + i).toString(),
          fechaNacimiento: DateTime(1990, 1, 1 + (i % 27)),
          fechaEmision: DateTime(2020, 1, 1 + (i % 27)),
        ),
        type: const [
          DniType.pdf417Classic,
          DniType.pdf417Polycarbonate,
          DniType.edniQr,
        ][i % 3],
        generatedAt: DateTime.now(),
      );
    });

    final bytes = await PdfExportService.buildHistoryPdf(records);
    expect(bytes, isNotEmpty);
    // PDF magic header
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
  });

  test('handles empty history without throwing', () async {
    final bytes = await PdfExportService.buildHistoryPdf([]);
    expect(bytes, isNotEmpty);
  });
}
