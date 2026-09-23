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
            .level4, // Nivel alto para documentos de identidad
        moduleHeight: 4.0, // Relación de aspecto para barras alargadas
      ),
      data: data,
      errorBuilder: (context, error) => Center(child: Text(error)),
      width: 500,
      height: 100,
      drawText: false,
    );
  }
}
