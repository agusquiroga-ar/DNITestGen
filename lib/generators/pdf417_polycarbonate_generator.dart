import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:barcode_widget/barcode_widget.dart';
import '../models/identity.dart';

/// Genera el payload del PDF417 del DNI de policarbonato / electrónico.
///
/// Estructura, separada por '@', con el primer campo vacío:
/// @DNI@?@?@APELLIDO@NOMBRE@NACIONALIDAD@FEC_NAC@SEXO@FEC_EMISION@NRO_TRAMITE@OF_IDENT@FEC_VENC@L1@L2@L3@L4@L5
class Pdf417PolycarbonateGenerator {
  static String generateString(Identity identity) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    final dni = identity.dni.toString();
    final apellido = identity.apellido.toUpperCase();
    final nombre = identity.nombre.toUpperCase();
    const nacionalidad = "ARG";
    final fechaNac = dateFormat.format(identity.fechaNacimiento);
    final sexo = identity.sexo;
    final fechaEmi = dateFormat.format(identity.fechaEmision);
    final nroTramite = identity.tramiteId;
    const ofIdent = "RNP001"; // Oficina de identificación simulada

    // Vencimiento simulado: 15 años posteriores a la emisión (validez estándar del DNI argentino adulto).
    final fechaVenc = dateFormat.format(
      DateTime(
        identity.fechaEmision.year + 15,
        identity.fechaEmision.month,
        identity.fechaEmision.day,
      ),
    );

    return '@$dni@?@?@$apellido@$nombre@$nacionalidad@$fechaNac@$sexo@$fechaEmi@$nroTramite@$ofIdent@$fechaVenc@0@0@0@0@0';
  }

  /// Retorna un widget que renderiza gráficamente el código PDF417
  static Widget buildBarcodeWidget(String data) {
    return BarcodeWidget(
      barcode: Barcode.pdf417(
        securityLevel: Pdf417SecurityLevel.level4,
        moduleHeight: 4.0,
      ),
      data: data,
      errorBuilder: (context, error) => Center(child: Text(error)),
      width: 500,
      height: 100,
      drawText: false,
    );
  }
}
