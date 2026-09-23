import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zxing_widget/zxing_widget.dart';
import '../models/identity.dart';

class OldDniGenerator {
  /// Devuelve el string delimitado por '@' en formato PDF417 según la especificación del DNI viejo.
  static String generateString(Identity identity) {
    // La especificación indica DD-MM-AAAA o DD/MM/YYYY. 
    final dateFormat = DateFormat('dd/MM/yyyy');

    final tramite = identity.tramiteId;
    final apellido = identity.apellido.toUpperCase();
    final nombre = identity.nombre.toUpperCase();
    final sexo = identity.sexo;
    final dni = identity.dni.toString();
    final ejemplar = identity.ejemplar;
    final fechaNac = dateFormat.format(identity.fechaNacimiento);
    final fechaEmi = dateFormat.format(identity.fechaEmision);
    final codigo = "200"; // Código de control / CUIL simulado

    return '"$tramite"@"$apellido"@"$nombre"@"$sexo"@"$dni"@"$ejemplar"@"$fechaNac"@"$fechaEmi"@"$codigo"';
  }

  /// Retorna un widget que renderiza gráficamente el código PDF417
  static Widget buildBarcodeWidget(String data) {
    try {
      return BarcodeWidget(
        PDF417Painter(
          data,
          errorCorrectionLevel: 4, // Nivel alto para documentos de identidad
        ),
        size: const Size(500, 100),
      );
    } catch (e) {
      return Center(child: Text('$e'));
    }
  }
}
