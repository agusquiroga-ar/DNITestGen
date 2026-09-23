import 'dart:typed_data';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../generators/new_dni_generator.dart';
import '../generators/old_dni_generator.dart';
import '../models/dni_type.dart';
import '../models/generated_code_record.dart';

class PdfExportService {
  static const int _columns = 4;
  static const int _rows = 5;
  static const int _perPage = _columns * _rows;

  static const _pageMargin = pw.EdgeInsets.all(18);
  static const _cellSpacing = 6.0;

  /// Genera un PDF con todos los códigos del historial, 20 por hoja A4
  /// distribuidos en una grilla de 4 columnas por 5 filas.
  static Future<Uint8List> buildHistoryPdf(
    List<GeneratedCodeRecord> records,
  ) async {
    // Fuente embebida con soporte Unicode: los apellidos/nombres pueden
    // incluir tildes y "ñ", que la fuente Helvetica por defecto no dibuja.
    // Se empaqueta como asset para que la exportación funcione sin conexión.
    final regularFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/NotoSans-Regular.ttf'),
    );
    final boldFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/NotoSans-Bold.ttf'),
    );

    final doc = pw.Document(
      theme: pw.ThemeData.withFont(base: regularFont, bold: boldFont),
    );

    for (var i = 0; i < records.length; i += _perPage) {
      final end = (i + _perPage < records.length) ? i + _perPage : records.length;
      final chunk = records.sublist(i, end);

      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: _pageMargin,
          build: (context) => _buildGrid(chunk),
        ),
      );
    }

    return doc.save();
  }

  static pw.Widget _buildGrid(List<GeneratedCodeRecord> chunk) {
    final cells = List<pw.Widget>.generate(_perPage, (index) {
      if (index < chunk.length) {
        return _buildCell(chunk[index]);
      }
      return pw.Container();
    });

    return pw.GridView(
      crossAxisCount: _columns,
      childAspectRatio: 1.0,
      crossAxisSpacing: _cellSpacing,
      mainAxisSpacing: _cellSpacing,
      children: cells,
    );
  }

  static pw.Widget _buildCell(GeneratedCodeRecord record) {
    final identity = record.identity;
    final isOld = record.type == DniType.oldVersion;

    final data = isOld
        ? OldDniGenerator.generateString(identity)
        : NewDniGenerator.generateString(identity);

    final barcode = isOld
        ? Barcode.pdf417(securityLevel: Pdf417SecurityLevel.level4)
        : Barcode.qrCode(errorCorrectLevel: BarcodeQRCorrectionLevel.medium);

    return pw.Container(
      padding: const pw.EdgeInsets.all(4),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400, width: 0.5),
        borderRadius: pw.BorderRadius.circular(3),
      ),
      child: pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Expanded(
            child: pw.Center(
              child: pw.BarcodeWidget(
                barcode: barcode,
                data: data,
                drawText: false,
                width: isOld ? 110 : 78,
                height: isOld ? 30 : 78,
              ),
            ),
          ),
          pw.SizedBox(height: 3),
          pw.Text(
            'DNI ${identity.dni}',
            style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold),
            textAlign: pw.TextAlign.center,
          ),
          pw.Text(
            '${identity.apellido}, ${identity.nombre}',
            style: const pw.TextStyle(fontSize: 6),
            textAlign: pw.TextAlign.center,
            maxLines: 1,
            overflow: pw.TextOverflow.clip,
          ),
          pw.Text(
            isOld ? 'PDF417' : 'QR',
            style: const pw.TextStyle(fontSize: 5.5, color: PdfColors.grey600),
          ),
        ],
      ),
    );
  }
}
