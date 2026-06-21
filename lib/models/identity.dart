class Identity {
  final String nombre;
  final String apellido;
  final String sexo;
  final int dni;
  final String ejemplar;
  final String tramiteId;
  final DateTime fechaNacimiento;
  final DateTime fechaEmision;

  Identity({
    required this.nombre,
    required this.apellido,
    required this.sexo,
    required this.dni,
    required this.ejemplar,
    required this.tramiteId,
    required this.fechaNacimiento,
    required this.fechaEmision,
  });

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'sexo': sexo,
      'dni': dni,
      'ejemplar': ejemplar,
      'tramiteId': tramiteId,
      'fechaNacimiento': fechaNacimiento.toIso8601String(),
      'fechaEmision': fechaEmision.toIso8601String(),
    };
  }

  factory Identity.fromJson(Map<String, dynamic> json) {
    return Identity(
      nombre: json['nombre'] as String,
      apellido: json['apellido'] as String,
      sexo: json['sexo'] as String,
      dni: json['dni'] as int,
      ejemplar: json['ejemplar'] as String,
      tramiteId: json['tramiteId'] as String,
      fechaNacimiento: DateTime.parse(json['fechaNacimiento'] as String),
      fechaEmision: DateTime.parse(json['fechaEmision'] as String),
    );
  }

  @override
  String toString() {
    return 'Identity(nombre: $nombre, apellido: $apellido, sexo: $sexo, dni: $dni, ejemplar: $ejemplar, tramiteId: $tramiteId)';
  }
}
