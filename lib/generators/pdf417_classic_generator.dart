import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:barcode_widget/barcode_widget.dart';
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
    return BarcodeWidget(
      barcode: Barcode.pdf417(
        securityLevel: Pdf417SecurityLevel
            .level6, // Corrección de errores alta para mejorar la lectura
        moduleHeight: 4.0, // Relación de aspecto para barras alargadas
      ),
      data: data,
      errorBuilder: (context, error) => Center(child: Text(error)),
      backgroundColor: Colors.white,
      // Zona de silencio (quiet zone) real en los 4 bordes: sin ella los
      // lectores de PDF417 fallan al ubicar los patrones de inicio/fin,
      // sobre todo arriba y abajo, donde el ajuste automático al tamaño
      // del widget puede dejar las barras pegadas al borde.
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      width: 500,
      height: 160,
      drawText: false,
    );
  }
}
