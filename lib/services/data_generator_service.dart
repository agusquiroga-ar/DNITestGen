import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import '../models/identity.dart';

class DataGeneratorService {
  final Random _random = Random();
  List<String> _names = [];
  List<String> _surnames = [];
  bool _isLoaded = false;

  Future<void> loadDictionaries() async {
    if (_isLoaded) return;
    
    try {
      final namesData = await rootBundle.load('assets/names.json');
      final surnamesData = await rootBundle.load('assets/surnames.json');

      final namesString = utf8.decode(namesData.buffer.asUint8List());
      final surnamesString = utf8.decode(surnamesData.buffer.asUint8List());

      final List<dynamic> namesJson = json.decode(namesString);
      final List<dynamic> surnamesJson = json.decode(surnamesString);

      _names = namesJson.cast<String>();
      _surnames = surnamesJson.cast<String>();
      _isLoaded = true;
    } catch (e) {
      // Fallback in case of error (e.g., during tests without assets)
      _names = ['Juan', 'María'];
      _surnames = ['Pérez', 'Gómez'];
    }
  }

  Identity generateIdentity({int minDni = 10000000, int maxDni = 50000000}) {
    if (!_isLoaded || _names.isEmpty || _surnames.isEmpty) {
      throw Exception('Dictionaries not loaded. Call loadDictionaries() first.');
    }

    if (minDni > maxDni) {
      throw ArgumentError('minDni cannot be greater than maxDni');
    }

    final nombre = _names[_random.nextInt(_names.length)];
    final apellido = _surnames[_random.nextInt(_surnames.length)];
    
    final sexos = ['M', 'F', 'X'];
    final sexo = sexos[_random.nextInt(sexos.length)];
    
    final ejemplares = ['A', 'B', 'C', 'D'];
    final ejemplar = ejemplares[_random.nextInt(ejemplares.length)];
    
    final dni = minDni + _random.nextInt((maxDni - minDni) + 1);
    
    // Generar tramiteId de exactamente 9 dígitos
    final tramiteId = (100000000 + _random.nextInt(900000000)).toString();

    // Fecha de nacimiento aleatoria (entre 18 y 60 años atrás)
    final age = 18 + _random.nextInt(42);
    final now = DateTime.now();
    final fechaNacimiento = DateTime(now.year - age, _random.nextInt(12) + 1, _random.nextInt(28) + 1);
    
    // Fecha de emisión aleatoria (entre hace 1 año y hoy)
    final fechaEmision = now.subtract(Duration(days: _random.nextInt(365)));

    return Identity(
      nombre: nombre,
      apellido: apellido,
      sexo: sexo,
      dni: dni,
      ejemplar: ejemplar,
      tramiteId: tramiteId,
      fechaNacimiento: fechaNacimiento,
      fechaEmision: fechaEmision,
    );
  }

  // Permite inyectar datos para testing
  void setTestData(List<String> names, List<String> surnames) {
    _names = names;
    _surnames = surnames;
    _isLoaded = true;
  }
}
