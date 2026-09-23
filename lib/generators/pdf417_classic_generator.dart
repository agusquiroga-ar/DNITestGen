import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zxing_widget/zxing_widget.dart';
import '../models/identity.dart';

/// Genera el payload del PDF417 clásico del DNI físico:
/// TRAMITE@APELLIDO@NOMBRE@SEXO@DNI@EJEMPLAR@FEC_NAC@FEC_EMISION@CONTROL
class Pdf417ClassicGenerator {
  static String generateString(Identity identity) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    final tramite = identity.tramiteId;
    final apellido = identity.apellido.toUpperCase();
    final nombre = identity.nombre.toUpperCase();
    final sexo = identity.sexo;
    final dni = identity.dni.toString();
    final ejemplar = identity.ejemplar;
    final fechaNac = dateFormat.format(identity.fechaNacimiento);
    final fechaEmi = dateFormat.format(identity.fechaEmision);
    const control = "ABC123"; // Código de control simulado

    return '$tramite@$apellido@$nombre@$sexo@$dni@$ejemplar@$fechaNac@$fechaEmi@$control';
  }

  /// Retorna un widget que renderiza gráficamente el código PDF417
  static Widget buildBarcodeWidget(String data) {
    try {
      return BarcodeWidget(
        PDF417Painter(
          data,
          // Corrección de errores alta para mejorar la lectura
          errorCorrectionLevel: 6,
          // Zona de silencio (quiet zone) real en los 4 bordes: sin ella los
          // lectores de PDF417 fallan al ubicar los patrones de inicio/fin.
          padding: 20,
          backgroundColor: Colors.white,
        ),
        size: const Size(500, 160),
      );
    } catch (e) {
      return Center(child: Text('$e'));
    }
  }
}
