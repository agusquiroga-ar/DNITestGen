import 'dart:typed_data';

import 'package:barcode/barcode.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:zxing_lib/common.dart' as zx;
import 'package:zxing_lib/pdf417.dart' as zx;
import 'package:zxing_lib/zxing.dart' as zx;

import '../generators/edni_qr_generator.dart';
import '../generators/pdf417_classic_generator.dart';
import '../generators/pdf417_polycarbonate_generator.dart';
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
    final isQr = record.type == DniType.edniQr;

    final String data;
    switch (record.type) {
      case DniType.pdf417Classic:
        data = Pdf417ClassicGenerator.generateString(identity);
        break;
      case DniType.pdf417Polycarbonate:
        data = Pdf417PolycarbonateGenerator.generateString(identity);
        break;
      case DniType.edniQr:
      case DniType.random:
        data = EdniQrGenerator.generateString(identity);
        break;
    }

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
              child: isQr
                  ? pw.BarcodeWidget(
                      barcode: Barcode.qrCode(
                        errorCorrectLevel: BarcodeQRCorrectionLevel.medium,
                      ),
                      data: data,
                      drawText: false,
                      backgroundColor: PdfColors.white,
                      padding: const pw.EdgeInsets.all(2),
                      width: 78,
                      height: 78,
                    )
                  : _buildPdf417(data, width: 116, height: 46),
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
            _pdfTypeLabel(record.type),
            style: const pw.TextStyle(fontSize: 5.5, color: PdfColors.grey600),
          ),
        ],
      ),
    );
  }

  /// Dibuja un PDF417 como vector a partir de la matriz de ZXing, el mismo
  /// encoder que usa la vista en pantalla (zxing_widget), para que el código
  /// impreso sea idéntico al que se muestra y se lea igual de bien.
  static pw.Widget _buildPdf417(
    String data, {
    required double width,
    required double height,
  }) {
    final zx.BitMatrix matrix;
    try {
      matrix = zx.PDF417Writer().encode(
        data,
        zx.BarcodeFormat.pdf417,
        1,
        1,
        // Corrección de errores alta, igual que en pantalla. La matriz va
        // sin margen porque la zona de silencio la agrega el padding.
        zx.EncodeHint(errorCorrection: 6, margin: 0),
      );
    } catch (e) {
      return pw.Text('$e', style: const pw.TextStyle(fontSize: 5));
    }

    // Zona de silencio real en los 4 bordes: sin ella el PDF417 impreso
    // pierde los márgenes que el lector necesita para ubicar los patrones
    // de inicio/fin.
    const padX = 4.0;
    const padY = 6.0;

    return pw.CustomPaint(
      size: PdfPoint(width, height),
      painter: (canvas, size) {
        canvas
          ..setFillColor(PdfColors.white)
          ..drawRect(0, 0, size.x, size.y)
          ..fillPath();

        final moduleW = (size.x - padX * 2) / matrix.width;
        final moduleH = (size.y - padY * 2) / matrix.height;

        canvas.setFillColor(PdfColors.black);
        for (var y = 0; y < matrix.height; y++) {
          // El origen del PDF está abajo a la izquierda: se invierte Y.
          final bottom = size.y - padY - (y + 1) * moduleH;
          var x = 0;
          while (x < matrix.width) {
            if (!matrix.get(x, y)) {
              x++;
              continue;
            }
            // Agrupa módulos negros contiguos en un solo rectángulo.
            final start = x;
            while (x < matrix.width && matrix.get(x, y)) {
              x++;
            }
            canvas.drawRect(
              padX + start * moduleW,
              bottom,
              (x - start) * moduleW,
              moduleH,
            );
          }
        }
        canvas.fillPath();
      },
    );
  }

  static String _pdfTypeLabel(DniType type) {
    switch (type) {
      case DniType.edniQr:
        return 'QR';
      case DniType.pdf417Classic:
        return 'PDF417 Clásico';
      case DniType.pdf417Polycarbonate:
        return 'PDF417 Policarbonato';
      case DniType.random:
        return '';
    }
  }
}
