import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:barcode_widget/barcode_widget.dart';
import '../models/identity.dart';

class OldDniGenerator {
  /// Devuelve el string delimitado por '@' en formato PDF417 según la especificación del DNI viejo.
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
    final codigo = "200"; // Código de control / CUIL estático simulado

    //return '$tramite@$apellido@$nombre@$sexo@$dni@$ejemplar@$fechaNac@$fechaEmi@$codigo';
    return '$tramite@$apellido@$nombre@$sexo@$dni@$ejemplar@$fechaNac@$fechaEmi';
  }

  /// Retorna un widget que renderiza gráficamente el código PDF417
  static Widget buildBarcodeWidget(String data) {
    return BarcodeWidget(
      barcode: Barcode.pdf417(),
      data: data,
      errorBuilder: (context, error) => Center(child: Text(error)),
      width: 400,
      height: 100,
      drawText: false,
    );
  }
}
