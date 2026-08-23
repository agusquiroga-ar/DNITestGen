import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/identity.dart';

class NewDniGenerator {
  /// Construye la URL de validación oficial parametrizada para el código QR del eDNI.
  static String generateUrl(Identity identity) {
    final tramiteId = identity.tramiteId;

    // Validación estricta del número de trámite
    if (tramiteId.length != 11 || int.tryParse(tramiteId) == null) {
      throw ArgumentError(
        'El número de trámite (id) para el nuevo DNI electrónico debe ser exactamente de 11 dígitos numéricos.',
      );
    }

    final dni = identity.dni.toString();
    final sexo = identity.sexo;
    final ejemplar = identity.ejemplar;
    // Se extrae la fecha de emisión en formato dd/MM/yyyy o yyyy-MM-dd según sea necesario.
    // Usaremos ISO-8601 por ser una URL o simplemente la pasamos como string, ej. yyyy-MM-dd
    final fechaEmision =
        "${identity.fechaEmision.year.toString().padLeft(4, '0')}-${identity.fechaEmision.month.toString().padLeft(2, '0')}-${identity.fechaEmision.day.toString().padLeft(2, '0')}";

    return 'https://validar.mi.argentina.gob.ar/validar?id=$tramiteId&dni=$dni&sexo=$sexo&ejemplar=$ejemplar&fechaEmision=$fechaEmision';
  }

  /// Retorna un widget que renderiza gráficamente el código QR
  /// Cumpliendo especificaciones: Error Correction M, alto contraste.
  static Widget buildQrWidget(String url) {
    return QrImageView(
      data: url,
      version:
          10, // Forzado a versión 10 (alta densidad) como indica la especificación
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
