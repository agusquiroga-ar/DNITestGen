import 'identity.dart';
import 'dni_type.dart';

class GeneratedCodeRecord {
  final Identity identity;
  final DniType type;
  final DateTime generatedAt;

  GeneratedCodeRecord({
    required this.identity,
    required this.type,
    required this.generatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'identity': identity.toJson(),
      'type': type.name,
      'generatedAt': generatedAt.toIso8601String(),
    };
  }

  factory GeneratedCodeRecord.fromJson(Map<String, dynamic> json) {
    return GeneratedCodeRecord(
      identity: Identity.fromJson(json['identity'] as Map<String, dynamic>),
      type: DniType.values.byName(json['type'] as String),
      generatedAt: DateTime.parse(json['generatedAt'] as String),
    );
  }

  bool matchesSearch(String query) {
    if (query.trim().isEmpty) return true;
    
    final cleanQuery = _normalize(query.trim());
    final tokens = cleanQuery.split(RegExp(r'\s+')).where((t) => t.isNotEmpty).toList();
    if (tokens.isEmpty) return true;

    final dniStr = identity.dni.toString();
    final dniFormatted = dniStr.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );

    final nacDay = identity.fechaNacimiento.day.toString().padLeft(2, '0');
    final nacMonth = identity.fechaNacimiento.month.toString().padLeft(2, '0');
    final nacYear = identity.fechaNacimiento.year.toString();
    final nacShortYear = nacYear.length >= 2 ? nacYear.substring(nacYear.length - 2) : nacYear;

    final emiDay = identity.fechaEmision.day.toString().padLeft(2, '0');
    final emiMonth = identity.fechaEmision.month.toString().padLeft(2, '0');
    final emiYear = identity.fechaEmision.year.toString();
    final emiShortYear = emiYear.length >= 2 ? emiYear.substring(emiYear.length - 2) : emiYear;

    final sexoDesc = identity.sexo.toUpperCase() == 'M'
        ? 'masculino varon'
        : (identity.sexo.toUpperCase() == 'F' ? 'femenino mujer' : 'no binario x');

    final typeLabel = type == DniType.oldVersion
        ? 'viejo pdf417 version vieja codigo de barras barras'
        : 'nuevo qr version nueva edni digital';

    final genDay = generatedAt.day.toString().padLeft(2, '0');
    final genMonth = generatedAt.month.toString().padLeft(2, '0');
    final genYear = generatedAt.year.toString();

    final allValues = [
      identity.nombre,
      identity.apellido,
      '${identity.apellido} ${identity.nombre}',
      '${identity.nombre} ${identity.apellido}',
      identity.sexo,
      sexoDesc,
      dniStr,
      dniFormatted,
      identity.ejemplar,
      'ejemplar ${identity.ejemplar}',
      identity.tramiteId,
      '$nacDay/$nacMonth/$nacYear',
      '$nacDay-$nacMonth-$nacYear',
      '$nacYear-$nacMonth-$nacDay',
      '$nacDay/$nacMonth/$nacShortYear',
      '$emiDay/$emiMonth/$emiYear',
      '$emiDay-$emiMonth-$emiYear',
      '$emiYear-$emiMonth-$emiDay',
      '$emiDay/$emiMonth/$emiShortYear',
      '$genDay/$genMonth/$genYear',
      typeLabel,
      type.name,
    ].join(' ');

    final normalizedTarget = _normalize(allValues);

    return tokens.every((token) => normalizedTarget.contains(token));
  }

  static String _normalize(String input) {
    return input
        .toLowerCase()
        .replaceAll(RegExp(r'[áàäâ]'), 'a')
        .replaceAll(RegExp(r'[éèëê]'), 'e')
        .replaceAll(RegExp(r'[íìïî]'), 'i')
        .replaceAll(RegExp(r'[óòöô]'), 'o')
        .replaceAll(RegExp(r'[úùüû]'), 'u')
        .replaceAll(RegExp(r'[ñ]'), 'n');
  }
}
