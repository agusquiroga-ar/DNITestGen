import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';
import '../models/identity.dart';

class NewDniGenerator {
  /// Genera el payload estructurado con delimitadores '@' para el código QR del nuevo eDNI.
  static String generateString(Identity identity) {
    final tramiteId = identity.tramiteId;
    
    // Validación estricta del número de trámite (suele rellenarse con ceros a la izq hasta 11)
    if (tramiteId.length != 11 || int.tryParse(tramiteId) == null) {
      throw ArgumentError('El número de trámite (id) para el nuevo DNI electrónico debe ser exactamente de 11 dígitos numéricos.');
    }

    final apellido = identity.apellido.toUpperCase();
    final nombre = identity.nombre.toUpperCase();
    final dni = identity.dni.toString();
    final ejemplar = identity.ejemplar;
    
    final dateFormat = DateFormat('dd/MM/yy');
    final fechaNac = dateFormat.format(identity.fechaNacimiento);
    final fechaEmi = dateFormat.format(identity.fechaEmision);

    // Generar un JWT simulado para desarrollo, en base al id del trámite, sin usar el algoritmo ni ejemplos reales.
    final header = base64Url.encode(utf8.encode('{"typ":"JWT","alg":"HS256"}')).replaceAll('=', '');
    
    // El payload inserta dinámicamente el id del trámite actual (sin ceros)
    final tramiteSinCeros = int.parse(tramiteId).toString();
    final payload = base64Url.encode(utf8.encode('{"id_tramite":"$tramiteSinCeros"}')).replaceAll('=', '');
    
    // Firma simulada genérica
    final dummySignature = "ABCDEFGHIJabcdefghij0123456789ABCDEFGHIJabcdefghij0123456789ABCDEFGHIJabcdefghij0123456789ABCDEFGHIJabcdefghij0123456789ABCDEFGHIJabcdefghij0123456789ABCDEFGHIJabcdefghij0123456789ABCDEFGHIJabcdefghij0123456789ABCDEFGHIJabcdefghij0123456789";
    
    final jwt = "$header.$payload.$dummySignature";

    return '$tramiteId@$apellido@$nombre@$dni@$ejemplar@$fechaNac@$fechaEmi@$jwt';
  }

  /// Retorna un widget que renderiza gráficamente el código QR
  /// Cumpliendo especificaciones: Error Correction M, alto contraste, Version 15.
  static Widget buildQrWidget(String data) {
    return QrImageView(
      data: data,
      version: 15, // QR de alta densidad (Version 15 es estándar para este payload)
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
