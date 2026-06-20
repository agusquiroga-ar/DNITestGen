import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/identity.dart';

class NewDniGenerator {
  /// Construye la URL de validación oficial parametrizada para el código QR del eDNI.
  static String generateUrl(Identity identity) {
    final tramiteId = identity.tramiteId;
    
    // Validación estricta del número de trámite
    if (tramiteId.length != 9 || int.tryParse(tramiteId) == null) {
      throw ArgumentError('El número de trámite (id) para el nuevo DNI electrónico debe ser exactamente de 9 dígitos numéricos.');
    }

    final dni = identity.dni.toString();
    final sexo = identity.sexo;
    final ejemplar = identity.ejemplar;

    return 'https://mitramite.renaper.gob.ar/validar?id=$tramiteId&dni=$dni&sexo=$sexo&ejemplar=$ejemplar';
  }

  /// Retorna un widget que renderiza gráficamente el código QR
  /// Cumpliendo especificaciones: Error Correction M, alto contraste.
  static Widget buildQrWidget(String url) {
    return QrImageView(
      data: url,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.M,
      backgroundColor: Colors.white,
      padding: const EdgeInsets.all(16.0), // Margen mínimo
      size: 200.0,
      eyeStyle: const QrEyeStyle(
        eyeShape: QrEyeShape.square,
        color: Colors.black,
      ),
      dataModuleStyle: const QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.square,
        color: Colors.black,
      ),
    );
  }
}
